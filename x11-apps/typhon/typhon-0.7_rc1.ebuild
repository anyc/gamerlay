# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-apps/typhontyphon-0.6.2.ebuild,v 1.0 2010/02/23 13:02:11 by frostwork Exp $

EAPI="2"

inherit eutils

DESCRIPTION="A slim and themeable opengl dashboard / program launcher"
HOMEPAGE="http://www.frostworx.de/programs/typhon.html"
SRC_URI="http://www.frostworx.de/typhon/${P/_/-}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="+emu sdl fmod glut png debug"

S="${WORKDIR}/${P/_/-}"

RDEPEND="media-libs/ftgl
	virtual/opengl
	glut? ( media-libs/freeglut )
	png? ( media-libs/glpng )
	sdl? ( media-libs/sdl-mixer )
	fmod? ( =media-libs/fmod-3* )"
DEPEND="${RDEPEND}"

src_prepare() {
	if use sdl && use fmod ; then
	ewarn "both sdl and fmod useflag not possible!"
	die "disable fmod useflag in favour of sdl-mixer"
	fi
	if use fmod; then
	echo "SOUNDFLAGS = -DFMOD -DSOUND" >> Makefile
	echo "SOUNDLIBS  = -lfmod" >> Makefile
	fi
	if use sdl; then
	echo "SOUNDFLAGS = -DSDLMIXER -DSOUND `sdl-config --cflags`" >> Makefile
	echo "SOUNDLIBS  = `sdl-config --libs` -lSDL_mixer" >> Makefile
	fi
	if use glut; then
	echo "GLUTFLAGS  = -DGLUT" >> Makefile
	echo "GLUTLIBS   = -lglut" >> Makefile
	fi
	if use png; then
	echo "PICFLAGS = -DPNG" >> Makefile
	echo "PICLIBS  = -lglpng" >> Makefile
	fi
	if use debug; then
	echo "DEBUGFLAGS   = -g" >> Makefile
	fi
	if use emu; then
	echo "EMUFLAGS     = -DEMU" >> Makefile
	fi
}

src_install() {
	dobin ${PN}
	newicon ${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc README
}
