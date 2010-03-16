# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit games

DESCRIPTION="catcodec decodes and encodes sample catalogues for OpenTTD."
HOMEPAGE="http://www.openttd.org/en/download-catcodec"
SRC_URI="http://binaries.openttd.org/extra/${PN}/${PV}/${PN}-${PV}-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_install() {
	dobin catcodec || die
	dodoc README || die
	doman catcodec.1 || die
}