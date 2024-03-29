'''Options to Markdown and HTML.

Usage:
    options.py html PATHIN PATHOUT
    options.py markdown PATHIN PATHOUT
    options.py (-h | --help)

Options:
    -h --help   Show this screen.
'''
from functools import reduce
import json
from pathlib import Path
import re
from typing import Any

from bs4 import BeautifulSoup, Tag
from docopt import docopt
from markdown_it import MarkdownIt


def main(args):
    if args['html']:
        to_html(args['PATHIN'], args['PATHOUT'])
    if args['markdown']:
        to_commonmark(args['PATHIN'], args['PATHOUT'])


def to_html(pathin: Path, pathout: Path):
    commonmark = _to_commonmark(pathin)
    md = MarkdownIt()
    html = md.render(commonmark)

    # without soup
    #with open(pathout, 'w', encoding='utf-8') as fout:
    #    fout.write(html)

    # with soup
    soup = nest_options_in_dom(html)
    with open(pathout, 'w') as fout:
        fout.write(str(soup))


def to_commonmark(pathin: Path, pathout: Path):
    commonmark = _to_commonmark(pathin)
    with open(pathout, 'w', encoding='utf-8') as fout:
        fout.write(commonmark)


def _to_commonmark(path: Path):
    return json_to_commonmark(nest_json_children(get_json(path)))


def get_json(path: Path) -> dict:
    '''Returns a JSON file from a given path as dictionary.'''
    with open(path, 'r') as fin:
        return json.load(fin)


def nest_json_children(data: dict) -> dict:
    '''Takes a flat JSON object and nests children based on key strings.

    The JSON object created from NixOS module options has all options listed at
    the top level. The goal is to find options that are sub-options and append
    them as children to their parent option.

    The function iterates forward through the object. If the current key starts
    with the previous key, the current key is appended as a child of the
    previous key. This carries on until there is no match and then the current
    key becomes the new previous key.

    Args:
        data: The flat JSON object.

    Returns:
        The nested JSON object.
    '''
    key_list = []
    # Key to store nested options.
    nesting_key = "children"

    for current_key, current_value in data.copy().items():
        for previous_key in reversed(key_list):
            # Grabs the next key from the key list and checks if the current
            # key is a child. Need the '+ "."' because 'kernel.rust' starts
            # with 'kernel.r' but not 'kernel.r.'.
            if current_key.startswith(previous_key + "."):
                # Insert the nesting key in between the key list elements and
                # get the object associated with the previous key to store the
                # current key as a child.
                key_list_with_children = intersperse(key_list, nesting_key)
                previous_object = reduce(lambda obj, key: obj[key],
                                         key_list_with_children,
                                         data)

                # First time adding a child.
                if nesting_key not in previous_object:
                    previous_object[nesting_key] = {}

                # Add the child, delete it from the top level, and append its
                # key to the key list in case the next key is a child of the
                # current.
                previous_object[nesting_key][current_key] = data[current_key]
                del data[current_key]
                key_list.append(current_key)
                break
            else:
                # If the current key is not a child, pop the last element from
                # the key list and check the next level up.
                key_list.pop()

        # Used in the first iteration and when the current key has no parent.
        if len(key_list) == 0:
            key_list.append(current_key)

    return data


def intersperse(lst: list, elem: Any) -> list:
    '''Put a new element between all the entries in a list.

    Note:
        Only safe where `elem` is immutable. If `elem` is mutable, then all
        copies in the list point to the same reference.

    Args:
        lst: The list
        elem: The element to intersperse in the list.

    Returns:
        The new list.

    Examples:
        >>> intersperse([1, 2, 3, 4], 0)
        [1, 0, 2, 0, 3, 0, 4]

        >>> intersperse(['a', 'b', 'c'], 'z')
        ['a', 'z', 'b', 'z', 'c']
    '''
    result = [elem] * (len(lst) * 2 - 1)
    result[0::2] = lst
    return result


class OptionsEncoder(json.JSONEncoder):
    def encode(self, obj):
        try:
            return self.nix_handler(obj)
        except TypeError:
            pass

        return super().encode(obj)

    def nix_handler(self, obj):
        # Unpack literal expressions and other Nix types.
        # Don't escape the strings: they were escaped when initially serialized to JSON.
        if isinstance(obj, list):
            return super().encode([self.nix_handler(elem) for elem in obj])
        if isinstance(obj, dict):
            _type = obj.get('_type')
            if _type is not None:
                if _type == 'literalExpression' or _type == 'literalDocBook':
                    return obj['text']

                if _type == 'derivation':
                    return obj['name']

                raise Exception(f'Unexpected type `{_type}` in {json.dumps(obj)}')

        return super().encode(obj)


def json_to_commonmark(data: dict, markdown: str = "", header: str = "## ") -> str:
    '''Creates a CommonMark compliant markdown from JSON similar to how optionsCommonMark and generateDoc.py do in nixpkgs.

    See the following for reference.
    https://github.com/NixOS/nixpkgs/blob/42ad7722055405860eadccee37327de3a3fe9f00/nixos/lib/make-options-doc/default.nix#L103
    https://github.com/NixOS/nixpkgs/blob/42ad7722055405860eadccee37327de3a3fe9f00/nixos/lib/make-options-doc/generateDoc.py#L37

    Unlike the aforementioned functions, this function is recursive. The reason
    is so that children are converted to a header level one lower than their
    parent. This makes it easier to nest options in the DOM.

    Args:
        jsonObj: A nested JSON object.
        markdown: Initial markdown that content is added to.
        header: The header level of the current keys being converted.

    Returns:
        The resulting markdown.

    '''
    for key, value in data.items():
        markdown += "".join([
            header,
            key.replace('<', '&lt;').replace('>', '&gt;'),
            "\n",
        ])
        markdown += "".join([
            value["description"]
                .strip(' \n')
                .replace('\n', ' '),
            "\n\n"
        ])

        if ('type' in value):
            markdown += "".join(["_Type_:", "\n"])
            markdown += "".join([value['type'], "\n\n"])

        if ('default' in value):
            default_value = json.dumps(value['default'], cls=OptionsEncoder)
            default_value = default_value.replace(u'\u2039', '<').replace(u'\u203a', '>')

            markdown += "".join(["_Default_:", "\n\n"])
            markdown += "".join([
                "```",
                "\n",
                default_value,
                "\n",
                "```",
                "\n\n"
            ])

        if ('example' in value):
            example_value = json.dumps(value['example'], cls=OptionsEncoder)

            example_value = (example_value
                .replace('\\n', '\n')
                .replace('\\"', '"')
                .strip()
            )

            markdown += "".join(["_Example_:", "\n\n"])
            markdown += "".join([
                "```",
                "\n",
                example_value,
                "\n",
                "```",
                "\n\n"
            ])

        if ('children' in value):
            markdown = json_to_commonmark(value["children"], markdown, "#" + header)

    markdown = re.sub("(?:\\[rn])+", "\n", markdown)

    return markdown


def nest_options_in_dom(html: str) -> BeautifulSoup:
    '''Nests options with lower heading levels under those with higher.

    The function loops over all possible headings from lowest to highest level,
    and then through the elements where the markdown is stored in reverse
    order. If the current element is not a header, it is appended to a child
    list. If a heading is encountered that is higher than the current heading
    level being searched, the child list is reset. Finally, if a heading level
    of the current iteration is encountered, the children are moved to a
    content container and the heading is replaced with a button.

    Args:
        html: The options content converted from markdown.

    Returns:
        The restructured options content.
    '''
    soup = BeautifulSoup(html, 'html.parser')
    headers = ['h' + str(level) for level in reversed(range(2, 7))]
    child_list = []

    # Go through the options elements in the DOM in reverse order. This was the
    # easiest way as you can collect elements in a list and relocate them as
    # appropriate or reset the list. Going forward through the elements is much
    # more complicated.
    for header_idx, header_tag in enumerate(headers):
        # not pretty but quickest way I found to iterate through all children in reverse
        for child_elem in reversed(list(soup.children)):
            if header_tag == child_elem.name:
                # Current element is a heading of the current iteration.

                # Create a new container for the content under the option and
                # add the content. Empty the child list for the next iteration.
                # Headings lower than H2 can be children of higher headings.
                content_container = soup.new_tag("ul")
                child_elem.insert_after(content_container)
                add_class(content_container, 'collapsible-content')
                add_style(content_container, 'display: flow-root;')
                for child in reversed(child_list):
                    child_li = soup.new_tag("li")
                    child_li.append(child)
                    content_container.append(child_li)
                child_list = []

                # Put the header and content in a DIV. This is needed for child
                # options so that the content does get a second list item
                # marker.
                wrapper_div = soup.new_tag("div")
                add_class(wrapper_div, 'collapsible-container')
                child_elem.insert_before(wrapper_div)
                wrapper_div.append(child_elem)
                wrapper_div.append(content_container)

                # Replace header with button for better functionality and aria.
                button_elem = soup.new_tag("button")
                button_elem['type'] = "button"
                add_class(button_elem, 'md-typeset', 'option-button')
                button_elem.contents = child_elem.contents
                child_elem.replace_with(button_elem)

                # Add aria info.
                option_path = (button_elem.contents[0]
                    .replace('.', '-')
                    .replace('<', '')
                    .replace('>', '')
                )
                button_elem['aria-controls'] = option_path
                content_container['id'] = option_path
                button_elem['aria-label'] = option_path.replace('-', ' ')
                button_elem['aria-expanded'] = 'true'

                add_kernel_icon(soup, button_elem)
                add_anchor(soup, button_elem, option_path)
                add_expand_all_button(soup, content_container)

            elif child_elem.name in headers[header_idx + 1:]:
                child_list = []
            elif child_elem != "\n":
                child_list.append(child_elem)

    soup.smooth()
    sections = ['JupyterLab', 'Kernel']
    for option in soup.children:
        if option.name is None:
            continue

        for section in sections:
            if re.fullmatch(f"^{section.lower()}.*", option.button.string.strip()):
                title = soup.new_tag("h2")
                title.string = section + " Options"
                option.insert_before(title)
                sections.remove(section)
                skip = True
                break

    return soup


def add_kernel_icon(soup: BeautifulSoup, elem: Tag) -> None:
    '''Adds kernel logos as an icon next to options.

    Mutates the tag. Looks for options with names like "kernel.<name>"

    Args:
        soup: The whole HTML document.
        elem: The tag where the logo will be added.
    '''
    match = re.fullmatch("^kernel\.([a-z]*)$", elem.contents[0])
    if match:
        kernel_name = match.group(1)
        img_elem = soup.new_tag("img")
        add_class(img_elem, 'kernel-logo')
        img_elem['src'] = "../../assets/logos/kernels/" + kernel_name + "-logo.svg"
        img_elem['alt'] = kernel_name + " kernel logo"

        img_cont = soup.new_tag("div")
        add_class(img_cont, 'kernel-logo-container')
        img_cont.insert(0, img_elem)

        elem.insert_before(img_cont)


def add_anchor(soup: BeautifulSoup, button: Tag, href: str) -> None:
    '''Adds an anchor element next to options.

    Mutates the soup.

    Args:
        soup: The whole HTML document.
        button: The button element where the anchor will be inserted after.
        href: The content ID to link to in the anchor.
    '''
    anchor = soup.new_tag("a")
    add_class(anchor, 'option-link', 'md-button')
    anchor['href'] = '#' + href
    anchor['title'] = 'Copy permanent link'
    anchor.append(get_svg_anchor(soup))

    anchor_container = soup.new_tag("div")
    add_class(anchor_container, 'option-link-container')

    anchor_container.insert(0, anchor)
    button.insert_after(anchor_container)


def add_expand_all_button(soup: BeautifulSoup, elem: Tag) -> None:
    '''Adds a button to toggle open/close all children if it has any.

    Mutates the tag.

    Args:
        soup: The whole HTML document.
        elem: The tag where the button will be added.
    '''
    if elem.find('button', {'class', 'option-button'}):
        # create and add button
        button_elem = soup.new_tag("button")
        button_elem['type'] = "button"
        add_class(button_elem, 'md-button', 'toggle-children')
        add_style(button_elem, 'display: none;')
        elem.insert(0, button_elem)

        # aria
        button_elem['aria-label'] = elem['id'].replace('-', ' ') + " toggle children"
        button_elem['aria-expanded'] = 'true'


def add_class(elem: Tag, *classes: str) -> None:
    '''Adds any number of classes to an HTML tag.

    Mutates the tag.

    Args:
        elem: The tag to add classes to.
        *classes: Variable number of classes to add.
    '''
    elem['class'] = elem.get('class', []) + list(classes)


def add_style(elem: Tag, style: str) -> None:
    '''Adds a style to an HTML tag.

    Mutates the tag.

    Args:
        elem: The tag to add the style to.
        style: The style to add.
    '''
    elem['style'] = elem.get('style', '') + style


def get_svg_anchor(soup: BeautifulSoup) -> Tag:
    elem = soup.new_tag("svg")
    elem['aria-hidden'] = 'true'
    elem['width'] = '1em'
    elem['height'] = '1em'

    svg_path = soup.new_tag("path")
    svg_path['fill-rule'] = 'evenodd'
    svg_path['d'] = 'M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z'

    elem.insert(0, svg_path)
    return elem


if __name__ == '__main__':
    arguments = docopt(__doc__)
    main(arguments)

