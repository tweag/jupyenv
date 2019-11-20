#! /usr/bin/env nix-shell
#! nix-shell -p "python3.withPackages(p: with p; [termcolor])" -i python

'''
A simple tester for JupyterWith. Run it like:

    test/test.py example/Go/basic

to only run tests in a given folder, or:

    test/test.py

to run it on all examples.
'''

import io
import os
import subprocess
import sys

from termcolor import colored

def nix_shell(path, command, message):
    '''
    Execute a command in a Nix shell.
    '''
    print('- {}: {}'.format(path, message), end=" ")
    sys.stdout.flush()
    proc = subprocess.Popen(
        args=[
            'nix-shell',
            '--pure',
            '--command',
            command,
        ],
        cwd=path,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    out, err = proc.communicate()
    if proc.returncode == 0:
       print(format(colored('SUCCESS', 'green')))
    else:
       print(format(colored('ERROR', 'red')))
       print('')
       if out is not None:
           print('    STDOUT:')
           print('')
           print(out.decode('utf-8'))
           print('')
       if err is not None:
           print('    STDERR:')
           print('')
           print(err.decode('utf-8'))
           print('')

def notebook_build(path):
    '''
    Build the notebook environment and print the version.
    '''
    nix_shell(
        path,
        'jupyter --version', 'building...',
    )

def notebook_convert(path):
    '''
    Convert the notebook and reexecute its cells.
    '''
    nix_shell(
      path,
      'jupyter nbconvert --stdout --execute *.ipynb', 'executing...',
    )

try:
    folder = sys.argv[1]
    notebook_build(folder)
    notebook_convert(folder)

except:
    folders = []

    for tup in os.walk('example'):
        path = tup[0]
        if len(path.split('/')) == 3:
            folders.append(path)

    for folder in folders:
        notebook_build(folder)
        notebook_convert(folder)
        print('')
