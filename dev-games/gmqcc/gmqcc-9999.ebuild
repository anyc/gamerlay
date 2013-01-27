# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EGIT_REPO_URI="git://github.com/graphitemaster/gmqcc.git"
EGIT_BRANCH="master"

inherit git-2

DESCRIPTION="An Improved Quake C Compiler"
HOMEPAGE="http://graphitemaster.github.com/gmqcc/"
LICENSE="as-is"

SLOT="0"
IUSE=""
KEYWORDS="~amd64"

src_install() {
    emake install PREFIX="${D}/usr" || die
}
