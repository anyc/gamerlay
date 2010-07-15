# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools git

DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
EGIT_REPO_URI="git://mapserver.flightgear.org/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-games/openscenegraph
	>=media-libs/plib-1.8.5"

DEPEND="${RDEPEND}"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
	--prefix=/usr/simgear \
	--libdir=/usr/simgear/lib \
	--enable-headless || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc NEWS AUTHORS
}
