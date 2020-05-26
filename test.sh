#!/bin/bash

failed_names=()
failed_out=()
failed_sample=()
failed_diff=()
tests_res=()

i=1 # assignment number
for j in 0 1 2 # questions - q0,etc.
do
	if [ -n "$1" ]
	then
		if [ $j != $1 ]
		then
			continue
		fi
	fi

	regex=".*a$i\/q$j.*.in"

	if [ -n "$2" ]
	then
		if [ $2 != "" ]
		then
			regex=".*a$i\/q$j.*$2"
		fi
	fi

	tests=$(find . -regex "$regex")

	q_dir=a$i/q$j
	if test -n "$(find $q_dir -regex '.*.cc')"
	then
		cc_files=$(ls -A $q_dir/*.cc)
		g++ -o $q_dir/prog -w $cc_files # note: warnings omitted
	fi

	for test in $tests
	do 
		file1=$q_dir/prog
		file2=$q_dir/a"$i"q"$j"
		out1=$($file1 < $test)
		out2=$($file2 < $test)
		diff=$(diff <($file1 < $test) <($file2 < $test))
		if [ "$diff" != "" ]
		then
			failed_names+=($test)
			failed_out+=("$out1")
			failed_sample+=("$out2")
			failed_diff+=("$diff")
			tests_res+=('F')
		else
			tests_res+=('.')
		fi
	done
done


for i in "${!failed_names[@]}"
do
	echo "${failed_names[$i]}"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
	echo "${failed_out[$i]}"
	printf '\n'
	echo Sample:
	echo "${failed_sample[$i]}"
	printf '\n'
	echo Diff:
	echo "${failed_diff[$i]}"
	printf '\n'
done

printf %s "${tests_res[@]}"
printf '\n'

passed=$(expr ${#tests_res[@]} - ${#failed_names[@]})

echo $passed/${#tests_res[@]} tests passed!

