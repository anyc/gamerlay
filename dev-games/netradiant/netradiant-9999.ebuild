# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

ESVN_DISABLE_DEPENDENCIES="true"
ESVN_OPTIONS="--trust-server-cert --non-interactive"

inherit eutils multilib toolchain-funcs subversion git

RADIANT_MAJOR_VERSION="5"
RADIANT_MINOR_VERSION="0"
DESCRIPTION="NetRadiant is a fork of map editor for Q3 based games, GtkRadiant 1.5"
HOMEPAGE="http://dev.alientrap.org/projects/netradiant"
EGIT_REPO_URI="git://git.xonotic.org/xonotic/netradiant.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
RADIANT_PACKS="darkplaces nexuiz q2w warsow +xonotic"
IUSE="${RADIANT_PACKS}"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	>=media-libs/libpng-1.2
	>=sys-libs/zlib-1.2
	>=x11-libs/gtk+-2.4:2
	>=x11-libs/gtkglext-1
	x11-libs/pango
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	darkplaces? ( ${SUBVERSION_DEPEND} )
	q2w? ( ${SUBVERSION_DEPEND} )
	warsow? ( ${SUBVERSION_DEPEND} )
	xonotic? ( net-misc/wget )
"

radiant_svn_unpack() {
	if use ${1}; then
		cd "${WORKDIR}/packs/" || die
		ESVN_REPO_URI="${2}" \
		ESVN_PROJECT="${PN}-${1}" \
		S="${WORKDIR}/packs/${1}" \
		subversion_fetch
	fi
}

src_unpack() {
	git_src_unpack

	mkdir "${WORKDIR}/packs/" || die

	radiant_svn_unpack darkplaces \
		"https://zerowing.idsoftware.com/svn/radiant.gamepacks/DarkPlacesPack/branches/1.5/"
	radiant_svn_unpack q2w \
		"svn://jdolan.dyndns.org/quake2world/trunk/gtkradiant"
	radiant_svn_unpack warsow \
		"https://svn.bountysource.com/wswpack/trunk/netradiant/games/WarsowPack/"

	if use nexuiz; then
		cd "${WORKDIR}/packs/" || die
		git archive \
			--remote="git://git.icculus.org/divverent/nexuiz.git" \
			--prefix="nexuiz/" \
			master:misc/netradiant-NexuizPack \
			| tar xvf - 2>/dev/null || die
	fi

	if use xonotic; then
		EGIT_REPO_URI="git://git.xonotic.org/xonotic/netradiant-xonoticpack.git" \
		EGIT_BRANCH="master" \
		EGIT_PROJECT="${PN}-xonotic" \
		S="${WORKDIR}/packs/xonotic" \
		git_fetch

		cd "${WORKDIR}/packs/xonotic" || die
		while IFS="	" read -r FILE URL; do
			/usr/bin/wget -t 3 -T 60 -O "$FILE" "$URL" || die
		done < "extra-urls.txt"
	fi
}

src_configure() {
	tc-export CC CXX AR RANLIB

	export TEE_STDERR=""

	emake dependencies-check || die
}

src_compile() {
	emake binaries || die
}

src_install() {
	echo "$RADIANT_MINOR_VERSION" > RADIANT_MINOR || die
	echo "$RADIANT_MAJOR_VERSION" > RADIANT_MAJOR || die
	insinto /usr/$(get_libdir)/${PN}
	doins -r \
		RADIANT_MAJOR \
		RADIANT_MINOR \
		setup/data/tools/* \
		docs \
		|| die

	dodoc ChangeLog ChangeLog.idsoftware CONTRIBUTORS TODO tools/quake3/q3map2/changelog.q3map{1,2.txt}

	cd install || die

	# tools
	exeinto /usr/$(get_libdir)/${PN}
	for i in q3map2 q3data qdata3 q2map; do
		doexe ${i}.x86 || die
		dosym /usr/$(get_libdir)/${PN}/${i}.x86 /usr/bin/${i} || die
	done
	exeinto /usr/$(get_libdir)/${PN}/heretic2
	doexe heretic2/h2data.x86 || die
	dosym /usr/$(get_libdir)/${PN}/heretic2/h2data.x86 /usr/bin/h2data || die

	# radiant
	exeinto /usr/$(get_libdir)/${PN}
	doexe radiant.x86 || die
	dosym /usr/$(get_libdir)/${PN}/radiant.x86 /usr/bin/${PN} || die

	newicon "${S}"/icons/radiant-src.png ${PN}.png || die
	make_desktop_entry ${PN} NetRadiant ${PN} "Development;GTK;"

	# radiant modules
	insinto /usr/$(get_libdir)/${PN}/modules
	doins modules/*.so || die

	# radiant plugins
	insinto /usr/$(get_libdir)/${PN}/plugins
	doins plugins/*.so || die

	# packs
	for x in ${RADIANT_PACKS//+/}; do
		if use $x; then
			cd "${WORKDIR}"/packs/${x} || die
			insinto /usr/$(get_libdir)/${PN}
			doins -r ${x}.game || die

			insinto /usr/$(get_libdir)/${PN}/games
			doins games/${x}.game || die
		fi
	done
}

pkg_preinst() {
	# subversion_pkg_preinst seems broken
	true
}
