# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="creates bindings for lua on c++"
HOMEPAGE="http://www.rasterbar.com/products/luabind.html"
SRC_URI="mirror://sourceforge/luabind/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

#there is no way to find out which bjam is installed, so i use 1.42 for now, ugly hack
#also doc is missing

DEPEND="dev-lang/lua"
RDEPEND="
	dev-util/boost-build:1.42.0
	${DEPEND}"

src_compile() {
	bjam-1_42 debug --prefix="${D}/usr/" link=shared toolset=gcc || die "compile failed"
}

src_install() {
	bjam-1_42 debug --prefix="${D}/usr/" link=shared toolset=gcc install || die "install failed"
}
