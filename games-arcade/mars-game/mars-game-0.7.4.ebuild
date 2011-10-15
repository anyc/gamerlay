# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/mars-game/mars-game-0.7.4.ebuild,v 1.2 2011/10/15 09:13:36 frostwork Exp $

EAPI=4

inherit cmake-utils eutils

MY_PN="mars"
DESCRIPTION="a ridiculous shooter"
HOMEPAGE="http://${PN}.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}_source_${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND=">=media-libs/libsfml-2.0
		virtual/opengl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare(){
	sed -i -e "s:{CMAKE_INSTALL_PREFIX}/games:{CMAKE_INSTALL_PREFIX}/games/bin:g" -i src/CMakeLists.txt
}

