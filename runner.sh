set -e
export keypath=~/.ssh/packet_rsa
export ip_addr=$(cat /tmp/ip)
export scriptname=spectreV2
export ssx="ssh -i $keypath root@$ip_addr"
export scx="scp -i $keypath"

if ! [ -z $SETUP ]; then
	$scx setup.sh root@$ip_addr:/root/setup.sh;
	$ssx "sh -c 'nohup sh setup.sh > setup.out 2> setup.err &'";
	./wait-task-done.sh setup;
	$ssx "cat setup.done 2> /dev/null"
	echo 'update done'
fi;

for i in $(jot 4); do
	$scx $scriptname.$i.sh root@$ip_addr:/root/$scriptname.$i.sh;
	$ssx "nohup sh $scriptname.$i.sh > $scriptname.$i.out 2> $scriptname.$i.err &";
	./wait-task-done.sh $scriptname.$i;
	$ssx "cat $scriptname.$i.done";
	if $ssx "cat $scriptname.$i.reboot 2> /dev/null"; then
		$ssx "shutdown -r now";
		./wait-reboot.sh
	fi
done

echo 'loop done'	

