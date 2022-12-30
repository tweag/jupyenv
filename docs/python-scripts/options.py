'''Options to Markdown and HTML.

Usage:
    options.py html PATHIN PATHOUT
    options.py markdown PATHIN PATHOUT
    options.py (-h | --help)

Options:
    -h --help   Show this screen.
'''
import codecs
from functools import reduce
import json
from pathlib import Path
import re
from typing import Any

from bs4 import BeautifulSoup
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
    with open(pathout, 'wb') as fout:
        fout.write(soup.prettify('utf-8'))


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
    key_list = []
    nesting_key = "children"

    for current_key, current_value in data.copy().items():
        for previous_key in reversed(key_list):
            if current_key.startswith(previous_key):
                key_list_with_children = intersperse(key_list, nesting_key)
                previous_object = reduce(lambda obj, key: obj[key],
                                         key_list_with_children,
                                         data)

                if nesting_key not in previous_object:
                    previous_object[nesting_key] = {}

                previous_object[nesting_key][current_key] = data[current_key]
                del data[current_key]
                key_list.append(current_key)
                break
            else:
                key_list.pop()

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


def json_to_commonmark(data, markdown = "", header = "## "):
    for key, value in data.items():

        markdown += "".join([header,
                            key.replace('<', '&lt;').replace('>', '&gt;'),
                            "\n"])
        markdown += "".join([value["description"], "\n\n"])

        if ('type' in value):
            markdown += "".join(["_Type_:", "\n"])
            markdown += "".join([value['type'], "\n\n"])

        if ('default' in value):
            default_value = json.dumps(value['default'])
            default_value = codecs.decode(default_value, 'unicode_escape')

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
            example_value = json.dumps(value['example'])

            if value['type'] not in ('string', 'boolean'):
                # remove the surrounding double quotes.
                # strip('"') doesn't work as desired in all cases
                example_value = example_value[1:-1]

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


def nest_options_in_dom(html):
    soup = BeautifulSoup(html, 'html.parser')
    headers = ['h' + str(level) for level in reversed(range(2, 7))]
    child_list = []

    for header_idx, header_elem in enumerate(headers):
        # not pretty but quickest way I found to iterate through all children in reverse
        for child_elem in reversed(list(soup.children)):
            if header_elem == child_elem.name:
                content_div = soup.new_tag("ul")
                child_elem.insert_after(content_div)
                content_div['class'] = content_div.get('class', []) + ['collapsibleContentContainer']
                for child in reversed(child_list):
                    child_li = soup.new_tag("li")
                    child_li.append(child)
                    content_div.append(child_li)
                child_list = []

                header_div = soup.new_tag("div")
                child_elem.insert_before(header_div)
                header_div['class'] = header_div.get('class', []) + ['collapsibleHeaderContainer']
                child_elem['class'] = child_elem.get('class', []) + ['collapsibleHeader']
                header_div.append(child_elem)

                wrapper_div = soup.new_tag("div")
                header_div.insert_before(wrapper_div)
                wrapper_div.append(header_div)
                wrapper_div.append(content_div)

                # make options focusable
                header_div['tabindex'] = "0"
            elif child_elem.name in headers[header_idx + 1:]:
                child_list = []
            elif child_elem != "\n":
                child_list.append(child_elem)

    for child in soup.find_all("div", recursive=False):
        top_li = soup.new_tag("li")
        child.insert_before(top_li)
        top_li.append(child)

    top_ul = soup.new_tag("ul")
    soup.li.insert_before(top_ul)
    top_ul.extend(soup.find_all("li", recursive=False))

    return soup


if __name__ == '__main__':
    arguments = docopt(__doc__)
    main(arguments)

