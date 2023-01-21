# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2022-present Fewtarius

PKG_NAME="powerstate"
PKG_VERSION=""
PKG_SHA256=""
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_DEPENDS_TARGET="systemd"
PKG_SITE=""
PKG_URL=""
PKG_LONGDESC="Adjusts settings for better battery life"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
	mkdir -p ${INSTALL}/usr/bin
	cp powerstate.sh ${INSTALL}/usr/bin/powerstate
	chmod +x ${INSTALL}/usr/bin/powerstate
}

post_install() {
  enable_service powerstate.service
}
