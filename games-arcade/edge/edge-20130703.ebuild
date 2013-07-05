EAPI="5"

inherit base games unpacker-nixstaller
# multilib

MY_PN="${PN^^}"
TS="1372878397"
MY_P="${MY_PN}_${PV:0:4}-${PV:4:2}-${PV:6:2}_Linux_${TS}"

DESCRIPTION="Develop your telekinetic strength by pushing a Cube within a geometric universe."
HOMEPAGE="http://mobigame.net/"
SRC_URI="${MY_P}.sh"
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

S="${WORKDIR}"

DOCS=( "README.linux" )

src_unpack() {
	local arch=x86
	use amd64 && arch=x86_64
	nixstaller_unpack "instarchive_all" "instarchive_all_${arch}"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	local arch=x86
	use amd64 && arch=x86_64

	exeinto "${dir}"
	insinto "${dir}"

	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}"
	games_make_wrapper "${PN}" "./${PN}" "${dir}"

	newexe "${MY_PN}.bin.${arch}" "${PN}"
	doicon "${MY_PN}.png"

	doins -r \
		"namespace.txt" \
		"cos.bin" \
		"font.bin" \
		"audio" \
		"config" \
		"default" \
		"effects" \
		"images" \
		"levels" \
		"localization" \
		"models" \
		"music" \
		"sprites" \
		"textures"

	prepgamesdirs

	base_src_install_docs
}
