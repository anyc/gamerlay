# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils python scons-utils

DESCRIPTION="Flexible Isometric Free Engine, 2D"
HOMEPAGE="http://fifengine.de"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/active/src/${PN}_${PV}${PR}.tar.gz"

LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug profile"

RDEPEND="dev-libs/boost
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
	dev-games/guichan[sdl,opengl]
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	dev-lang/swig"

S=${WORKDIR}/${PN}_${PV}${PR}

# just setting RESTRICT_PYTHON_ABI is not enough to install only for python2
pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	rm -r ext #delete bundled libs
	epatch "${FILESDIR}/${P}-unbundle-libpng.patch"
	# apply upstream changeset 3949 to remove memory leak warning on console
	epatch "${FILESDIR}/${P}-fix-memory-leak.patch"
}

# Compile is only succesfull with one thread
SCONSOPTS="-j1"

src_compile() {
	escons \
		--python-prefix="${D}/$(python_get_sitedir)" \
		--prefix="${D}/usr" \
		$(use_scons debug) \
		$(use_scons debug log log) \
		$(use_scons profile) \
		|| die "scons failed"
}

src_install() {
	escons install-python --python-prefix="${D}/$(python_get_sitedir)" \
			--prefix="${D}/usr" || die "install failed"
}
