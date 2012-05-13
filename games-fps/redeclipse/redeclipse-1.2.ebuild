# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

DESCRIPTION="First-person ego-shooter, built as a total conversion of Cube Engine 2"
HOMEPAGE="http://www.redeclipse.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}/${PN}_${PV}_linux_bsd.tar.bz2
	http://sourceforge.net/apps/trac/redeclipse/export/3683/src/site/bits/favicon.png -> ${P}-favicon.png"

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
		src/engine/server.cpp || die

	# Unbundle enet
	sed	-e "s:\(client\)\: libenet:\1\::" \
		-e "s:\(server\)\: libenet:\1\::" \
		-i src/Makefile || die
	rm -r src/enet || die

	#respect LDFLAGS
	sed -e "/^client/,+1s:-o reclient:-o reclient \$(LDFLAGS):" \
		-e "/^server/,+1s:-o reserver:-o reserver \$(LDFLAGS):" \
		-i src/Makefile || die

	# Menu and mans
	sed -e "s:@REDECLIPSE@:${PN}:" \
		src/install/nix/redeclipse.desktop.am \
		> src/install/nix/redeclipse.desktop || die

	sed -e "s:@LIBEXECDIR@:$(games_get_libdir):g" \
		-e "s:@DATADIR@:${GAMES_DATADIR}:g" \
		-e "s:@DOCDIR@:${GAMES_DATADIR_BASE}/doc/${PF}:" \
		-e "s:@REDECLIPSE@:${PN}:g" \
		src/install/nix/redeclipse.6.am \
		> src/install/nix/redeclipse.6 || die

	sed -e "s:@LIBEXECDIR@:$(games_get_libdir):g" \
		-e "s:@DATADIR@:${GAMES_DATADIR}:g" \
		-e "s:@DOCDIR@:${GAMES_DATADIR_BASE}/doc/${PF}:" \
		-e "s:@REDECLIPSE@:${PN}:g" \
		src/install/nix/redeclipse-server.6.am \
		> src/install/nix/redeclipse-server.6 || die

}

src_compile() {
	cd src
	if ! use dedicated ; then
		emake CXXFLAGS="${CXXFLAGS}" STRIP= client server || die "Make failed"
	else
		emake CXXFLAGS="${CXXFLAGS}" STRIP= server || die "Make failed"
	fi
}

src_install() {
	newgamesbin src/reserver ${PN}-server || die
	doman src/install/nix/redeclipse-server.6 || die
	dodoc readme.txt data/examples/servexec.cfg data/examples/servinit.cfg
	if ! use dedicated ; then
		newgamesbin src/reclient ${PN} || die

		# Don't include examples into datadir
		rm data/examples/servexec.cfg data/examples/servinit.cfg
		insinto "${GAMES_DATADIR}"/${PN}
		doins -r data
		newicon "${DISTDIR}/${P}-favicon.png" ${PN}.png || die
		domenu src/install/nix/redeclipse.desktop
		doman src/install/nix/redeclipse.6
	fi

	prepgamesdirs
}
