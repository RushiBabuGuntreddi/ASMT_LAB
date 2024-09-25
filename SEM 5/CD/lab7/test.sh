make
mkdir -p outputs
for i in {1..8}
do
    ./a.out < inputs/input$i.txt > outputs/output$i.txt
    # if no diff, then print "Test $i passed" in green color, else print "Test $i failed" in red color
    diff  outputs/output$i.txt expected_outputs/output$i.txt
    if [ $? -eq 0 ]
    then
        echo -e "\033[32mTest $i passed\033[0m"
    else
        echo  -e "\033[31mTest $i failed\033[0m"
    fi
done

make clean