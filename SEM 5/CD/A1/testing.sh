#!/usr/bin/env bash

# This script is used to test the functionality of the code

make
rm out.txt
touch out.txt

for i in {1,2,3,4,9,10}
do
    echo -n $i >> out.txt
    output=$(./a.out < testcases/valid/$i 2>&1)
    if [ -z "$(./a.out < testcases/valid/$i)" ]; then
        echo " Success" >> out.txt
    else
        ./a.out < testcases/valid/$i >> out.txt 2>&1
    fi
done

for i in {5,6,7,8,11,12}
do
    echo -n $i >> out.txt
    if [ -z "$(./a.out < testcases/invalid/$i)" ]; then
        echo " Fail" >> out.txt
    else
        echo -n " Success " >> out.txt
        ./a.out < testcases/invalid/$i >> out.txt 2>&1
    fi
done
# make clean