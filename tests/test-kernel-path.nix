# This module defines a function for testing whether a kernel's executable
# is a real path. This helps catch issues where a kernel module can write a
# non-existent path which will build without any errors but fail at runtime.
{ runCommand, jq }:
kernel:
runCommand "test-kernel-path" { buildInputs = [ jq ]; } ''
  set -e

  # Check that the kernel's command exists and is executable. If it is not, throw an error.
  for spec in ${kernel.spec}/kernels/*/kernel.json; do
      echo "Testing kernel json spec: $spec"

      kernel_exe=$(jq --raw-output ".argv[0]" "$spec")
      if [[ -z $kernel_exe || $kernel_exe == "null" ]]; then 
          echo "No kernel exe found in the kernel json file."
          exit 1
      fi 

      echo "Looking for kernel executable: $kernel_exe"
      if [[ ! -x "$kernel_exe" ]]; then
          echo "The executable defined in kernel file $spec is invalid" 
          exit 1
      fi
  done
  mkdir $out
''
