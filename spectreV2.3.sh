set -e
echo $$ > /tmp/spectreV2.3.pid

rm -rf /usr/src; cp -r /usr/tmp.src/. /usr/src
cd /usr/src; curl -k https://reviews.freebsd.org/file/data/5s4bhiczo3vjr3kubuxe/PHID-FILE-3d7ss2e4ednexzio6mtq/D14242.diff | git apply -p0; cd /root
echo 'WITH_KERNEL_RETPOLINE=yes' > /usr/src/etc/src.conf
rm -rf update-logs.2; mkdir update-logs.2
make -C /usr/src KERNCONF=GENERIC-NODEBUG  -j$(sysctl -n hw.ncpu) buildkernel buildworld > update-logs.2/update-build.log 2>&1
make -C /usr/src KERNCONF=GENERIC-NODEBUG installkernel installworld > update-logs.2/update-install.log 2>&1

echo 'done' > spectreV2.3.done
echo 'reboot' > spectreV2.3.reboot

