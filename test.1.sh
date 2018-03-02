set -e
echo $$ > /tmp/test.1.pid
echo 'EXECUTING TEST 1'
echo 'blah blah blah'
sleep 4


echo 'after test stuff'
echo 'test 1 done' > test.1.done
