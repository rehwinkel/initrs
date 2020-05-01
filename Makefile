all: build drive test 

drive: extra/vmlinuz
	if [ ! -f extra/drive.img ]; then qemu-img create -f qcow2 extra/drive.img 64M; fi

build: initramfs.img

test: initramfs.img
	qemu-system-x86_64 -kernel extra/vmlinuz -initrd initramfs.img -enable-kvm -hda extra/drive.img
	# -nographic -append "console=ttyS0"

initramfs.img: init
	if [ ! -d "initramfs/" ]; then mkdir initramfs; fi
	cp init initramfs/
	cd initramfs; find . -print0 | cpio -ov0 --format=newc | gzip --best > ../initramfs.img

init: src/*
	cargo build --release --target i586-unknown-linux-musl -q
	cp target/i586-unknown-linux-musl/release/initrs ./init
	strip init