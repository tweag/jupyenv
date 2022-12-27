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
    with open(pathout, 'w', encoding='utf-8') as fout:
        fout.write(html)


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


if __name__ == '__main__':
    arguments = docopt(__doc__)
    main(arguments)

