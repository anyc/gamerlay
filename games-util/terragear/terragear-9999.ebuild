# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools git

DESCRIPTION="terrain editing programs for FlightGear"
HOMEPAGE="http://terragear.sourceforge.net/"
EGIT_REPO_URI="git://mapserver.flightgear.org/terragear-cs"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-games/simgear-cs
	dev-libs/newmat
	media-libs/plib
	sci-libs/gdal
	x11-libs/agg[gpc]
"

RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	epatch ${FILESDIR}/"${PN}"-setrlimit.patch
	epatch ${FILESDIR}/"${PN}"-use-agg.patch
	eautoreconf
}

src_configure() {
	econf --with-simgear=/usr/simgear || die
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
