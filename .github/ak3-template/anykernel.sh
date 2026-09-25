### AnyKernel3 Ramdisk Mod Script
## ReBocchi (ReSukiSU-susfs) by RanggaWbp — Xiaomi SDM845

### AnyKernel setup
# global properties
properties() { '
kernel.string=__AK3_KERNEL_STRING__
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=__AK3_DEVICE1__
device.name2=__AK3_DEVICE2__
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables — LawRun reference: explicit boot partition, non-slot
BLOCK=/dev/block/bootdevice/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# boot install
dump_boot;

# cpio -o fallback (no mkbootfs in zip) drops device nodes; without /dev/console
# init exits 1 -> "Attempted to kill init!" bootloop.
if [ ! -e $RAMDISK/dev/console ]; then
  mkdir -p $RAMDISK/dev;
  mknod -m 600 $RAMDISK/dev/console c 5 1;
  mknod -m 666 $RAMDISK/dev/null c 1 3;
  mknod -m 666 $RAMDISK/dev/ptmx c 5 2;
  mknod -m 660 $RAMDISK/dev/tty c 5 0;
fi;

write_boot;
## end boot install
