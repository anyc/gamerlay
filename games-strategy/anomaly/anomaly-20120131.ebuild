# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit games

DESCRIPTION="An extraordinary mixture of action and strategy in a reversed tower defense formula."
HOMEPAGE="http://www.anomalythegame.com/"
SRC_URI="
		x86? ( linux-anomaly-i386-1327984913.tar.gz )
		amd64? ( linux-anomaly-amd64.tar.gz )
"
RESTRICT="fetch strip"
LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	x86? (
		media-libs/openal
		x11-libs/libdrm
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXdamage
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXxf86vm
	)
	amd64? (
		app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-sdl
	)
	virtual/opengl
"

REQUIRED_USE="amd64? ( multilib )"

S="${WORKDIR}/Anomaly"

pkg_nofetch() {
	ewarn
	ewarn "Put ${A} (downloaded from Humble Store) to ${DISTDIR}, please"
	ewarn
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	newicon "icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "Anomaly: Warzone Earth" "${PN}"
	games_make_wrapper "${PN}" "./AnomalyWarzoneEarth" "${dir}"
	dodoc README
	exeinto "${dir}"
	doexe "AnomalyWarzoneEarth"
	rm	"libgcc_s.so.1" \
		"libopenal.so.1" \
		"libstdc++.so.6" \
		"icon.png" \
		"install.sh" \
		"uninstall.sh" \
		"README" \
		"AnomalyWarzoneEarth"

	insinto "${dir}"
	doins -r .

	prepgamesdirs
}
