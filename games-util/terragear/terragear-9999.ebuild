# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="Terrain editing programs for FlightGear"
HOMEPAGE="http://terragear.sourceforge.net/"
EGIT_REPO_URI="git://gitorious.org/fg/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-games/simgear-2.9
	dev-libs/boost
	dev-libs/poco
	sci-libs/gdal
	>=sci-mathematics/cgal-4.0
"

RDEPEND="${DEPEND}
	app-arch/unzip
"

src_configure() {
	mycmakeargs=(
	-DSIMGEAR_SHARED=ON
	)

	cmake-utils_src_configure
}
