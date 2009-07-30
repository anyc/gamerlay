# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games qt4


DESCRIPTION="KBang is an open source implementation of the popular card game Bang!"
HOMEPAGE="http://code.google.com/p/kbang/"
SRC_URI="http://${PN}.googlecode.com/files/${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="server"

DEPEND=">x11-libs/qt-gui-4.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-src"
src_compile() {
	eqmake4

	emake || die "emake failed"
}

src_install() {
	exeinto "${ROOT}usr/share/${PN}"

	doexe "${PN}-client" || die "doexe failed"
	dosym "${ROOT}usr/share/${PN}/${PN}-client" "${ROOT}usr/bin/${PN}"

	if use server; then
		doexe "${PN}-server" || die "doexe failed"
		dosym "${ROOT}usr/share/${PN}/${PN}-server" "${ROOT}usr/bin/${PN}-server"
	fi

	insinto "${ROOT}usr/share/${PN}"
	doins -r gfx || die "doins failed"
}
