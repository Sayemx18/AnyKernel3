# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=alioth
device.name2=aliothin
device.name3=
device.name4=
device.name5=
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 750 750 $ramdisk/*;

# kernel naming scene
ui_print " ";

case "$ZIPFILE" in

  *miui5k*|*MIUI5K*)
    ui_print "MIUI 5kmah detected"
    ui_print "Using MIUI 5kmah DTBO..."
    mv miui-5k-dtbo.img $home/dtbo.img
    rm -f miui-dtbo.img stock-dtbo.img 5k-dtbo.img
  ;;

  *miui*|*MIUI*)
    ui_print "MIUI  detected"
    ui_print "Using MIUI Stock DTBO..."
    mv miui-dtbo.img $home/dtbo.img
    rm -f miui-5k-dtbo.img stock-dtbo.img 5k-dtbo.img
  ;;

  *5k*|*5K*)
    ui_print "AOSP 5kmah detected"
    ui_print "Using AOSP 5kmah DTBO..."
    mv 5k-dtbo.img $home/dtbo.img
    rm -f stock-dtbo.img miui*.img
  ;;

  *)
    ui_print "AOSP stock  detected"
    ui_print "Using AOSP Stock DTBO..."
    mv stock-dtbo.img $home/dtbo.img
    rm -f 5k-dtbo.img miui*.img
  ;;

esac
ui_print " ";

## AnyKernel install
dump_boot;

# Begin Ramdisk Changes

# migrate from /overlay to /overlay.d to enable SAR Magisk
if [ -d $ramdisk/overlay ]; then
  rm -rf $ramdisk/overlay;
fi;

write_boot;
## end install

## vendor_boot shell variables
block=/dev/block/bootdevice/by-name/vendor_boot;
is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# reset for vendor_boot patching
reset_ak;

# vendor_boot install
dump_boot;

write_boot;
## end vendor_boot install
