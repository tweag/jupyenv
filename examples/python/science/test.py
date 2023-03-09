import os
from testbook import testbook

current_dir = os.path.dirname(os.path.abspath(__file__))

@testbook(f'{current_dir}/test.ipynb', execute=True, kernel_name="python-science-example")
def test_nb(tb):
    np_result = tb.cell_output_text(1)
    assert np_result == "[0 1 2 3 4]"

    sp_result = tb.cell_output_text(2)
    assert sp_result == "[ 0.5  2.5  6.5 12.5]"

    mpl_result = tb.cell_output_text(3)
    assert mpl_result == "(0.122312, 0.633153, 0.530398, 1.0)"

if __name__ == '__main__':
    test_nb()

