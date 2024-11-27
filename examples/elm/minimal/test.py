import os
from testbook import testbook

current_dir = os.path.dirname(os.path.abspath(__file__))

@testbook(f"{current_dir}/test.ipynb", execute=True, kernel_name="elm-minimal-example", timeout=240)
def test_nb(tb):
    result = tb.execute_cell(0)["outputs"][0]["data"]
    assert "text/html" in result
    assert "elm-div-2" in result["text/html"]

if __name__ == '__main__':
    test_nb()

