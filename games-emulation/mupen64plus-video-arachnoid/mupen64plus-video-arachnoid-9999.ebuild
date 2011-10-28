# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils games mercurial

DESCRIPTION="Arachnoid high-level graphics emulation for mupen64plus"
HOMEPAGE="http://code.google.com/p/mupen64plus/"
EHG_REPO_URI="https://bitbucket.org/wahrhaft/${PN}"
#SRC_URI="https://bitbucket.org/wahrhaft/${PN}/downloads/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug pic"

RDEPEND="games-emulation/mupen64plus-core
	virtual/opengl
	virtual/glu"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

OPTS="V=1 PREFIX=${GAMES_PREFIX} LIBDIR=$(games_get_libdir) BINDIR=${GAMES_BINDIR} APIDIR=/usr/include/mupen64plus/ INCDIR=/usr/include/mupen64plus/ SHAREDIR=${GAMES_DATADIR} DESTDIR=${D} COREDIR=$(games_get_libdir)/ PLUGINDIR=$(games_get_libdir)/mupen64plus/ MANDIR=/usr/share/man V=1 OPTFLAGS= INSTALL_STRIP_FLAG="

src_compile() {
	use debug && OPTS+=" DEBUG=1 DEBUGGER=1 PLUGINDBG=1"
	use pic && OPTS+=" PIC=1 PIE=1"

	emake -C "projects/unix" all $OPTS || die "make failed"
}

src_install() {
	emake -C "projects/unix" install $OPTS || die "install failed"
	[ -f "RELEASE" ] && newdoc "RELEASE" "RELEASE"
	[ -f "README" ] && newdoc "README" "README"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
}
