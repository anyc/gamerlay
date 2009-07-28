# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs eutils games

DESCRIPTION="Online 2D platform shooter."
HOMEPAGE="http://www.teeworlds.com"
SRC_URI="http://www.teeworlds.com/files/${P}-src.tar.gz
	http://www.teeworlds.com/files/bam.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated"

RDEPEND="dev-lang/lua
	!dedicated? (
		media-libs/alsa-lib
		media-libs/glfw
		media-libs/mesa
		media-libs/portaudio
		media-sound/wavpack
		sys-libs/zlib
		x11-libs/libX11
	)"
DEPEND="${RDEPEND}
	app-arch/zip"

S=${WORKDIR}/${P}-src

src_unpack() {
	local x

	unpack ${A}
	cd "${S}"
	# the data-dir needs to be patched in some files
	sed -i \
		-e "s:data/:${GAMES_DATADIR}/${PN}/data/:g" \
		$(grep -Rl '"data\/' *) \
		|| die "sed failed"
	rm -f license.txt
	# strip out bundled libraries which have package in the tree
	rm -rf src/engine/external/glfw
	rm -rf src/engine/external/portaudio
	rm -rf src/engine/external/wavpack
	rm -rf src/engine/external/zlib
	epatch "${FILESDIR}"/"${P}"-bam.patch
}

src_compile() {
	# compile bam maybe separate ebuild?
	cd "${WORKDIR}"/bam
	$(tc-getCC) ${CFLAGS} src/tools/txt2c.c -o src/tools/txt2c || die
	src/tools/txt2c < src/base.bam > src/internal_base.h || die
	# note this needs bundled lua 5.0 does not work with 5.1
	# not bothering us since we dont install bam itself but teeworlds
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} \
		src/lua/src/*.c src/lua/src/lib/*.c src/*.c -o src/bam \
		-I src/lua/include/ -lm -lpthread || die
	# compile game
	cd "${S}"
	sed -i \
		-e "s|cc.flags = \"-Wall -pedantic-errors\"|cc.flags = \"${CXXFLAGS}\"|" \
		-e "s|linker.flags = \"\"|linker.flags = \"${LDFLAGS}\"|" \
		-e "s|-Wall -fstack-protector -fstack-protector-all -fno-exceptions|${CXXFLAGS}|" \
		default.bam || die "sed failed"

	if use dedicated ; then
		../bam/src/bam -v server_release || die "bam failed"
	else
		../bam/src/bam -v release || die "bam failed"
	fi
}

src_install() {
	dogamesbin ${PN}_srv || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"/data/maps
	doins data/maps/* || die "doins failed"

	if ! use dedicated ; then
		dogamesbin ${PN} || die "dogamesbin failed"
		insinto "${GAMES_DATADIR}/${PN}"
		doins -r data || die "doins failed"
		make_desktop_entry ${PN} "Teeworlds"
	fi
	dodoc *.txt
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "For more information about server setup read:"
	elog "http://www.teeworlds.com/?page=docs"
}
