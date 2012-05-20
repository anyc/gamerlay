# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit cmake-utils eutils games

DESCRIPTION="A realtime strategy game engine"
HOMEPAGE="http://stratagus.sourceforge.net/"
SRC_URI="http://launchpad.net/stratagus/trunk/${PV}/+download/stratagus_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 debug doc mikmod mng theora vorbis"

RDEPEND="x11-libs/libX11
	virtual/opengl
	dev-db/sqlite:3
	>=dev-lang/lua-5
	dev-lua/toluapp
	media-libs/libpng
	media-libs/libsdl[audio,opengl,video]
	bzip2? ( app-arch/bzip2 )
	mikmod? ( media-libs/libmikmod )
	mng? ( media-libs/libmng )
	theora? ( media-libs/libtheora media-libs/libvorbis )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}_${PV}.orig"

src_prepare() {
	sed -i \
		-e '/DESTINATION/s:games\|s\?bin:games/bin:' \
		-e '/DESTINATION/s:share/doc/stratagus:/tmp/doc:' \
		CMakeLists.txt || die 'fixing install paths failed'
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with bzip2)
		$(cmake-utils_use_with debug)
		$(cmake-utils_use_enable doc)
		$(cmake-utils_use_with mikmod)
		$(cmake-utils_use_with mng)
		$(cmake-utils_use_with theora)
		$(cmake-utils_use_with vorbis oggvorbis)

		# install header files
		-DENABLE_DEV=ON

		# XXX: make sqlite (metaserver) optional
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	# thanks to games.eclass we're stuck with EAPI 2
	dodoc "${D}"/tmp/doc/*.txt || die
	rm -f "${D}"/tmp/doc/*.txt || die
	dohtml -r "${D}"/tmp/doc/* || die
	rm -rf "${D}"/tmp || die
}
