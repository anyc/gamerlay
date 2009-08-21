# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit autotools

DESCRIPTION="relatively thin, simple and robust network communication layer on top of UDP"
HOMEPAGE="http://enet.bespin.org/"
SRC_URI="http://dev.gentooexperimental.org/~scarabeus/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog *.txt README
}
