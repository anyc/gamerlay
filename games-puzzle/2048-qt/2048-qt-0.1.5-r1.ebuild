# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games qmake-utils

DESCRIPTION="A Qt-based version of the game 2048"
HOMEPAGE="https://github.com/xiaoyong/2048-Qt"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz"

LICENSE="LGPL-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtquickcontrols[widgets]
	x11-themes/hicolor-icon-theme"
RDEPEND="${DEPEND}"

S="${WORKDIR}/2048-Qt-${PV}"

src_configure(){
	local myeqmakeargs=(
		${PN}.pro
		PREFIX="${EPREFIX}/usr"
		DESKTOPDIR="${EPREFIX}/usr/share/applications"
		ICONDIR="${EPREFIX}/usr/share/pixmaps"
	)
	eqmake5 ${myeqmakeargs[@]}
}

src_install(){
	dogamesbin ${PN}
	insinto /usr/share/icons/hicolor
	doins -r icons/*
	insinto /usr/share/applications
	doins ${PN}.desktop
	doman man/${PN}.6
}

pkg_postinst(){
	elog "IMPORTANT: Add your user to the games group, and restart your current session."
	elog "After that, you can play. Enjoy!"
}
