# [CS 247 Test Script](test.sh)

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
test.sh
```

- The script will look into a1/* and test questions 1 and 2
  1. It will compile your `.cc` and `.h` files automatically and link it to a executable called `prog`
  2. It will run `prog` against `a1q*` where `*` is question 1 or 2 and show you a diff, along with a memory leak summary using `valgrind`
- Place your tests ending in `.in` anywhere inside the question folder (you can have a subdirectory for tests)

It outputs the diff (if any) or memory errors (if any) as well as indicator of the tests run:
- `F` indicates diff doesn't match
- `M` indicates a memory issue
- `S` indicates a segfault
- `.` indicates a pass

**Note**: You can optionally pass in the specific question `./test.sh 1` to only run tests for that question. You can also specify the test to run for a specific question `./test.sh 1 test.in`, which will only run test.in against a1q1.

**Additional Note:** You can make the script test a2/, a3/, etc. by modifying the variable `i` in `test.sh`. 
