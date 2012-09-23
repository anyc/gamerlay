# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games multilib unpacker-nixstaller

DESCRIPTION="An acrobatic janitor 2d platformer"
HOMEPAGE="http://dustforce.com"
SRC_URI="dustforce-linux-1347954459.sh"

RESTRICT="fetch"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/opengl
	app-arch/bzip2
	dev-libs/expat
	media-libs/fontconfig
	media-libs/freealut
	media-libs/freetype:2
	media-libs/libsdl
	media-libs/libogg
	media-libs/openal
	media-libs/libvorbis
	net-dns/libidn
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libxcb"

S="${WORKDIR}"
MY_PN=Dustforce

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_unpack() {
	nixstaller_unpack \
		instarchive_all \
		instarchive_linux_x86 \
		instarchive_linux_x86_64 \
		subarch \
		deps/cURL/cURL_files_linux_x86{,_64}	# We need this for broken dependency
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	insinto ${dir}
	doins -r content
	exeinto ${dir}

	local exe
	if use amd64 ; then
		exe=${MY_PN}.bin.x86_64
	fi
	if use x86 ; then
		exe=${MY_PN}.bin.x86
	fi
	doexe ${exe}

	# Broken dep
	exeinto ${dir}/$(get_libdir)
	doexe $(get_libdir)/libcurl.so.3
	doicon ${MY_PN}.png
	make_desktop_entry ${PN} ${MY_PN} ${MY_PN}
	games_make_wrapper ${PN} ./${exe} ${dir} ${dir}

	dodoc README.linux
}
