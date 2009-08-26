# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="A Library of Bullet Markup Language for D-Lang"
HOMEPAGE="http://shinh.skr.jp/bulletss/"
SRC_URI="http://my.vector.co.jp/servlet/System.FileDownload/download/http/0/301119/pack/win95/game/tool/${PN}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/dmd-bin
	media-libs/libsdl
	media-libs/mesa"

DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}"/bulletss

src_prepare(){
	cd "${WORKDIR}"/bulletss/
	epatch "${FILESDIR}"/fix.diff
}

src_compile() {
	emake -C bulletml || die "emake failed"
}

src_install() {
	dodoc README* || die "dodoc failed"

	cd "${S}"/bulletml
	dolib.a libbulletml_d.a || die "dolib.a failed"

	insinto /usr/include/bulletml-d
	doins *.h || die "doins headers file failed"

	dodir /usr/lib/dmd/phobos || die "dodir failed"
	insinto /usr/lib/dmd/phobos
	doins bulletml.d || die "doins bulletml.d failed"
	dosed "s:\(alias bit bool\)://\1:" /usr/lib/dmd/phobos/bulletml.d || die "dosed failed"
}
