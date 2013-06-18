# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils games scons-utils

DV=2
DESCRIPTION="Descent Rebirth - enhanced Descent ${DV} engine"
HOMEPAGE="http://www.dxx-rebirth.com/"
SRC_URI="mirror://sourceforge/dxx-rebirth/${PN}_v${PV}-src.tar.gz
	opl3? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-opl3-music.zip )
	sc55? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-sc55-music.zip )
	linguas_de? ( http://www.dxx-rebirth.com/download/dxx/res/d${DV}xr-briefings-ger.zip )"

LICENSE="D1X GPL-2 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdinstall debug ipv6 linguas_de +opengl opl3 sc55 +timidity"

DEPEND="opengl? ( virtual/opengl virtual/glu )
	dev-games/physfs[hog,mvl,zip]
	media-libs/libsdl[audio,opengl?,video]
	media-libs/sdl-mixer[timidity?]"
RDEPEND="${DEPEND}
	cdinstall? ( games-action/descent2-data )
	!cdinstall? ( games-action/descent2-demodata )"

S=${WORKDIR}/${PN}_v${PV}-src

src_unpack() {
	unpack ${PN}_v${PV}-src.tar.gz
}

src_compile() {
	escons \
		verbosebuild=1 \
		sharepath="${GAMES_DATADIR}/d${DV}x" \
		sdlmixer=1 \
		$(use_scons debug) \
		$(use_scons ipv6) \
		|| die
}

src_install() {

	local DOCS=({CHANGELOG,COPYING,INSTALL,README,RELEASE-NOTES}.txt)
	edos2unix ${DOCS[@]} || die
	dodoc ${DOCS[@]} || die

	insinto "${GAMES_DATADIR}/d${DV}x"

	# None of the following zip files need to be extracted.
	if use linguas_de ; then
		doins "${DISTDIR}"/d${DV}xr-briefings-ger.zip || die
	fi
	if use opl3 ; then
		doins "${DISTDIR}"/d${DV}xr-opl3-music.zip || die
	fi
	if use sc55 ; then
		doins "${DISTDIR}"/d${DV}xr-sc55-music.zip || die
	fi

	doicon "${S}/${PN}.xpm" || die

	local EXE=${PN}
	newgamesbin ${EXE} ${EXE} || die
	make_desktop_entry ${PN} "Descent ${DV} Rebirth" || die
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if ! use cdinstall ; then
		echo
		elog "The Descent ${DV} Demo data has been installed."
		elog "To play the full game enable USE=\"cdinstall\" or manually "
		elog "copy the files to ${GAMES_DATADIR}/d${DV}x."
		elog "Use bzcat /usr/share/doc/${PF}/INSTALL.txt.bz2 for details."
		echo
	fi
}
