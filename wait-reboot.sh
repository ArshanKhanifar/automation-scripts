echo 'beginning to reboot'
while ! timeout 5 ssh -i ~/.ssh/packet_rsa root@$(cat /tmp/ip) exit; do
	echo 'not connected';
	sleep 1
done
echo 'connected'

