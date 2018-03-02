set -e
echo $$ > /tmp/spectreV2.4.pid

if ! kldstat -n cpuctl -q; then kldload cpuctl; fi
cpucontrol -e /dev/cpuctl10

mkdir output.2
sysctl vm.pmap > output.2/pmap.log
uname -a > output.2/uname.log
kenv | grep ^smbios. > output.2/kenv.log
dmesg > output.2/dmesg.log
x86info -a > output.2/x86info.log
objump -d $(sysctl kern.bootfile) | egrep 'call|jmp.*\*' > output.2/objdump.log

rm -rf /usr/src;
cp -r /usr/tmp.src/. /usr/src;

make -C /usr/src/tools/tools/syscall_timing
make install -C /usr/src/tools/tools/syscall_timing
/usr/obj/usr/src/amd64.amd64/tools/tools/syscall_timing/syscall_timing getppid > output.2/getppid.log

for i in $(jot 3); do
	rm -rf /usr/obj/*;
	/usr/bin/time -o output.2/buildtime.$i.log sh -c "make -C /usr/src -j$(sysctl -n hw.ncpu) buildworld > output.2/build.$i.log 2>&1";
done

tar -zcvf output.2.tar output.2

echo 'done' > spectreV2.4.done
