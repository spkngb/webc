TARGETS = mountkernfs.sh hostname.sh udev keyboard-setup.sh mountdevsubfs.sh hwclock.sh mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh urandom checkroot.sh alsa-utils bootmisc.sh procps plymouth-log checkfs.sh checkroot-bootclean.sh x11-common kmod
INTERACTIVE = udev keyboard-setup.sh checkroot.sh checkfs.sh
udev: mountkernfs.sh
keyboard-setup.sh: mountkernfs.sh
mountdevsubfs.sh: mountkernfs.sh udev
hwclock.sh: mountdevsubfs.sh
mountall.sh: checkfs.sh checkroot-bootclean.sh
mountall-bootclean.sh: mountall.sh
mountnfs.sh: mountall.sh mountall-bootclean.sh
mountnfs-bootclean.sh: mountall.sh mountall-bootclean.sh mountnfs.sh
urandom: mountall.sh mountall-bootclean.sh hwclock.sh
checkroot.sh: hwclock.sh keyboard-setup.sh mountdevsubfs.sh hostname.sh
alsa-utils: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
bootmisc.sh: mountnfs-bootclean.sh mountall.sh mountall-bootclean.sh mountnfs.sh udev checkroot-bootclean.sh
procps: mountkernfs.sh mountall.sh mountall-bootclean.sh udev
plymouth-log: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
checkfs.sh: checkroot.sh
checkroot-bootclean.sh: checkroot.sh
x11-common: mountall.sh mountall-bootclean.sh mountnfs.sh mountnfs-bootclean.sh
kmod: checkroot.sh
