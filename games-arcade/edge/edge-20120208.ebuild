EAPI=5

inherit games
# multilib

MY_P="${PN}-${PV}-1"

DESCRIPTION="Develop your telekinetic strength by pushing a Cube within a geometric universe."
HOMEPAGE="http://mobigame.net/"
SRC_URI="amd64? ( ${MY_P}-amd64.tar.gz )
	x86? ( ${MY_P}-i386.tar.gz )"
RESTRICT="fetch"

# Bundled libs :(
#QA_PRESTRIPPED="${GAMES_PREFIX_OPT}/${PN}/lib.*"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/bzip2
	dev-libs/expat
	media-libs/fontconfig
	sys-libs/zlib
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXrender
	x11-libs/libXxf86vm
	virtual/opengl
	media-libs/freetype:2
"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

S="${WORKDIR}/${PN}"

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	exeinto "${dir}"
	insinto "${dir}"

	make_desktop_entry "${PN}" "EDGE" "EDGE"
	games_make_wrapper "${PN}" "./EDGE.bin" "${dir}"

	dodoc "README"
	doexe "EDGE.bin"
	doicon "EDGE.png"

	rm \
		"EDGE.desktop.in" \
		"EDGE.png" \
		"EDGE.bin" \
		"edge.in" \
		"README" \
		"install.sh" \
		"uninstall.sh"
	rm -rf lib lib64

	doins -r *
	prepgamesdirs
}
