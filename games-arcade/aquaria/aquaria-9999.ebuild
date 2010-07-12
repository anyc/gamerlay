# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
EHG_REPO_URI="http://hg.icculus.org/icculus/aquaria"

inherit eutils flag-o-matic games cmake-utils mercurial

DESCRIPTION="A 2D scroller set in a massive ocean world"
HOMEPAGE="http://www.bit-blot.com/aquaria/"
SRC_URI="aquaria-lnx-humble-bundle.mojo.run"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT="fetch"

RDEPEND="dev-lang/lua
	>=dev-libs/tinyxml-2.6
	games-engines/bbge
	media-libs/glpng
	media-libs/libsdl"

DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}"

pkg_nofetch() {
	echo
	elog "Download ${A} from ${HOMEPAGE} and place it in ${DISTDIR}"
	echo
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	local a="${DISTDIR}/${A}"
	echo ">>> Unpacking ${a} to ${PWD}"
	unzip -q "${a}"
	[ $? -gt 1 ] && die "unpacking failed"

	mercurial_src_unpack
}

src_prepare() {
	# Remove bundled stuff to ensure it's not used.
	rm -r Aquaria/lua-* BBGE/ || die

	# Fix BBGE include paths.
	sed -i \
		-e "s:\.\./BBGE/glpng:GL/glpng:" \
		-e "s:\.\./BBGE/tinyxml:tinyxml:" \
		-e "s:\.\./BBGE/:BBGE/:" \
		Aquaria/*.{cpp,h} || die

	sed -i \
		-e "/TARGET_LINK_LIBRARIES/d" \
		-e "/ADD_EXECUTABLE[(]/,/[)]/d" \
		CMakeLists.txt || die

	echo 'ADD_EXECUTABLE(aquaria ${AQUARIA_SRCS})' >> CMakeLists.txt || die
	echo "TARGET_LINK_LIBRARIES(aquaria BBGE glpng lua pthread SDL tinyxml)" >> CMakeLists.txt || die
}

src_configure() {
	append-cppflags -I/usr/include/BBGE -I/usr/include/freetype2
	cmake-utils_src_configure
}

src_install() {
	dogamesbin "${CMAKE_BUILD_DIR}/${PN}" || die

	cd ../data || die
	local dir="${GAMES_DATADIR}/Aquaria"

	insinto "${dir}"
	doins -r *.xml */ || die

	dodoc README-linux.txt || die
	mv "${D}/${dir}"/docs "${D}/usr/share/doc/${PF}/html" || die
	dosym /usr/share/doc/${PF}/html "${dir}"/docs || die

	doicon "${PN}.png" || die
	make_desktop_entry "${PN}" "Aquaria" || die

	prepgamesdirs
}

pkg_postinst() {
	elog
	elog "If you are using a joystick with rumble capability, and wish to use it"
	elog "export the variable AQUARIA_EVENT_JOYSTICK0 defined as the path to the"
	elog "device. Example: export AQUARIA_EVENT_JOYSTICK0=/dev/input/event6"
	elog
}