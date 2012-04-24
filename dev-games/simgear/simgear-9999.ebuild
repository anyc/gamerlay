# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_BRANCH="next"

inherit cmake-utils git-2

DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
EGIT_REPO_URI="git://mapserver.flightgear.org/simgear"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="subversion X"

RDEPEND="dev-libs/boost
	X? (	>=dev-games/openscenegraph-3.0[png]
		media-libs/freealut
		subversion? ( dev-vcs/subversion )
	)
"

DEPEND="${RDEPEND}"

DOCS=(NEWS AUTHORS)

src_configure() {
	mycmakeargs=(
	$(cmake-utils_use subversion ENABLE_LIBSVN)
	$(cmake-utils_use !X SIMGEAR_HEADLESS)
	)

	cmake-utils_src_configure
}
