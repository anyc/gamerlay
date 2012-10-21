# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit games

DESCRIPTION="a physics-based action game where diff characters allow diff solutions to challenges"
HOMEPAGE="http://trine-thegame.com/"
SRC_URI="trine2_linux_installer.run"
RESTRICT="fetch strip"
LICENSE="frozenbyte-eula"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="x86? (
		app-arch/bzip2
		dev-libs/atk
		dev-libs/expat
		dev-libs/glib
		dev-libs/libffi
		media-gfx/nvidia-cg-toolkit
		media-libs/fontconfig
		media-libs/freetype:2
		media-libs/libpng
		sys-apps/util-linux
		sys-libs/zlib
		virtual/opengl
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/gtk+
		x11-libs/libdrm
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXcomposite
		x11-libs/libXcursor
		x11-libs/libXdamage
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXxf86vm
		x11-libs/pango
		x11-libs/pixman
	)
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-gtklibs
	)"

S="${WORKDIR}"

QA_PREBUILT="opt/trine2/bin/trine2_linux_32bit"

pkg_nofetch() {
	ewarn
	ewarn "Put ${A} (downloaded from Humble Store) to ${DISTDIR}, please"
	ewarn
}

src_unpack() {
        local src="${DISTDIR}/${A}"
        dd ibs=51200 skip=1 if="${src}" | tar --no-same-owner -xzf -
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	insinto "${dir}"
	doins -r data data1.fbq datalinux1.fbq

	exeinto "${dir}/bin"
	doexe bin/*

	# PhysX
	insinto "${dir}/lib"
	doins lib/lib32/libPhysX*
	# LibSDL 1.3
	doins lib/lib32/libSDL-1.3.so.0
	# 32 bit nvidia-cg-toolkit, only for AMD64
	use amd64 && doins lib/lib32/libCg{,GL}.so

	doicon "${PN}.png"
	make_desktop_entry "${PN}" "${PN}" "${PN}"
	games_make_wrapper "${PN}" "bin/${PN}" "${dir}" "${dir}/lib"

	dodoc README
	prepgamesdirs
}
