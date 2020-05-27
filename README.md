# uw-scripts
A collection of QOL scripts that I use at UW.

1. [test.sh](#testsh)

## [test.sh](/test.sh)

Essentially a test suite. This script runs all your tests against a sample executable (which returns the expected output) and your own compiled code, and returns the diff. It also checks for memory leaks using `valgrind`. 

The script works with the following directory structure:
```
a1/
  q1/
    a1q1
    example.cc
    test.in
    test2.in
  ...
...
test.sh
```

Tests must end in `.in` and must be located under the correct question directory ex. `a1/q1/`.

It outputs the diff (if any) or valgrind output (if errors exist) as well as indicator of the tests run:
- `F` indicates diff doesn't match
- `M` indicates a memory issue
- `.` indicates a pass

**Note**: You can optionally pass in the specific question and test: `./test.sh 1 test.in`, which will only run that one test against a1q1.
