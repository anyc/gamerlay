# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_PN=a7xpg
MY_PV=${PV//./_}

DESCRIPTION="The retro modern high speed shooting game"
HOMEPAGE="http://www.asahi-net.or.jp/~cs8k-cyu/windows/a7xpg_e.html"
SRC_URI="mirror://www.asahi-net.or.jp/~cs8k-cyu/windows/${MY_PN}${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/mesa
	media-libs/sdl-mixer"
RDEPEND=""

S=${WORKDIR}/${PN}

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
	-e 's:"\(images/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a7xpg/src/abagames/util/sdl/Texture.d \
	-e 's:"\(sounds/[^"]*\)":"'${GAMES_DATADIR}'/'${PN}'/\1":g' -i a7xpg/src/abagames/util/sdl/Sound.d \
	-e 's:"\(a7xpg.prf[^"]*\)":"'${GAMES_STATEDIR}'/\1":g' -i a7xpg/src/abagames/a7xpg/A7xPrefManager.d \
		|| die "sed failed"
}

src_install() {
	dogamesbin ${PN}

	local datadir="${GAMES_DATADIR}"/${PN}
	dodir ${datadir}
	insinto "${GAMES_DATADIR}"/"${PN}"
	doins -r images sounds || die

	if [ ! -e "${GAMES_STATEDIR}"/${PN}.prf ]
	then
		dodir "${GAMES_STATEDIR}"
	insinto "${GAMES_STATEDIR}"
	doins "${FILESDIR}"/a7xpg.prf  || die
	fperms 660 "${FILESDIR}"/a7xpg.prf
	fi

	newicon "${FILESDIR}"/${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc readme*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	chmod ug+rw "${GAMES_STATEDIR}"/${PN}.prf
}
