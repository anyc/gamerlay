# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit games scons-utils

DESCRIPTION="Descent Rebirth - enhanced Descent 2 engine"
HOMEPAGE="http://www.dxx-rebirth.com/"
SRC_URI="mirror://sourceforge/dxx-rebirth/${PN}_v${PV}-src.tar.gz
		linguas_de? ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-briefings-ger.zip )
		music? ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-sc55-music.zip )"

LICENSE="D1X GPL-2 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug ipv6 linguas_de music opengl"

DEPEND="dev-games/physfs[hog,mvl,zip]
	media-libs/libsdl
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}
	virtual/opengl
	virtual/glu"

S=${WORKDIR}/${PN}_v${PV}-src

src_unpack() {
	unpack ${PN}_v${PV}-src.tar.gz
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-printf-fix.patch
}

src_compile() {
	scons ${MAKEOPTS} \
		sharepath="${GAMES_DATADIR}/d2x" \
		sdlmixer=1 \
		$(use_scons debug) \
		$(use_scons !opengl sdl_only) \
		$(use_scons ipv6)
}

src_install() {
	edos2unix INSTALL.txt README.txt
	dodoc INSTALL.txt README.txt
	insinto "${GAMES_DATADIR}/d2x"
	use linguas_de && doins "${DISTDIR}"/d2xr-briefings-ger.zip
	use music && doins "${DISTDIR}"/d2xr-sc55-music.zip
	doicon ${PN}.xpm

	if use opengl ; then
		newgamesbin d2x-rebirth-gl d2x-rebirth
	else
		newgamesbin d2x-rebirth-sdl d2x-rebirth
	fi
	make_desktop_entry d2x-rebirth "Descent 2 Rebirth" ${PN}
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "You need to copy data-files from original Descent 2 installation"
	elog "to ${GAMES_DATADIR}/d2x. Please read "
	elog "/usr/share/doc/${PF}/INSTALL.txt for more info."
	elog "You can emerge games-action/descent2-demodata (for Demo) or"
	elog "games-action/descent2-data (if you have original Descent 2 CD)."
}
