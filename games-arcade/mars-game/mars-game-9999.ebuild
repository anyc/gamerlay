# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/mars-game/mars-game-9999.ebuild,v 1.2 2011/09/09 07:52:53 frostwork Exp $

EAPI=4

inherit cmake-utils eutils subversion

DESCRIPTION="a ridiculous shooter"
HOMEPAGE="http://${PN}.sourceforge.net"
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}"


LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=media-libs/libsfml-2.0
		virtual/opengl"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -i -e "s:{CMAKE_INSTALL_PREFIX}/games:{CMAKE_INSTALL_PREFIX}/games/bin:g" -i src/CMakeLists.txt
}

