set -e 
while $ssx 'kill -0 $(cat /tmp/'$1'.pid) 2> /dev/null'; do
	echo 'wait not done'
	sleep 1
done;

echo 'wait done'

