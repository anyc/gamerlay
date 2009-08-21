# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_P="ClanLib-${PV}"
inherit flag-o-matic eutils

DESCRIPTION="multi-platform game development library"
HOMEPAGE="http://www.clanlib.org/"
SRC_URI="http://clanlib.org/download/releases-${PV:0:3}/${MY_P}.tgz"

LICENSE="ZLIB"
SLOT="0.8"
KEYWORDS="~amd64 ~x86"
IUSE="opengl sdl vorbis doc mikmod ipv6 network pcre sqlite gui "

# opengl keyword does not drop the GL/GLU requirement.
# Autoconf files need to be fixed
RDEPEND="
	media-libs/libpng
	media-libs/jpeg
	media-libs/freetype
	opengl? ( 
		virtual/opengl
		virtual/glu
	)
	sdl? (
		media-libs/libsdl
		media-libs/sdl-gfx
	)
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libXxf86vm
	media-libs/alsa-lib
	pcre? ( dev-libs/libpcre )
	sqlite? ( dev-db/sqlite )
	mikmod? ( media-libs/libmikmod )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--enable-dyn \
		--enable-clanNetwork \
		--disable-dependency-tracking \
		$(use_enable x86 asm386) \
		$(use_enable doc docs) \
		$(use_enable opengl clanGL) \
		$(use_enable sdl clanSDL) \
		$(use_enable vorbis clanVorbis) \
		$(use_enable mikmod clanMikMod) \
		$(use_enable pcre clanRegExp) \
		$(use_enable sqlite clanSqlite) \
		$(use_enable network clanNetwork) \
		$(use_enable gui clanGUI) \
		$(use_enable ipv6 getaddr)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	if use doc ; then
		dodir /usr/share/doc/${PF}/html
		mv "${D}"/usr/share/doc/clanlib/* "${D}"/usr/share/doc/${PF}/html/ || die
		rm -rf "${D}"/usr/share/doc/clanlib
		cp -r Examples Resources "${D}"/usr/share/doc/${PF}/ || die
	fi
	dodoc CODING_STYLE CREDITS NEWS PATCHES README* INSTALL.linux
}
