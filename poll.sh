
false

while kill -0 $(cat /tmp/sleeping.pid); do
	echo 'still sleeping';
	sleep 1
done;

echo 'DONE SLEEPING'
