# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="readline"
PKG_VERSION="8.1.2"
PKG_SHA256="7589a2381a8419e68654a47623ce7dfcb756815c8fee726b98f90bf668af7bc6"
PKG_LICENSE="MIT"
PKG_SITE="http://www.gnu.org/software/readline/"
PKG_URL="http://ftpmirror.gnu.org/readline/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_LONGDESC="The GNU Readline library provides a set of functions for use by applications that allow users to edit command lines as they are typed in."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="bash_cv_wcwidth_broken=no \
                           --enable-shared \
                           --disable-static \
                           --with-curses"

pre_configure_target() {
  export LDFLAGS="${LDFLAGS} -lncursesw -ltinfow"
  export CFLAGS="${CFLAGS} -fcommon"
}

post_makeinstall_target() {
  sed -i 's/-lreadline/-lreadline -lncursesw/' ${SYSROOT_PREFIX}/usr/lib/pkgconfig/readline.pc
  rm -rf ${INSTALL}/usr/share/readline
}
