# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit d-games

MY_PN=a2k
MY_PV=${PV//./_}

DESCRIPTION="jumpei isshiki's HelloWorldProject (2005/01/17) "
HOMEPAGE="http://homepage2.nifty.com/isshiki/prog_win_d.html"
SRC_URI="mirror://homepage2.nifty.com/isshiki/${MY_PN}.zip
	mirror://homepage2.nifty.com/isshiki/${MY_PN}_src.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer
	dev-libs/bulletss"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

src_unpack(){
	cd "${WORKDIR}"
	unpack ${MY_PN}.zip
	cd "${S}"
	unpack ${MY_PN}_src.zip

}

src_prepare(){
	epatch "${FILESDIR}"/${P}.diff
	sed -i \
	-e 's:"\(icon.bmp[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/util_pad.d \
	-e 's:"\(title.bmp[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
	-e 's:"\(stg0[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
	-e 's:"\(boss0[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
	-e 's:"\(se_[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
	-e 's:"\(voice[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
	-e 's:"\(bullet[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a2k_src/src/init.d \
	-e 's:"\(score.dat[^"]*\)":"'${GAMES_STATEDIR}'/'a2k'\1":g' -i a2k_src/src/init.d \
	-e 's:"\(config.dat[^"]*\)":"'${GAMES_STATEDIR}'/'a2k'\1":g' -i a2k_src/src/init.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin failed"

	local datadir="${GAMES_DATADIR}"/${PN}
		dodir "${GAMES_STATEDIR}"
		touch ${D}/"${GAMES_STATEDIR}"/a2kscore.dat  || die "touch failed"
		fperms 660 "${GAMES_STATEDIR}"/a2kscore.dat
		touch ${D}/"${GAMES_STATEDIR}"/a2kconfig.dat  || die "touch failed"
		fperms 660 "${GAMES_STATEDIR}"/a2kconfig.dat

	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins *.xml *.bmp *.ogg *.wav || die
	newicon "${FILESDIR}"/${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
