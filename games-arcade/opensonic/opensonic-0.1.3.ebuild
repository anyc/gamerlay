# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils games 

MY_PN=opensnc

DESCRIPTION="Open Sonic is a free open-source game based on the Sonic the Hedgehog universe."
HOMEPAGE="http://opensnc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=media-libs/allegro-4.4.1.1-r1[png]
	media-libs/libvorbis
	media-libs/aldumb"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}-src-${PV}

src_prepare(){
	epatch ${FILESDIR}/"${P}-loadpng.patch"
	# the configure script activates egamesconf which we don't want here
	rm configure
}

src_compile() {
	GAME_INSTALL_DIR="${GAMES_DATADIR}"/"${PN}" OPENSNC_ALLEGRO_LIBS=`allegro-config --libs` OPENSNC_ALLEGRO_VERSION=`allegro-config --version` cmake .
	emake || die "make failed"
}

src_install() {
	local datadir="${GAMES_DATADIR}"/${PN}
	insinto "${datadir}"
	doins -r config images languages levels licenses musics quests samples screenshots themes || die "data install failed"
	exeinto "${GAMES_DATADIR}"/${PN}
	doexe ${PN}
	games_make_wrapper ${PN} "${GAMES_DATADIR}"/"${PN}"/"${PN}"
	newicon icon.png "${PN}".png
	make_desktop_entry "${PN}" "${PN}"
	dodoc readme.html
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}