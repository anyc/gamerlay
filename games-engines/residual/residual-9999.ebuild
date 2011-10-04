# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games git-2

DESCRIPTION="A cross-platform 3D game interpreter for play LucasArts' LUA-based 3D adventures"
HOMEPAGE="http://residual.sourceforge.net/"
#SRC_URI=""
EGIT_REPO_URI="https://github.com/residual/residual.git"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="flac mad mpeg2 vorbis"

DEPEND="flac? ( media-libs/flac )
	mad? ( media-libs/libmad )
	mpeg2? ( media-libs/libmpeg2 )
	vorbis? ( media-libs/libvorbis )
	media-libs/libsdl
	sys-libs/zlib
	virtual/opengl"
RDEPEND="${DEPEND}"

src_configure() {
	# econf can't work here, configure script not have some options
	./configure \
		--backend=sdl --enable-release --disable-tremor --disable-fluidsynth \
		--disable-libunity \
		--prefix="${GAMES_PREFIX}" \
		--datadir="${GAMES_DATADIR}" \
		$(use_enable flac) \
		$(use_enable mad) \
		$(use_enable mpeg2) \
		$(use_enable vorbis) \
	|| die "configure failed"
}

src_install() {
	dogamesbin residual
	insinto "${GAMES_DATADIR}/residual"
	doins gui/themes/modern.zip
	doicon icons/residual.xpm
	make_desktop_entry ${PN} Residual ${PN}
	dodoc README
	prepgamesdirs
}
