# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_PN=tf
MY_PV=${PV//./_}

DESCRIPTION="Stick more enemies and become much stronger. Sticky 2D shooter, 'TUMIKI Fighters'. "
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/tf_e.html"
SRC_URI="http://www.asahi-net.or.jp/~cs8k-cyu/windows/${MY_PN}${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer
	dev-libs/bulletss"
RDEPEND=""

S=${WORKDIR}/${MY_PN}

pkg_setup() {
	games_pkg_setup

	# gcc must be built with "d" USE-FLAG
	if ! built_with_use sys-devel/gcc:4.1 d; then
		ewarn "sys-devel/gcc must be built with d for this package"
		ewarn "to function."
		die "recompile gcc with USE=\"d\""
	fi
	if [ "$(gcc-major-version)" == "4" ] && [ "$(gcc-minor-version)" == "2" ] ; then
		die "gdc doesn't work with sys-devel/gcc-4.2 currently - use 4.1 instead"
	fi
}

src_unpack(){
	unpack ${A}
	epatch "${FILESDIR}"/${P}.diff
	sed -i \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tf/src/abagames/util/sdl/sound.d \
	-e 's:"\(barrage[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tf/src/abagames/tf/barragemanager.d \
	-e 's:"\(enemy[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tf/src/abagames/tf/enemyspec.d \
	-e 's:"\(field[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tf/src/abagames/tf/field.d \
	-e 's:"\(stage[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tf/src/abagames/tf/stagemanager.d \
	-e 's:"\(tumiki[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i tf/src/abagames/tf/tumikiset.d \
	-e 's:"\(tf.prf[^"]*\)":"'${GAMES_STATEDIR}'/\1":g' -i tf/src/abagames/tf/prefmanager.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	if [ ! -e "${GAMES_STATEDIR}"/tf.prf ]; then
		dodir "${GAMES_STATEDIR}"
		touch ${D}/"${GAMES_STATEDIR}"/tf.prf
	fi

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r barrage enemy field sounds stage tumiki || die
	newicon "${FILESDIR}"/${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	chmod 660 "${GAMES_STATEDIR}"/tf.prf
	games_pkg_postinst
}
