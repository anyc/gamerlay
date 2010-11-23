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
IUSE="curl debug doc examples ffmpeg fltk fox gdal gif glut gtk jpeg jpeg2k
openexr openinventor osgapps pdf png qt4 sdl static-libs svg tiff truetype vnc
wxwidgets xine xrandr zlib"

# NOTE: OpenAL (support missing)
# TODO: COLLADA, FBX, OpenVRML, Performer, ITK, DCMTK
# 	xulrunner? ( only 1.8 supported for now, ignore it
#		net-libs/xulrunner:1.8
#		x11-libs/gtk+:2
#	)
RDEPEND="
	x11-libs/libSM
	x11-libs/libXext
	virtual/glu
	virtual/opengl
	curl? ( net-misc/curl )
	examples? (
		fltk? ( x11-libs/fltk:1.1[opengl] )
		fox? ( x11-libs/fox:1.6[opengl] )
		glut? ( media-libs/freeglut )
		gtk? ( x11-libs/gtkglext )
		qt4? (
			x11-libs/qt-core:4
			x11-libs/qt-gui:4
			x11-libs/qt-opengl:4
		)
		sdl? ( media-libs/libsdl )
		wxwidgets? ( x11-libs/wxGTK[opengl,X] )
	)
	ffmpeg? ( media-video/ffmpeg )
	gdal? ( sci-libs/gdal )
	gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg )
	jpeg2k? ( media-libs/jasper )
	openexr? (
		media-libs/ilmbase
		media-libs/openexr
	)
	openinventor? (
		|| (
			media-libs/coin
			media-libs/openinventor
		)
	)
	pdf? ( app-text/poppler[cairo] )
	png? ( media-libs/libpng:0 )
	svg? (
		gnome-base/librsvg
		x11-libs/cairo
	)
	tiff? ( media-libs/tiff:0 )
	truetype? ( media-libs/freetype:2 )
	vnc? ( net-libs/libvncserver )
	xine? ( media-libs/xine-lib )
	xrandr? ( x11-libs/libXrandr )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/pkgconfig
	x11-proto/xextproto
	doc? ( app-doc/doxygen )
	xrandr? ( x11-proto/randrproto )
"

DOCS=(AUTHORS.txt ChangeLog NEWS.txt)

src_prepare() {
	epatch "${FILESDIR}"/${PN}-cmake2.patch
}

src_configure() {
	# Needed by FFmpeg
	append-cppflags -D__STDC_CONSTANT_MACROS

	mycmakeargs=(
		-DWITH_OpenAL=OFF # Commented out in buildsystem
		-DWITH_XUL=OFF # Supports only xulrunner 1.8
		-DGENTOO_DOCDIR="/usr/share/doc/${PF}"
		$(cmake-utils_use_with curl)
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use_build osgapps OSG_APPLICATIONS)
		$(cmake-utils_use_build examples OSG_EXAMPLES)
		$(cmake-utils_use_with ffmpeg FFmpeg)
		$(cmake-utils_use_with fltk)
		$(cmake-utils_use_with fox)
		$(cmake-utils_use_with gdal)
		$(cmake-utils_use_with gif GIFLIB)
		$(cmake-utils_use_with glut)
		$(cmake-utils_use_with gtk GtkGl)
		$(cmake-utils_use_with jpeg)
		$(cmake-utils_use_with jpeg2k Jasper)
		$(cmake-utils_use_with openexr OpenEXR)
		$(cmake-utils_use_with openinventor Inventor)
		$(cmake-utils_use_with pdf Poppler-glib)
		$(cmake-utils_use_with png)
		$(cmake-utils_use_with qt4)
		$(cmake-utils_use !static-libs DYNAMIC_OPENSCENEGRAPH)
		$(cmake-utils_use_with sdl)
		$(cmake-utils_use_with svg RSVG)
		$(cmake-utils_use_with tiff)
		$(cmake-utils_use_with truetype FreeType)
		$(cmake-utils_use_with vnc LibVNCServer)
		$(cmake-utils_use_with wxwidgets wxWidgets)
		$(cmake-utils_use_with xine)
		$(cmake-utils_use xrandr OSGVIEWER_USE_XRANDR)
		$(cmake-utils_use_with zlib)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile doc_openscenegraph doc_openthreads
}

