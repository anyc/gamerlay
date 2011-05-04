# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

DESCRIPTION="A port of Jagged Alliance 2 to SDL."
HOMEPAGE="http://tron.homeunix.org/ja2/"
SRC_URI="http://ftp.gentoo.ru/people/winterheart/distfiles/ja2-${PV}-source.tar.bz2
	editor? ( http://tron.homeunix.org/ja2/editor.slf.gz )"

LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug editor linguas_nl linguas_en linguas_fr linguas_de linguas_it linguas_pl
linguas_ru linguas_ru_gold zlib"

RDEPEND="media-libs/libsdl
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/ja2-${PV}-source"

src_prepare() {

	myconf=""
	for i in ${LINGUAS}; do
		ewarn "${i} is chosen for primary language"
		case ${i} in
		de) myconf="LNG=GERMAN" ;;
		nl) myconf="LNG=DUTCH" ;;
		fr) myconf="LNG=FRENCH" ;;
		it) myconf="LNG=ITALIAN" ;;
		pl) myconf="LNG=POLISH" ;;
		ru) myconf="LNG=RUSSIAN" ;;
		ru_gold) myconf="LNG=RUSSIAN_GOLD" ;;
		*) myconf="LNG=ENGLISH" ;;
		esac
		break
	done

	sed -i \
		-e "s:\(CFLAGS += \$(CFLAGS_SDL)\):\1 ${CFLAGS}:" \
		-e "s:\(LDFLAGS += \$(LDFLAGS_SDL)\):\1 ${LDFLAGS}:" \
		Makefile || die "sed failed"
	sed -ie "s:\(Icon=jagged2\).ico:\1:" ${PN}.desktop || die "sed failed"

	sed -ie "s:/some/place/where/the/data/is:${GAMES_DATADIR}/ja2:" \
		sgp/FileMan.cc || die "sed failed"

	use editor && myconf="${myconf} JA2EDITOR=yes JA2BETAVERSION=yes"
	use zlib && myconf="${myconf} WITH_ZLIB=yes"
}

src_compile() {
	emake ${myconf} || die
}

src_install() {
	dogamesbin ja2 || die
	doman ja2.6
	doicon "${FILESDIR}"/jagged2.png
	insinto /usr/share/applications
	doins ${PN}.desktop

	if use editor; then
		insinto "${GAMES_DATADIR}"/ja2/data
		doins "${WORKDIR}"/editor.slf
	fi

	prepgamesdirs
}

pkg_postinst() {
	einfo
	elog "Copy all files from Data directory of Jagged Alliance 2 installation to"
	elog "${GAMES_DATADIR}/ja2/data and then run"
	elog
	elog "# emerge --config \"=${CATEGORY}/${PF}\""
	elog
	einfo
}

pkg_config() {
	einfo
	einfo "Convert names of data-files to lower-case"
	einfo
	for i in \
		"${GAMES_DATADIR}"/ja2/data/*.[Ss][Ll][Ff] \
		"${GAMES_DATADIR}"/ja2/data/[Tt][Ii][Ll][Ee][Cc][Aa][Cc][Hh][Ee]/*.[Jj][Ss][Dd] \
		"${GAMES_DATADIR}"/ja2/data/[Tt][Ii][Ll][Ee][Cc][Aa][Cc][Hh][Ee]/*.[Ss][Tt][Ii]; \
	do
		einfo "$i"
		lower="`echo "$i" | LANG=C tr '[A-Z]' '[a-z]'`"
		[ -d `dirname "$lower"` ] || mkdir `dirname $lower`
		[ "$i" = "$lower" ] || mv "$i" "$lower"
	done
}
