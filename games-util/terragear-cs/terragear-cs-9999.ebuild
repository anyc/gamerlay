# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools git

DESCRIPTION="Terrain editing programs for FlightGear"
HOMEPAGE="http://terragear.sourceforge.net/"
EGIT_REPO_URI="git://mapserver.flightgear.org/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-games/simgear-cs
	dev-libs/newmat
	media-libs/plib
	sci-libs/gdal
	|| ( =x11-libs/agg-2.5 >x11-libs/agg-2.5[gpc] )
"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch ${FILESDIR}/"${PN}"-setrlimit.patch
	epatch ${FILESDIR}/"${PN}"-use-agg.patch
	eautoreconf
}

src_configure() {
	econf --with-simgear=/usr/simgear
}

src_compile() {
	emake -j1
}
