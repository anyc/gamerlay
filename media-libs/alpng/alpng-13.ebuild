# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/alpng/alpng-13.ebuild ,v 1.0 2009/10/14 08:39:43 frostwork Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Library for loading PNG files for the Allegro library"
HOMEPAGE="http://alpng.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}${PV}.tar.gz"

LICENSE="AllegroPNG"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""

src_install() {
	dolib.so libalpng.a

	insinto /usr/include
	doins src/alpng.h
	dodoc doc.html
}
