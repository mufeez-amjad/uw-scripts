#!/bin/bash

failed_names=()
failed_out=()
failed_sample=()
failed_diff=()
tests_res=()

function run_test() {
    test=$1
    test_name=$2
		exec=$3
		sample=$4
    tmpfile=$(mktemp "$test_name".XXXXXX)
		tmpfile2=$(mktemp "$test_name"_sample.XXXXXX)
    ./$exec < $test 2> /dev/null 1>$tmpfile
		out1_return=$? #139 if seg fault
		./$sample < $test > $tmpfile2
		out2_return=$?
		diff=$(diff $tmpfile $tmpfile2)
    different=$?
    valgrind=$(valgrind --leak-check=full --track-origins=yes --error-exitcode=1 $exec < $test 2>&1)
    is_mem_leak=$? #$?
    if [ $different != 0 ] || [ $is_mem_leak == 1 ] || [ $out1_return == 139 ]
		then
			failed_names+=($test)
			if [ $out1_return == 139 ]
			then
				failed_out+=("segmentation fault")
				if [ $out2_return == 139 ]
				then
					failed_sample+=("segmentation fault")
				else
					failed_sample+=("")
				fi
				failed_diff+=("")
				printf 'S'
				tests_res+=('S')
			else
				if [ "$diff" != "" ]
				then
					out1=$(cat $tmpfile)
					out2=$(cat $tmpfile2)
					failed_out+=("$out1")
					failed_sample+=("$out2")
					failed_diff+=("$diff")
					tests_res+=('F')
					printf 'F'
				else
					failed_out+=("$valgrind")
					failed_sample+=("")
					failed_diff+=("")
					tests_res+=('M')
					printf 'M'
				fi
			fi
		else
			tests_res+=('.')
			printf '.'
			rm "$tmpfile"
			rm "$tmpfile2"
		fi
}

i=2 # assignment number
for j in 1 2 # questions - q0,etc.
do
	if [ -n "$1" ]
	then
		if [ $j != $1 ]
		then
			continue
		fi
	fi

	regex=".*a$i\/q$j.*\.in"

	if [ -n "$2" ]
	then
		if [ $2 != "" ]
		then
			regex=".*a$i\/q$j.*$2"
		fi
	fi

	tests=$(find . -regex "$regex")
	echo "$tests"

	q_dir=a$i/q$j
	if test -n "$(find $q_dir -regex '.*Makefile')"; then
		(cd $q_dir/ && make clean && make)
	elif test -n "$(find $q_dir -regex '.*.cc')"; then
		cc_files=$(ls -A $q_dir/*.cc)
		g++ -o $q_dir/prog -w $cc_files -O0 -g # note: warnings omitted
	else
		echo "WARNING no compilation ran"
	fi

	for test in $tests
	do
		size=${#test}
		substr_len=$(expr ${size} - 3)
		test_name="${test:0:$substr_len}"
		run_test $test $test_name $q_dir/prog $q_dir/a"$i"q$j
	done
done

printf '\n\n'
for i in "${!failed_names[@]}"
do
	echo "${failed_names[$i]}"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
	echo "${failed_out[$i]}"
	printf '\n'
	if [ "${failed_sample[$i]}" != "" ]
	then
		echo Sample:
		echo "${failed_sample[$i]}"
		printf '\n'
	fi
	if [ "${failed_diff[$i]}" != "" ]
	then
		echo Diff:
		echo "${failed_diff[$i]}"
		printf '\n'
	fi
done

printf %s "${tests_res[@]}"
printf '\n'

passed=$(expr ${#tests_res[@]} - ${#failed_names[@]})

echo $passed/${#tests_res[@]} tests passed!
