# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/irrlicht/irrlicht-1.7.2.ebuild,v 1.5 2011/04/08 03:21:08 mr_bones_ Exp $

EAPI=3
inherit eutils toolchain-funcs subversion

DESCRIPTION="open source high performance realtime 3D engine written in C++"
HOMEPAGE="http://irrlicht.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
ESVN_REPO_URI="https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk/"
ESVN_REVISION=3993

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug examples"

RDEPEND="virtual/jpeg
	media-libs/libpng
	app-arch/bzip2
	sys-libs/zlib
	virtual/opengl
	x11-libs/libXxf86vm
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xf86vidmodeproto"
#app-arch/unzip

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc46.patch \
		"${FILESDIR}"/${P}-unbundle-libs.patch \
		"${FILESDIR}"/${PN}-9999-demoMake.patch

	sed -i \
		-e 's:\.\./\.\./media:../media:g' \
		$(grep -rl '\.\./\.\./media' examples) \
		|| die 'sed failed'
	sed "/VERSION_RELEASE/s/-SVN//" -i source/Irrlicht/Makefile || die 'sed failed'
}

src_compile() {
	cd source/Irrlicht
	tc-export CXX CC AR
	use !debug && config="NDEBUG=1"
	# staticlib removed (static-libs USE?)
	emake ${config} sharedlib || die "emake failed"
}

src_install() {
#	dolib.a lib/Linux/libIrrlicht.a || die
	insinto /usr/include/${PN}
	doins include/* || die
	dodoc changes.txt readme.txt
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples media || die
	fi
	cd lib/Linux
	ln -s libIrrlicht.so.1.8.0 libIrrlicht.so
	ln -s libIrrlicht.so.1.8.0 libIrrlicht.so.1.8
	dolib.so libIrrlicht.so* || die
#   dolib.a lib/Linux/libIrrlicht.a || die

}
