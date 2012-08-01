# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsfml/libsfml-9999.ebuild,v 1.2 2011/09/09 07:52:53 frostwork Exp $

EAPI=4

inherit cmake-utils eutils git-2 multilib

MY_P="SFML-${PV}"
DESCRIPTION="Simple and Fast Multimedia Library (SFML)"
HOMEPAGE="http://sfml.sourceforge.net/"
EGIT_REPO_URI="git://github.com/LaurentGomila/SFML.git"
#SRC_URI="mirror://sourceforge/sfml/${MY_P}-sdk-linux-32.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/freetype:2
	media-libs/glew
	media-libs/libpng
	media-libs/libsndfile
	media-libs/mesa
	media-libs/openal
	sys-libs/zlib
	virtual/jpeg
	x11-libs/libX11
	x11-libs/libXrandr"
RDEPEND="${DEPEND}"
