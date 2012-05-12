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

src_unpack() {
	unpack $A
	einfo "Copying favicon.png into ${WORKDIR}"
	cp "${DISTDIR}"/${P}-favicon.png "${WORKDIR}/favicon.png" || die
}

src_prepare() {
	# Respect GAMES_DATADIR
	sed -i -e "s:\(addpackagedir(\"\)data:\1${GAMES_DATADIR}/${PN}/data:" \
		src/engine/server.cpp || die

	# Unbundle enet
	sed -i \
		-e "s:\(client\)\: libenet:\1\::" \
		-e   "s:\(server\)\: libenet:\1\::" \
		src/Makefile || die
	rm -r src/enet || die

	#respect LDFLAGS
	sed -e "/^client/,+1s:-o reclient:-o reclient \$(LDFLAGS):" \
		-e "/^server/,+1s:-o reserver:-o reserver \$(LDFLAGS):" \
		-i src/Makefile || die
}

src_compile() {
	cd src
	if ! use dedicated ; then
		emake CXXFLAGS="${CXXFLAGS}" STRIP= client server || die "Make failed"
	else
		emake CXXFLAGS="${CXXFLAGS}" STRIPT= server
	fi
}

src_install() {
	newgamesbin src/reserver ${PN}-server || die
	dodoc readme.txt
	if ! use dedicated ; then
		newgamesbin src/reclient ${PN} || die
		insinto "${GAMES_DATADIR}"/${PN}
		doins -r data
		newicon ${WORKDIR}/favicon.png ${PN}.png || die
		make_desktop_entry ${PN} "Red Eclipse" ${PN}
	fi

	prepgamesdirs
}
