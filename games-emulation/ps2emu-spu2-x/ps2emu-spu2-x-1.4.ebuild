# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WX_GTK_VER="2.8"
MY_PV=pcsx2-0.9.8-r4600-sources

inherit games cmake-utils wxwidgets

DESCRIPTION="SPU2-x plugin for pcsx2"
HOMEPAGE="http://www.pcsx2.net"
SRC_URI="http://forums.pcsx2.net/attachment.php?aid=28280 -> pcsx2-0.9.8.7z"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"
if use amd64; then
	ABI="x86"
fi
if use debug; then
	CMAKE_BUILD_TYPE="Debug"
else
	CMAKE_BUILD_TYPE="Release"
fi

DEPEND="dev-cpp/sparsehash
	x86? (
		app-arch/bzip2
		sys-libs/zlib
		media-libs/alsa-lib
		media-libs/glew
		media-libs/libsdl
		media-libs/portaudio
		media-libs/libsoundtouch
		media-gfx/nvidia-cg-toolkit
		virtual/jpeg
		virtual/opengl
		x11-libs/gtk+:2
		x11-libs/libICE
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/wxGTK[X]
	)
	amd64? ( media-gfx/nvidia-cg-toolkit[multilib]
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-gtklibs
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-wxGTK
	)"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s:add_subdirectory(3rdparty)::g" -i CMakeLists.txt
	sed -i -e "s:INSTALL(FILES:#INSTALL(FILES:g" -i CMakeLists.txt
	sed -i -e "s:add_subdirectory(locales)::g" -i CMakeLists.txt
	sed -i -e "s:add_subdirectory(tools)::g" -i CMakeLists.txt
	sed -i -e "s:pcsx2_core TRUE:pcsx2_core FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:CDVDiso TRUE:CDVDiso FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:CDVDlinuz TRUE:CDVDlinuz FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:CDVDnull TRUE:CDVDnull FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:dev9null TRUE:dev9null FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:FWnull TRUE:FWnull FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:GSdx TRUE:GSdx FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:zerogs TRUE:zerogs FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:zzogl TRUE:zzogl FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:PadNull TRUE:PadNull FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:onepad TRUE:onepad FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:zeropad TRUE:zeropad FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:GSnull TRUE:GSnull FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:SPU2null TRUE:SPU2null FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:zerospu2 TRUE:zerospu2 FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -i -e "s:USBnull TRUE:USBnull FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
}

S=${WORKDIR}/${MY_PV}

src_configure() {
	wxgtk_config=""
	cg_config=""
	if use amd64; then
		# tell cmake to use 32 bit library
		wxgtk_config="-DwxWidgets_CONFIG_EXECUTABLE=/usr/bin/wx-config-32"
		cg_config="-DCG_LIBRARY=/opt/nvidia-cg-toolkit/lib32/libCg.so
					-DCG_GL_LIBRARY=/opt/nvidia-cg-toolkit/lib32/libCgGL.so"
	fi

	mycmakeargs="
		-DPACKAGE_MODE=1
		-DPLUGIN_DIR=$(games_get_libdir)/pcsx2
		-DPLUGIN_DIR_COMPILATION=$(games_get_libdir)/pcsx2
		-DCMAKE_INSTALL_PREFIX=/usr
		-DFORCE_INTERNAL_SOUNDTOUCH=FALSE
		${wxgtk_config}
		${cg_config}
		"
	cmake-utils_src_configure
}

src_install() {
	insinto $(games_get_libdir)/pcsx2
	doins bin/plugins/libspu2x.so || die	
	prepgamesdirs
}
