# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-apps/typhontyphon-0.6.ebuild,v 1.0 2010/02/23 13:02:11 by frostwork Exp $

EAPI="2"

inherit eutils

DESCRIPTION="A slim and themeable opengl dashboard / program launcher"
HOMEPAGE="http://www.frostworx.de/programs/typhon.html"
SRC_URI="http://www.frostworx.de/typhon/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="+sound +glut"

RDEPEND="media-libs/ftgl
	virtual/opengl
	glut? ( media-libs/freeglut )
	sound? ( =media-libs/fmod-3* )"
DEPEND="${RDEPEND}"

src_compile() {
	emake $(use sound && echo "SOUNDFLAGS=-DFMOD" && echo "SOUNDLIBS=-lfmod")\
	$(use glut && echo "GLUTFLAGS=-DGLUT" && echo "GLUTLIBS=-lglut")|| die "emake failed"
}

src_install() {
	dobin ${PN}
	newicon ${PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc README
}
