# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/irrlicht/irrlicht-1.7.2.ebuild,v 1.5 2011/04/08 03:21:08 mr_bones_ Exp $

EAPI=2
inherit eutils toolchain-funcs subversion

DESCRIPTION="open source high performance realtime 3D engine written in C++"
HOMEPAGE="http://irrlicht.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
ESVN_REPO_URI="https://irrlicht.svn.sourceforge.net/svnroot/irrlicht/trunk/"
ESVN_REVISION=3843

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="virtual/jpeg
	media-libs/libpng
	app-arch/bzip2
	virtual/opengl
	x11-libs/libX11"
DEPEND="${RDEPEND}
	app-arch/unzip
	x11-proto/xproto
	x11-proto/xf86vidmodeproto"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-9999-gentoo.patch
	edos2unix include/IrrCompileConfig.h
	epatch \
		"${FILESDIR}"/"${PN}"-9999-config.patch \
		"${FILESDIR}"/${PN}-9999-demoMake.patch \
		"${FILESDIR}"/${PN}-1.7.2-gcc46.patch

	sed -i \
		-e 's:\.\./\.\./media:../media:g' \
		$(grep -rl '\.\./\.\./media' examples) \
		|| die 'sed failed'
	sed "/VERSION_RELEASE/s/-SVN//" -i source/Irrlicht/Makefile || die 'sed failed'
}

src_compile() {
	cd source/Irrlicht
	tc-export CXX CC AR
	emake sharedlib staticlib || die "emake failed"
}

src_install() {
	dolib.a lib/Linux/libIrrlicht.a || die
	dolib.so lib/Linux/libIrrlicht.so* || die
	insinto /usr/include/${PN}
	doins include/* || die
	dodoc changes.txt readme.txt
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins -r examples media || die
	fi
}
