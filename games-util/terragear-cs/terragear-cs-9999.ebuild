# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

DESCRIPTION="Terrain editing programs for FlightGear"
HOMEPAGE="http://terragear.sourceforge.net/"
EGIT_REPO_URI="git://gitorious.org/fg/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gdal"

DEPEND="dev-games/simgear
	dev-libs/boost
	dev-libs/newmat
	|| ( =x11-libs/agg-2.5 >x11-libs/agg-2.5[gpc] )
	gdal? ( sci-libs/gdal )
"

RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s|genpolyclip|agggpc|g" -i CMakeModules/FindGPC.cmake
}

src_configure() {
	mycmakeargs=(
	$(cmake-utils_use_enable gdal)
	)

	cmake-utils_src_configure
}
