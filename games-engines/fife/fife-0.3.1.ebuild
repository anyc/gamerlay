# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2"

inherit eutils python

DESCRIPTION="Flexible Isometric Free Engine, 2D"
HOMEPAGE="http://fifengine.de"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/active/src/${P}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="opengl debug profile"

EAPI="2"

DEPEND="dev-util/scons
	dev-lang/swig
	dev-libs/boost
	dev-python/pyyaml
	media-libs/libsdl
	media-libs/sdl-ttf
	media-libs/sdl-image[png]
	media-libs/libvorbis
	media-libs/libogg
	media-libs/openal
	sys-libs/zlib
	x11-libs/libXcursor
	x11-libs/libXext
	opengl? ( virtual/opengl virtual/glu )"
RDEPEND="${DEPEND}"

src_prepare() {
	rm -r ext #delete bundled libs
	epatch "${FILESDIR}/${P}-unbundle-libpng.patch"
}

src_compile() {
	local SCONS_ARGS=""
	if use debug; then
		SCONS_ARGS="$SCONS_ARGS debug=1 log=1"
	else
		SCONS_ARGS="$SCONS_ARGS debug=0 log=0"
	fi

	if use opengl; then
		SCONS_ARGS="$SCONS_ARGS opengl=1"
	else
		SCONS_ARGS="$SCONS_ARGS opengl=0"
	fi

	if use profile; then
		SCONS_ARGS="$SCONS_ARGS profile=1"
	else
		SCONS_ARGS="$SCONS_ARGS profile=0"
	fi
#	python_version
	scons --python-prefix=${D}/$(python_get_sitedir) --prefix="${D}/usr" $SCONS_ARGS || die 'scons failed'
}

src_install() {
	scons install-python --python-prefix=${D}/$(python_get_sitedir) --prefix="${D}/usr" || die 'install failed'
}

