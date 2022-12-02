import os
from testbook import testbook

current_dir = os.path.dirname(os.path.abspath(__file__))

@testbook(f'{current_dir}/test.ipynb', execute=True, kernel_name="example-postgres-minimal")
def test_nb(tb):
    result = tb.cell_output_text(0)
    print("Output:")
    print(result)
    assert result == "Failed to connect to a database at postgres://brian:password@localhost:5432/dbname"

if __name__ == '__main__':
    test_nb()

