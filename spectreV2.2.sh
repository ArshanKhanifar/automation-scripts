set -e
echo $$ > /tmp/spectreV2.2.pid

if ! kldstat -n cpuctl -q; then kldload cpuctl; fi
cpucontrol -e /dev/cpuctl0

mkdir output.1
sysctl vm.pmap > output.1/pmap.log
uname -a > output.1/uname.log
kenv | grep ^smbios. > output.1/kenv.log
dmesg > output.1/dmesg.log
x86info -a > output.1/x86info.log
objump -d $(sysctl kern.bootfile) | egrep 'call|jmp.*\*' > output.1/objdump.log

mount -t tmpfs tmpfs /usr/src
mount -t tmpfs tmpfs /usr/obj
cp -r /usr/tmp.src/. /usr/src

make -C /usr/src/tools/tools/syscall_timing
make install -C /usr/src/tools/tools/syscall_timing
/usr/obj/usr/src/amd64.amd64/tools/tools/syscall_timing/syscall_timing getppid > output.1/getppid.log

for i in $(jot 3); do 
	rm -rf /usr/obj/*; 
	/usr/bin/time -o output.1/buildtime.$i.log sh -c "make -C /usr/src -j$(sysctl -n hw.ncpu) buildworld > output.1/build.$i.log 2>&1";
done

tar -zcvf output.1.tar output.1

echo 'done' > spectreV2.2.done
