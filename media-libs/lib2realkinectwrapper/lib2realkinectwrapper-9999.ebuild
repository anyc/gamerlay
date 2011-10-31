# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/lib2realkinectwrapper/lib2realkinectwrapper-9999.ebuild,v 1.2 2011/10/31 15:06:53 frostwork Exp $

EAPI=4

inherit cmake-utils eutils git-2

MY_PN="_2RealKinectWrapper"
DESCRIPTION="simplified Microsoft Kinect sensors functions"
HOMEPAGE="http://www.cadet.at/2011/10/03/2realkinectwrapper/"
EGIT_REPO_URI="git://github.com/cadet/${MY_PN}"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE="debug doc examples static-libs"

DEPEND="media-libs/openni
	dev-libs/boost"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cmake.patch
}

