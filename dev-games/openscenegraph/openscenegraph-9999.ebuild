# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit cmake-utils subversion

DESCRIPTION="Open source high performance 3D graphics toolkit"
HOMEPAGE="http://www.openscenegraph.org/projects/osg/"
ESVN_REPO_URI="http://www.openscenegraph.org/svn/osg/OpenSceneGraph/trunk"

LICENSE="wxWinLL-3 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="curl gif jpeg jpeg2k osgapps pdf png svg tiff truetype video_cards_radeon xine xrandr"

RDEPEND="virtual/opengl
	virtual/glu
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	gif? ( media-libs/giflib )
	tiff? ( media-libs/tiff )
	truetype? ( media-libs/freetype:2 )
	x11-libs/libSM
	x11-libs/libXext
	xrandr? ( x11-libs/libXrandr )
	curl? ( net-misc/curl )
	svg? ( gnome-base/librsvg )
	jpeg2k? ( media-libs/jasper )
	xine? ( media-libs/xine-lib )
	pdf? ( >=app-text/poppler-0.12.3-r3[cairo] )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-arch/unzip"

DOCS="AUTHORS.txt ChangeLog NEWS.txt"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-magicoff.patch
	if use video_cards_radeon; then
	( epatch "${FILESDIR}"/${PN}-mipmapping.patch )
	fi
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build osgapps OSG_APPLICATIONS)
		-DENABLE_XUL=OFF
		$(cmake-utils_use_enable pdf PDF)
		$(cmake-utils_use_enable xine XINE)
		$(cmake-utils_use_enable jpeg2k JPEG2K)
		$(cmake-utils_use_enable svg SVG)
		$(cmake-utils_use_enable truetype FREETYPE)
		$(cmake-utils_use_enable curl CURL)
		$(cmake-utils_use_enable gif GIF)
		$(cmake-utils_use_enable png PNG)
		$(cmake-utils_use_enable jpeg JPEG)
		$(cmake-utils_use_enable tiff TIFF)
		$(cmake-utils_use_enable xrandr XRANDR)
	)
	cmake-utils_src_configure
}
