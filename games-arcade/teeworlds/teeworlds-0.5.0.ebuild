# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs eutils games

BAM_P="bam-0.2.0"
DESCRIPTION="Online 2D platform shooter."
HOMEPAGE="http://www.teeworlds.com"
SRC_URI="http://www.teeworlds.com/files/${P}-src.tar.gz -> ${P}-src.tar.gz
	http://teeworlds.com/trac/bam/browser/releases/bam-0.2.0.tar.gz?format=raw
	-> ${BAM_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated"

RDEPEND="dev-lang/lua
	!dedicated? (
		media-libs/libsdl[X,alsa,opengl]
		sys-libs/zlib
	)"
# has modified wavpack and pnglite in its sources
# not worth of effort patching up to system ones
DEPEND="${RDEPEND}
	app-arch/zip"

S="${WORKDIR}"/${P}-src

src_prepare() {
	rm -f license.txt
}

src_compile() {
	# compile bam
	ebegin "Preparing BAM"
	cd "${WORKDIR}"/${BAM_P}
	$(tc-getCC) ${CFLAGS} src/tools/txt2c.c -o src/tools/txt2c || die
	src/tools/txt2c src/base.bam src/driver_gcc.bam \
	src/driver_cl.bam > src/internal_base.h || die
	# internal lua sources!
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} \
		src/lua/*.c src/*.c -o src/bam \
		-I /usr/include/ -lm -lpthread || die
	eend $?
	# compile game
	cd "${S}"
	# TODO: set correct cflags and ldflags
	if use dedicated ; then
		../${BAM_P}/src/bam -v server_release || die "bam failed"
	else
		../${BAM_P}/src/bam -v release || die "bam failed"
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
