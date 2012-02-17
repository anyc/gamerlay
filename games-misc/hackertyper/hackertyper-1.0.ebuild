# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: games-misc/hackertyper/hackertyper-1.0.ebuild,v 1.0 2012/02/17 19:13:54 frostwork Exp $

EAPI=3
inherit eutils prefix

DESCRIPTION="tool which makes you hack as fast as all those hackers in movies"
HOMEPAGE="http://frostworx.de/"
SRC_URI="http://www.frostworx.de/files/${P}.tar.bz2"


LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86 ppc"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"


src_install() {
	dobin ${PN} || die "dobin failed"
}
