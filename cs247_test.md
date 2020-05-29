# CS 247 Test Script

1. [test.sh](#testsh)

## [test.sh](/test.sh)

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
- Place your tests ending in `.in` inside the question folder

It outputs the diff (if any) or valgrind output (if errors exist) as well as indicator of the tests run:
- `F` indicates diff doesn't match
- `M` indicates a memory issue
- `.` indicates a pass

**Note**: You can optionally pass in the specific question and test: `./test.sh 1 test.in`, which will only run that one test against a1q1.

**Additional Note:** You can make the script test a2/, a3/, etc. by modifying the variables in `test.sh`. 
