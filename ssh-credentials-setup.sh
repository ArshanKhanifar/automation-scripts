eval "$(ssh-agent -s)"
ssh -q root@$(cat /tmp/ip) exit
echo 'STATUS:'$?

