import os
from testbook import testbook

current_dir = os.path.dirname(os.path.abspath(__file__))

@testbook(f'{current_dir}/test.ipynb', execute=False, kernel_name="example-javascript-minimal")
def test_nb(tb):
    result = tb.cell_output_text(0)
    print("Output:")
    print(result)
    assert result == "'hello javascript'"

if __name__ == '__main__':
    test_nb()

