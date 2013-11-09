# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WX_GTK_VER="2.8"

inherit games cmake-utils subversion wxwidgets

DESCRIPTION="zzogl plugin for pcsx2"
HOMEPAGE="http://www.pcsx2.net"
ESVN_REPO_URI="http://pcsx2.googlecode.com/svn/trunk"
ESVN_PROJECT="pcsx2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug cg"
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
		cg? ( media-gfx/nvidia-cg-toolkit )
		virtual/jpeg
		virtual/opengl
		x11-libs/gtk+:2
		x11-libs/libICE
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/wxGTK[X]
	)
	amd64? ( cg? ( media-gfx/nvidia-cg-toolkit[multilib] )
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
	sed -e "s:add_subdirectory(3rdparty)::g" -i CMakeLists.txt
	sed -e "s:INSTALL(FILES:#INSTALL(FILES:g" -i CMakeLists.txt
	sed -e "s:add_subdirectory(locales)::g" -i CMakeLists.txt
	sed -e "s:add_subdirectory(tools)::g" -i CMakeLists.txt
#	sed -e "s:add_subdirectory(common/src/Utilities)::g" -i CMakeLists.txt
 	sed -e "s:add_subdirectory(common/src/x86emitter)::g" -i CMakeLists.txt
	sed -e "s:pcsx2_core TRUE:pcsx2_core FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:CDVDiso TRUE:CDVDiso FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:CDVDlinuz TRUE:CDVDlinuz FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:CDVDnull TRUE:CDVDnull FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:dev9null TRUE:dev9null FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:FWnull TRUE:FWnull FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:GSdx TRUE:GSdx FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:zerogs TRUE:zerogs FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:GSnull TRUE:GSnull FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:PadNull TRUE:PadNull FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:onepad TRUE:onepad FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:zeropad TRUE:zeropad FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:SPU2null TRUE:SPU2null FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:spu2-x TRUE:spu2-x FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:zerospu2 TRUE:zerospu2 FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
	sed -e "s:USBnull TRUE:USBnull FALSE:g" -i cmake/SelectPcsx2Plugins.cmake
}

src_configure() {
	wxgtk_config=""
	cg_config=""
	if use amd64; then
		# tell cmake to use 32 bit library
		wxgtk_config="-DwxWidgets_CONFIG_EXECUTABLE=/usr/bin/wx-config-2.8-32"
		cg_config="-DCG_LIBRARY=/opt/nvidia-cg-toolkit/lib32/libCg.so
					-DCG_GL_LIBRARY=/opt/nvidia-cg-toolkit/lib32/libCgGL.so"
	fi

	mycmakeargs="
		-DPACKAGE_MODE=1
		-DPLUGIN_DIR=$(games_get_libdir)/pcsx2
		-DPLUGIN_DIR_COMPILATION=$(games_get_libdir)/pcsx2
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_LIBRARY_PATH=$(games_get_libdir)/pcsx2
		$(cmake-utils_use !cg GLSL_API)
		${wxgtk_config}
		${cg_config}
		"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install DESTDIR=${D}
	prepgamesdirs
}
