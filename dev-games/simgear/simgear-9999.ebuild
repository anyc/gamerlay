# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

EGIT_BRANCH="next"

inherit cmake-utils git

DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
EGIT_REPO_URI="git://gitorious.org/fg/simgear.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-games/openscenegraph
	dev-libs/boost
	media-libs/openal
	media-libs/freealut"

DEPEND="${RDEPEND}"

DOCS=(NEWS AUTHORS)
