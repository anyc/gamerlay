# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=5

inherit mercurial versionator

MY_PV=${PV/_pre/-}
EHG_REVISION=$(get_version_component_range 4 ${MY_PV})

DESCRIPTION="TrueType font decoding add-on for SDL"
HOMEPAGE="http://www.libsdl.org/projects/SDL_ttf"
EHG_REPO_URI="http://hg.libsdl.org/SDL_ttf"

LICENSE="ZLIB"
SLOT="2"
KEYWORDS="~amd64 ~x86"

#FIXME: Add "test".
IUSE="showfont static-libs X"

RDEPEND="
	media-libs/libsdl:2
	>=media-libs/freetype-2.3
	X? ( x11-libs/libXt )
"
DEPEND="${RDEPEND}"

src_configure() {
	MISSING=true econf \
		$(use_enable static-libs static) \
		$(use_with X x)
}

src_install() {
	emake DESTDIR="${D}" install
	use static-libs || prune_libtool_files --all
	use showfont && newbin '.libs/showfont' "showfont2"
	dodoc {CHANGES,README}.txt
}
