# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_BRANCH="next"

inherit cmake-utils git

DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
EGIT_REPO_URI="git://gitorious.org/fg/simgear.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="video_cards_radeon"

RDEPEND=">=dev-games/openscenegraph-2.9[png]
	dev-libs/boost
	media-libs/openal
	media-libs/freealut"

DEPEND="${RDEPEND}"

DOCS=(NEWS AUTHORS)

src_prepare() {
	if use video_cards_radeon; then
	epatch "${FILESDIR}/simgear-radeon-fix-runway-lights.patch"
	fi
}
