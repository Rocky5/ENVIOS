# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="gdb"
PKG_VERSION="11.1"
PKG_SHA256="cccfcc407b20d343fb320d4a9a2110776dd3165118ffd41f4b1b162340333f94"
PKG_LICENSE="GPL"
PKG_SITE="http://www.gnu.org/software/gdb/"
PKG_URL="http://ftpmirror.gnu.org/gdb/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib ncurses expat gmp"
PKG_LONGDESC="GNU Project debugger, allows you to see what is going on inside another program while it executes."
# gdb could fail on runtime if build with LTO support

PKG_CONFIGURE_OPTS_TARGET="bash_cv_have_mbstate_t=set \
                           --disable-shared \
                           --enable-static \
                           --with-auto-load-safe-path=/ \
			   --with-python=no \
			   --with-guile=no \
			   --with-mpfr=no \
			   --with-intel-pt=no \
			   --with-babeltrace=no \
			   --with-expat=yes \
			   --disable-source-highlight \
                           --disable-nls \
                           --disable-sim \
                           --without-x \
                           --disable-tui \
                           --disable-libada \
                           --without-lzma \
                           --disable-libquadmath \
                           --disable-libquadmath-support \
                           --enable-libada \
                           --enable-libssp \
                           --disable-werror"

pre_configure_target() {
  CC_FOR_BUILD="$HOST_CC"
  CFLAGS_FOR_BUILD="$HOST_CFLAGS"
}

makeinstall_target() {
  make DESTDIR=$INSTALL install
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/share/gdb/python
}
