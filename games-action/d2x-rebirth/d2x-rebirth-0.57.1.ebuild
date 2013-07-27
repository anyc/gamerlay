# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games scons-utils

DESCRIPTION="Descent Rebirth - enhanced Descent 2 engine"
HOMEPAGE="http://www.dxx-rebirth.com/"
SRC_URI="mirror://sourceforge/dxx-rebirth/${PN}_v${PV}-src.tar.gz
		linguas_de?  ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-briefings-ger.zip )
		music_awe32? ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-awe32enh-music.zip )
		music_opl3?  ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-opl3-music.zip )
		music_sc55?  ( http://www.dxx-rebirth.com/download/dxx/res/d2xr-sc55-music.zip )"

LICENSE="D1X GPL-2 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug editor ipv6 linguas_de music_awe32 music_opl3 music_sc55 opengl"

DEPEND="dev-games/physfs[hog,mvl,zip]
	media-libs/libsdl:0
	media-libs/sdl-mixer[vorbis]:0"
RDEPEND="${DEPEND}
	opengl? ( virtual/opengl virtual/glu )"

S=${WORKDIR}/${PN}_v${PV}-src

src_unpack() {
	# We need unpack only sources. Keep zipped mods intact!
	unpack ${PN}_v${PV}-src.tar.gz
}

src_compile() {
	scons ${MAKEOPTS} \
		sharepath="${GAMES_DATADIR}/d2x" \
		sdlmixer=1 \
		use_tracker=1 \
		use_udp=1 \
		$(use_scons debug) \
		$(use_scons editor) \
		$(use_scons opengl) \
		$(use_scons ipv6)
}

src_install() {
	edos2unix {INSTALL,README}.txt
	dodoc {INSTALL,README}.txt
	insinto "${GAMES_DATADIR}/d2x"
	use linguas_de  && doins "${DISTDIR}"/d2xr-briefings-ger.zip
	use music_awe32 && doins "${DISTDIR}"/d2xr-awe32enh-music.zip
	use music_opl3  && doins "${DISTDIR}"/d2xr-opl3-music.zip
	use music_sc55  && doins "${DISTDIR}"/d2xr-sc55-music.zip
	doicon ${PN}.xpm

	dogamesbin d2x-rebirth
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
