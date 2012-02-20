# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-util/whdrunner-0.5.ebuild,v 1.0 2012/02/16 16:41:26 by frostwork Exp $

EAPI="3"

CMAKE_MIN_VERSION=2.8

inherit cmake-utils eutils

DESCRIPTION="an easy to use amiga whdload launcher"
HOMEPAGE="http://www.frostworx.de/?p=432"
SRC_URI="http://www.frostworx.de/files/${PN}/${P/_/-}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

S="${WORKDIR}/${P/_/-}"

RDEPEND="app-arch/unzip
app-emulation/fs-uae
dev-libs/tinyxml"

DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use debug DEBUG)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "fs-uae needs to be configured properly before whdrunner can work!"
	ewarn "you have to install the whdrunner_dh0 datapackage (see $HOMEPAGE) manually (see README)"
}
