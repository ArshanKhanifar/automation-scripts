set -e
echo $$ > /tmp/spectreV2.1.pid
# getting source tree
rm -rf /usr/tmp.src; git clone https://github.com/freebsd/freebsd.git /usr/tmp.src
rm -rf /usr/src; cp -r /usr/tmp.src/. /usr/src
cd /usr/src; curl -k https://reviews.freebsd.org/file/data/5s4bhiczo3vjr3kubuxe/PHID-FILE-3d7ss2e4ednexzio6mtq/D14242.diff | git apply -p0; cd /root 

rm -rf update-logs.1; mkdir update-logs.1
make -C /usr/src KERNCONF=GENERIC-NODEBUG  -j$(sysctl -n hw.ncpu) buildkernel buildworld > update-logs.1/update-build.log 2>&1
make -C /usr/src KERNCONF=GENERIC-NODEBUG installkernel installworld > update-logs.1/update-install.log 2>&1

echo 'done' > spectreV2.1.done
echo 'reboot' > spectreV2.1.reboot

