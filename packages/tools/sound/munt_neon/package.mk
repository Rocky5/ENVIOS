# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present asakous (https://github.com/asakous)

PKG_NAME="munt_neon"
PKG_VERSION="5785a6c9321179cf0544128ea4f740bb59f1928b"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/asakous/munt"
PKG_URL="https://github.com/asakous/munt.git"
PKG_DEPENDS_TARGET="toolchain math_neon"
PKG_LONGDESC="A software synthesiser emulating pre-GM MIDI devices such as the Roland MT-32."
GET_HANDLER_SUPPORT="git"
PKG_CMAKE_OPTS_TARGET="-Dmunt_WITH_MT32EMU_QT=0 \
                       -Dmunt_WITH_MT32EMU_SMF2WAV=0 \
                       -Dlibmt32emu_SHARED=1"


pre_configure_target() {
sed -i -e "s/cortex-a7/cortex-a53/" $PKG_BUILD/mt32emu_alsadrv/Makefile
sed -i -e "s|../libmathneon.a|$(get_build_dir math_neon)/libmathneon.a|" $PKG_BUILD/mt32emu_alsadrv/Makefile
sed -i -e "s|/usr/share/mt32-rom-data/|/storage/mt32-rom-data/|" $PKG_BUILD/mt32emu_alsadrv/src/alsadrv.cpp
sed -i -e "s|../build/mt32emu/libmt32emu.a|${PKG_BUILD}/.${TARGET_NAME}/mt32emu/libmt32emu.so|" $PKG_BUILD/mt32emu_alsadrv/Makefile
}

post_configure_target() { 
cp -rf ${PKG_BUILD}/.${TARGET_NAME}/mt32emu/include/* $SYSROOT_PREFIX/usr/include
}

pre_makeinstall_target() { 
PKG_LIBNAME="libmt32emu.so.2"
PKG_LIBPATH="$PKG_BUILD/.${TARGET_NAME}/mt32emu/libmt32emu.so*"

cp $PKG_LIBPATH $SYSROOT_PREFIX/usr/lib
cd $PKG_BUILD/mt32emu_alsadrv/
make mt32d
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp mt32d $INSTALL/usr/bin/mt32d
 
  #build systems will not copy .la files so this is pointless 
  mkdir -p $INSTALL/usr/lib
  cp $PKG_LIBPATH $INSTALL/usr/lib
}
