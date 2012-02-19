# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: app-emulation/e-uae/fs-uae-0.9.7.ebuild,v 1.0 2012/02/15 16:30:51 frostwork Exp $

EAPI="2"

inherit eutils games

DESCRIPTION="a multi-platform Amiga emulator"
HOMEPAGE="http://fengestad.no/"${PN}""
SRC_URI="http://fengestad.no/"${PN}"/files/"${P}".tar.gz"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/opengl
		media-libs/openal
		media-libs/libpng
		media-libs/libsdl
		sys-libs/zlib[minizip]"

DEPEND="$RDEPEND"

src_prepare() {
	rm -rf libuae/archivers/zip
	epatch "${FILESDIR}"/${P}-minizip.patch
}


pkg_postinst() {
	games_pkg_postinst
	ewarn "Before you launch fs-uae for the first time you need to create and configure"
	ewarn "~/.config/fs-uae/fs-uae.conf"
	ewarn "for an example see ${GAMES_DATADIR}/${PN}/example.conf"
}
