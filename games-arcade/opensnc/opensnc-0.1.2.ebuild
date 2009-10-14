# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

MY_PN=opensonic

DESCRIPTION="Open Sonic is a free open-source game based on the Sonic the Hedgehog universe."
HOMEPAGE="http://opensnc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="media-libs/allegro
	media-libs/libvorbis
	media-libs/aldumb
	media-libs/alpng"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-src${PV}

src_prepare(){
	# the configure script activates egamesconf which we don't want here
	rm configure
}

src_compile() {
	GAME_INSTALL_DIR="${GAMES_DATADIR}"/"${MY_PN}" OPENSNC_ALLEGRO_LIBS=`allegro-config --libs` OPENSNC_ALLEGRO_VERSION=`allegro-config --version` cmake .
	emake || die "make failed"
}

src_install() {
	local datadir="${GAMES_DATADIR}"/${MY_PN}
	insinto "${datadir}"
	doins -r config gui images languages levels licenses musics quests samples screenshots themes || die "data install failed"
	exeinto "${GAMES_DATADIR}"/${MY_PN}
	doexe ${MY_PN}
	doexe ${MY_PN}_launcher
	games_make_wrapper ${PN} "${GAMES_DATADIR}"/"${MY_PN}"/"${MY_PN}"
	games_make_wrapper ${PN}_launcher "${GAMES_DATADIR}"/"${MY_PN}"/"${MY_PN}"_launcher
	newicon images/icon.png "${MY_PN}".png
	make_desktop_entry "${MY_PN}" "${MY_PN}"
	dodoc readme.html
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}