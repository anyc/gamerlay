# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

IUSE=""

DESCRIPTION="A Library of Bullet Markup Language for D-Lang"
SRC_URI="http://my.vector.co.jp/servlet/System.FileDownload/download/http/0/301119/pack/win95/game/tool/bulletss.zip"
HOMEPAGE="http://shinh.skr.jp/bulletss/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="ppc x86 ~alpha"
IUSE=""

DEPEND="<=sys-devel/gcc-4.1.2[d]
	dev-lang/perl
	sys-devel/bison
	app-arch/unzip"

RDEPEND=""

S="${WORKDIR}"/bulletss

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"/bulletss/

	epatch "${FILESDIR}"/fix.diff
}

src_compile() {
	emake -C bulletml || die
}

src_install() {
	dodoc README*

	cd "${S}"/bulletml
	dolib.a libbulletml_d.a

	insinto /usr/include/bulletml-d
	doins *.h

	dodir /usr/lib/dmd/phobos
	insinto /usr/lib/dmd/phobos
	doins bulletml.d
	dosed "s:\(alias bit bool\)://\1:" /usr/lib/dmd/phobos/bulletml.d
}
