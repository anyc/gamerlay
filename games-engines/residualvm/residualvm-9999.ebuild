# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games git-2

DESCRIPTION="A cross-platform 3D game interpreter for play LucasArts' LUA-based 3D adventures"
HOMEPAGE="http://www.residualvm.org/"
#SRC_URI=""
EGIT_REPO_URI="https://github.com/residualvm/residualvm.git"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="alsa faad flac fluidsynth mad mpeg2 nasm png timidity vorbis"

RDEPEND="
	faad? ( media-libs/faad2 )
	flac? ( media-libs/flac )
	media-libs/freetype
	mad? ( media-libs/libmad )
	mpeg2? ( media-libs/libmpeg2 )
	png? ( media-libs/libpng )
	vorbis? ( media-libs/libvorbis )
	media-libs/libsdl
	fluidsynth? ( media-sound/fluidsynth )
	timidity? ( media-sound/timidity++ )
	sys-libs/zlib
	virtual/opengl"
DEPEND="${RDEPEND}
	nasm? ( dev-lang/nasm )"

src_configure() {
	# econf can't work here, configure script not have some options
	./configure \
		--backend=sdl --enable-release --disable-tremor \
		--disable-sparkle \
		--prefix="${GAMES_PREFIX}" \
		--datadir="${GAMES_DATADIR}/${PN}" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		--disable-libunity \
		$(use_enable faad) \
		$(use_enable flac) \
		$(use_enable fluidsynth) \
		$(use_enable mad) \
		$(use_enable mpeg2) \
		$(use_enable nasm) \
		$(use_enable png) \
		$(use_enable vorbis) \
	|| die "configure failed"
}

src_install() {
	dogamesbin residualvm
	insinto "${GAMES_DATADIR}/${PN}"
	doins gui/themes/modern.zip
	doins dists/engine-data/residualvm-grim-patch.lab
	doicon icons/${PN}.xpm
	domenu dists/${PN}.desktop
	doman dists/${PN}.6
	dodoc README
	prepgamesdirs
}
