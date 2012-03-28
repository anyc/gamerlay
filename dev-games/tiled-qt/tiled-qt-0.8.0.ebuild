# Copyright 1999-2012 Gentoo Foundation
# Distributd under the terms of the GNU General Public License v3
# $Header: dev-games/tiled-qt-0.8.0.ebuild,v 1.1 2012/03/28 17:48:23 by harleaquin Exp $

EAPI="3"

inherit qt4-r2

DESCRIPTION="Tiled is a general purpose tile map editor for games"
HOMEPAGE="http://www.mapeditor.org/"
SRC_URI="mirror://sourceforge/tiled/${P}.tar.gz"

IUSE="examples"
LICENSE="GPL-2 LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=x11-libs/qt-gui-4.6
	>=x11-libs/qt-core-4.6
	>=x11-libs/qt-opengl-4.6
"

RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s:/local::g" -i tiled.pri
}

src_install() {
	qt4-r2_src_install
	dodoc AUTHORS COPYING NEWS LICENSE.BSD LICENSE.GPL LICENSE.LGPL README.md
	use examples && docinto examples && dodoc examples/*.* 
	use examples && docinto examples/sewer_automap/ && dodoc examples/sewer_automap/*.*
}


