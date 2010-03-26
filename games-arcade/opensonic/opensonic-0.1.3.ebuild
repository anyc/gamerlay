# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games cmake-utils

MY_PN=opensnc
MY_P=${MY_PN}-src-${PV}

DESCRIPTION="Open Sonic is a free open-source game based on the Sonic the Hedgehog universe."
HOMEPAGE="http://opensnc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/allegro-4.4.1.1-r1[png]
	media-libs/libvorbis
	media-libs/aldumb"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${P}-loadpng.patch"
)

src_configure() {
	export OPENSNC_ALLEGRO_LIBS=`allegro-config --libs`
	export OPENSNC_ALLEGRO_VERSION=`allegro-config --version`
	cmake-utils_src_configure
}

src_install() {
	local datadir="${GAMES_DATADIR}"/${PN}
	insinto "${datadir}"
	doins -r config images languages levels licenses musics quests samples screenshots themes || die "data install failed"
	exeinto "${GAMES_DATADIR}"/${PN}
	doexe "${CMAKE_BUILD_DIR}"/${PN} || die
	games_make_wrapper ${PN} "${GAMES_DATADIR}"/"${PN}"/"${PN}"
	newicon icon.png "${PN}".png || die
	make_desktop_entry "${PN}" "${PN}"
	dohtml readme.html || die
	prepgamesdirs
}
