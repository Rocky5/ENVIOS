# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXext"
PKG_VERSION="c6eded76e212419518bd955cad58c96b8653840e"
PKG_LICENSE="OSS"
PKG_SITE="https://gitlab.freedesktop.org/xorg/lib/libxext"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain util-macros libX11"
PKG_LONGDESC="LibXext provides an X Window System client interface to several extensions to the X protocol."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull --without-xmlto"

post_configure_target() {
  libtool_remove_rpath libtool
}
