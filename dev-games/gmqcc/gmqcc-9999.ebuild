# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=5

EGIT_REPO_URI="git://github.com/graphitemaster/gmqcc.git"
EGIT_BRANCH="master"

inherit git-2

DESCRIPTION="An Improved Quake C Compiler"
HOMEPAGE="http://graphitemaster.github.com/gmqcc/"
LICENSE="MIT"

SLOT="0"
IUSE=""
KEYWORDS=""

src_prepare() {
	sed -i -e "s:-Werror ::" Makefile || die
}

src_install() {
	emake install PREFIX="${D}/usr"
	dodoc README
}
