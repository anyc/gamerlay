# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games versionator

MAJOR_VERSION=$(get_version_component_range 1-2)

DESCRIPTION="First-person ego-shooter, built as a total conversion of Cube Engine 2"
HOMEPAGE="http://www.redeclipse.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${MAJOR_VERSION}/${PN}_${PV}_nix_bsd.tar.bz2"

# According to license.txt file
LICENSE="as-is ZLIB CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated"

DEPEND="!dedicated? (
		media-libs/freetype:2
		media-libs/libsdl[opengl]
		media-libs/sdl-image[jpeg,png]
		media-libs/sdl-mixer[mp3,vorbis]
		virtual/opengl
		x11-libs/libX11
	)
	net-libs/enet:1.3
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	# Respect GAMES_DATADIR
	sed -i -e "s:\(addpackagedir(\"\)data:\1${GAMES_DATADIR}/${PN}/data:" \
		src/engine/server.cpp

	# Unbundle enet
	sed	-e "s:\(client\)\: libenet:\1\::" \
		-e "s:\(server\)\: libenet:\1\::" \
		-i src/Makefile
	rm -r src/enet

	#respect LDFLAGS
	sed -e "/^client/,+1s:-o reclient:-o reclient \$(LDFLAGS):" \
		-e "/^server/,+1s:-o reserver:-o reserver \$(LDFLAGS):" \
		-i src/Makefile

	# Menu and mans
	sed -e "s:@APPNAME@:${PN}:" \
		src/install/nix/redeclipse.desktop.am \
		> src/install/nix/redeclipse.desktop

	sed -e "s:@LIBEXECDIR@:$(games_get_libdir):g" \
		-e "s:@DATADIR@:${GAMES_DATADIR}:g" \
		-e "s:@DOCDIR@:${GAMES_DATADIR_BASE}/doc/${PF}:" \
		-e "s:@REDECLIPSE@:${PN}:g" \
		doc/man/redeclipse.6.am \
		> doc/man/redeclipse.6

	sed -e "s:@LIBEXECDIR@:$(games_get_libdir):g" \
		-e "s:@DATADIR@:${GAMES_DATADIR}:g" \
		-e "s:@DOCDIR@:${GAMES_DATADIR_BASE}/doc/${PF}:" \
		-e "s:@REDECLIPSE@:${PN}:g" \
		doc/man/redeclipse-server.6.am \
		> doc/man/redeclipse-server.6

}

src_compile() {
	cd src
	if ! use dedicated ; then
		emake CXXFLAGS="${CXXFLAGS}" STRIP= client server
	else
		emake CXXFLAGS="${CXXFLAGS}" STRIP= server
	fi
}

src_install() {
	newgamesbin src/reserver ${PN}-server
	doman doc/man/redeclipse-server.6
	dodoc readme.txt doc/examples/serv{exec,init}.cfg
	if ! use dedicated ; then
		newgamesbin src/reclient ${PN}

		insinto "${GAMES_DATADIR}"/${PN}
		doins -r data
		newicon src/install/nix/${PN}_x128.png ${PN}.png
		domenu src/install/nix/redeclipse.desktop
		doman doc/man/redeclipse.6
	fi

	prepgamesdirs
}
