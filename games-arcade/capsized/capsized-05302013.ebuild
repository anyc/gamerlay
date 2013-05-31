# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games multilib

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="${PN}-${PV}-bin"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="linguas_de linguas_es linguas_fr linguas_it"

RESTRICT="fetch"

DEPEND="app-arch/zip"
RDEPEND="
	${DEPEND}
	media-libs/libtheora
	media-libs/libogg
	media-libs/libvorbis
	dev-lang/mono
	media-libs/openal
	media-libs/libsdl:2
"

DOCS=( "Linux.README" )

S="${WORKDIR}/data"
GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

MY_PN=Capsized

pkg_nofetch() {
	einfo "Please download ${A}"
	einfo "from your personal page in Humble Indie Bundle site"
	einfo "(http://www.humblebundle.com)"
	einfo "and place it to ${DESTDIR}"
}

src_unpack() {
	local a=${DISTDIR}/${A}
	echo ">>> Unpacking ${a} to ${PWD}"
	unzip -q "${a}"
	[ $? -gt 1 ] && die "unpacking failed"
}

src_install() {
	local arch;
	use x86 && arch=x86;
	use amd64 && arch=x86_64;

	insinto "${GAMEDIR}"
	doins -r \
		Content \
		Properties \
		mono \
		"${MY_PN}.bmp" \
		NePlusUltra.exe \
		*.dll *.config

	for lang in fr it es de; do
		use "linguas_${lang}" && doins "${lang}"
	done

	# Installing bundled sdl2-mixer, since it is still not released [hg only]
	insinto "${GAMEDIR}/$(get_libdir)"
	doins "$(get_libdir)/libSDL2_mixer-2.0.so.0"

	exeinto "${GAMEDIR}"
	doexe "NePlusUltra.bin.${arch}"

	games_make_wrapper "${PN}" "./NePlusUltra.bin.${arch}" "${GAMEDIR}" "${GAMEDIR}/$(get_libdir)"
	doicon "${FILESDIR}/${PN}.png"
	make_desktop_entry "${PN}" "${MY_PN}" "${PN}"

	prepgamesdirs
}
