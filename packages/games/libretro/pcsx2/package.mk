# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present Fewtarius

PKG_NAME="pcsx2"
PKG_VERSION="ad7650949e6c8c87cd2c5e278af88e3722a321bc"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_DEPENDS_TARGET="toolchain alsa-lib freetype zlib libpng libaio libsamplerate libfmt libpcap soundtouch yamlcpp wxwidgets"
PKG_SITE="https://github.com/libretro/pcsx2"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="libretro"
PKG_SHORTDESC="PCSX2 core for RetroArch."

if [ ! "${OPENGL}" = "no" ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGL} glu libglvnd"
fi

if [ "${OPENGLES_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGLES}"
fi

if [ "${VULKAN_SUPPORT}" = "yes" ]
then
  PKG_DEPENDS_TARGET+=" vulkan-loader vulkan-headers"
fi

if [ "${DISPLAYSERVER}" = "wl" ]; then
  PKG_DEPENDS_TARGET+=" wayland ${WINDOWMANAGER}"
fi

PKG_CMAKE_OPTS_TARGET=" \
                        -DSDL2_API=TRUE \
                        -DDISABLE_PCSX2_WRAPPER=1 \
                        -DPACKAGE_MODE=FALSE \
                        -DPCSX2_TARGET_ARCHITECTURES=x86_64 \
                        -DENABLE_TESTS=OFF \
                        -DEXTRA_PLUGINS=OFF \
                        -DQT_BUILD=FALSE \
                        -DBUILD_SHARED_LIBS=OFF \
                        -DUSE_SYSTEM_LIBS=OFF \
                        -DDISABLE_ADVANCE_SIMD=ON \
                        -DUSE_VTUNE=OFF \
                        -DUSE_VULKAN=ON \
			-DGTK3_API=FALSE \
                        -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=FALSE \
                        -DCMAKE_BUILD_TYPE=Release"

pre_configure_target() {
  export LDFLAGS="${LDFLAGS} -laio"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_BUILD}/.${TARGET_NAME}/pcsx2/pcsx2_libretro.so ${INSTALL}/usr/lib/libretro/
}
