# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib games

DESCRIPTION="2D physics puzzle / sandbox game, where your drawings would be magically transformed into real physical objects."
HOMEPAGE="http://crayonphysics.com/"

SRC_URI="amd64? ( ${PN}_${PV}_amd64.deb )
	x86? ( ${PN}_${PV}_i386.deb )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* amd64 ~x86"
IUSE=""
RESTRICT="strip fetch"

RDEPEND="
	x86? (
		app-arch/bzip2
		dev-libs/expat
		dev-libs/glib
		dev-libs/libffi
		media-libs/fontconfig
		media-libs/freetype:2
		virtual/glu
		media-libs/libogg
		media-libs/libpng
		virtual/opengl
		sys-apps/util-linux
		sys-libs/zlib
		x11-libs/libdrm
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXdamage
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXxf86vm
		x11-libs/qt-core
		x11-libs/qt-gui
	)
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-qtlibs
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-xlibs
	)
"

S="${WORKDIR}"


src_unpack() {
	unpack "${A}"
	cd "${S}"
	unpack "./data.tar.gz"
}

src_install() {
	GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${GAMEDIR}"
	exeinto "${GAMEDIR}"

	# install icon
	newicon opt/CrayonPhysicsDeluxe/icon.png ${PN}.png \
		|| die "install icon"

	# install docs
	dohtml opt/CrayonPhysicsDeluxe/readme.html

	# cleanup unneeded files
	(
		cd opt/CrayonPhysicsDeluxe
		rm	"icon.png" \
			"install_shortcuts.sh" \
			"launchcrayon.sh" \
			"launcher" \
			"LGPL.txt" \
			"LICENSE.txt" \
			"log.txt" \
			"README-CC.txt" \
			"README-GLEW.txt" \
			"readme.html" \
			"README-QT.txt" \
			"README-SDL.txt" \
			"uninstall_shortcuts.sh" \
			"update"
	)
	# install game files
	doins -r opt/CrayonPhysicsDeluxe/* || die "doins opt"

	# install shortcuts
	games_make_wrapper "${PN}" "./crayon" "${GAMEDIR}" "${GAMEDIR}/$(get_libdir)" || die "install shortcut"
	make_desktop_entry "${PN}" "Crayon Physics Deluxe" "${PN}"

	prepgamesdirs
}
