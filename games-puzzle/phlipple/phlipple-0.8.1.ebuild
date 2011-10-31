# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-puzzle/phlipple/phlipple-0.8.1.ebuild frostwork Exp $

EAPI="3"

inherit eutils games flag-o-matic

DESCRIPTION="a unique puzzle game with the goal to reduce a 3D shape to a single square"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	virtual/opengl
	virtual/glu"
