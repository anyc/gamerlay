# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: app-emulation/e-uae/fs-uae-1.2.0.ebuild,v 1.0 2012/05/05 9:03:09 frostwork Exp $

EAPI="2"

inherit eutils games

DESCRIPTION="a multi-platform Amiga emulator"
HOMEPAGE="http://fengestad.no/"${PN}""
SRC_URI="http://fengestad.no/"${PN}"/stable/"${PV}"/"${P}".tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="launcher"

RDEPEND="virtual/opengl
		media-libs/openal
		media-libs/libpng
		media-libs/libsdl
		sys-libs/zlib[minizip]"

DEPEND="$RDEPEND"

src_prepare() {
	sed -i '1i#define OF(x) x' src/archivers/zip/*.h
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "Before you launch fs-uae for the first time you need to create and configure"
	ewarn "~/.config/fs-uae/fs-uae.conf"
	ewarn "for an example see ${GAMES_DATADIR}/${PN}/example.conf"
}
