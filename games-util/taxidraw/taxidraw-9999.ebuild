# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools git eutils wxwidgets games

DESCRIPTION="a taxiway editor for FlightGear and X-Plane"
HOMEPAGE="http://taxidraw.sourceforge.net/"
EGIT_REPO_URI="git://mapserver.flightgear.org/taxidraw"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="=x11-libs/wxGTK-2.8*
	net-misc/curl"

RDEPEND="${DEPEND}"

pkg_setup() {
	games_pkg_setup
	WX_GTK_VER=2.8 need-wxwidgets gtk2
}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	eautoreconf
}

src_configure() {
	egamesconf --with-wx-config=${WX_CONFIG} || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	prepgamesdirs
}
