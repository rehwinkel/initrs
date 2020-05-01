all: build test

build: initramfs.img

test: initramfs.img
	qemu-system-x86_64 -kernel ../vmlinuz -initrd initramfs.img -enable-kvm -hda ../drive.img
	# -nographic -append "console=ttyS0"

initramfs.img: init
	cp init initramfs/
	cd initramfs; find . -print0 | cpio -ov0 --format=newc | gzip --best > ../initramfs.img

init: src/*
	cargo build --release --target i586-unknown-linux-musl -q
	cp target/i586-unknown-linux-musl/release/initrs ./init
	strip init