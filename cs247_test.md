# [CS 247 Test Script](cs247_test.sh)

This script should be placed in your root directory:
```
a1/
  q1/
    a1q1
    example.cc
    test.in
    test2.in
  ...
...
cs247_test.sh
```

- The script will look into a`i`/* and test questions `j`
  1. It will either use your makefile (if one exists) or compile your `.cc` and `.h` files with g++ and link it to an executable called `prog`
  2. It will run `prog` against `aiqj` and show you a diff, along with a memory leak summary using `valgrind`
  3. If the test fails, you can inspect the output in the temp files created with your test name.
- Place your tests ending in `.in` anywhere inside the question folder (you can have a subdirectory for tests)

It outputs the diff (if any) or memory errors (if any) as well as indicator of the tests run:
- `F` indicates diff doesn't match
- `M` indicates a memory issue
- `S` indicates a segfault
- `.` indicates a pass

**Note**: You can optionally pass in the specific question `./test.sh 1` to only run tests for that question. You can also specify the test to run for a specific question `./test.sh 1 test.in`, which will only run test.in against q1.
