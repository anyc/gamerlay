# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit games check-reqs git

MY_PN="${PN%-data}"
DESCRIPTION="Xonotic data files"
HOMEPAGE="http://www.xonotic.org/"
BASE_URI="git://git.xonotic.org/${MY_PN}/"
EGIT_REPO_URI="${BASE_URI}${MY_PN}.git"
EGIT_PROJECT="${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+client +maps +zip"

RDEPEND=""
DEPEND="
	~games-util/fteqcc-xonotic-9999
	zip? ( app-arch/p7zip )
"

pkg_setup() {
	games_pkg_setup

	if use !client; then
		ewarn "You have disabled client USE flag, only files for server will be installed."
		ewarn "This feature is experimental, if anything goes wrong, contact the maintainer."
		echo
	fi

	ewarn "You need 1,5 Gb diskspace for distfiles."
	if use !client; then
		CHECKREQS_DISK_BUILD="3000"
		CHECKREQS_DISK_USR="320"
	else
		if use zip; then
			CHECKREQS_DISK_BUILD="3850"
			CHECKREQS_DISK_USR="1830"
		else
			CHECKREQS_DISK_BUILD="7020"
			CHECKREQS_DISK_USR="3520"
		fi
	fi
	check_reqs
}

git_pk3_unpack() {
	EGIT_REPO_URI="${BASE_URI}xonotic-${1}.pk3dir.git" \
	EGIT_PROJECT="${MY_PN}-${1}.pk3dir" \
	S="${S}/data/${MY_PN}-${1}.pk3dir" \
	EGIT_BRANCH="master" \
	git_fetch
}

src_unpack() {
	# root
	git_src_unpack

	# Data
	git_pk3_unpack data
	git_pk3_unpack maps
	# needed only for client
	if use client; then
		git_pk3_unpack music
		git_pk3_unpack nexcompat
	else
		rm -rf "${S}"/data/font-*.pk3dir || die "rm failed"
	fi
	if use maps; then
		cd "${S}/data"
		wget \
			-r -l1 --no-parent --no-directories \
			-A "*-full.pk3" \
			"http://beta.xonotic.org/autobuild-bsp/latest"
	fi
}

src_prepare() {
	# Data
	if use !client; then
		pushd data
		rm -rf \
			xonotic-data.pk3dir/gfx \
			xonotic-data.pk3dir/particles \
			xonotic-data.pk3dir/sound/cyberparcour01/rocket.txt \
			xonotic-data.pk3dir/textures \
			xonotic-maps.pk3dir/textures \
			|| die "rm failed"
		rm -f \
			$(find -type f -name '*.jpg') \
			$(find -type f -name '*.png' ! -name 'sky??.png') \
			$(find -type f -name '*.svg') \
			$(find -type f -name '*.tga') \
			$(find -type f -name '*.wav') \
			$(find -type f -name '*.ogg') \
			$(find -type f -name '*.mp3') \
			$(find -type f -name '*.ase') \
			$(find -type f -name '*.map') \
			$(find -type f -name '*.zym') \
			$(find -type f -name '*.obj') \
			$(find -type f -name '*.blend') \
			|| die "rm failed"
		find -type d \
			-exec rmdir '{}' &>/dev/null \;
		sed -i \
			-e '/^qc-recursive:/s/menu.dat//' \
			xonotic-data.pk3dir/Makefile || die "sed failed"
		popd
	fi
}

src_compile() {
	# Data
	pushd data/xonotic-data.pk3dir
	emake \
		FTEQCC="/usr/bin/fteqcc-xonotic" \
		FTEQCCFLAGS_WATERMARK='' \
		|| die "emake data.pk3 failed"
	popd
}

src_install() {
	# Data
	cd data
	rm -rf \
		$(find -name '.git*') \
		$(find -type d -name '.svn') \
		$(find -type d -name 'qcsrc') \
		$(find -type f -name '*.sh') \
		$(find -type f -name '*.pl') \
		$(find -type f -name 'Makefile') \
		|| die "rm failed"

	if use zip; then
		for d in *.pk3dir; do
			pushd "${d}"
			7za a -tzip "../${d%dir}" . || die "zip failed"
			popd
			rm -rf "${d}" || die "rm failed"
		done
	fi

	insinto "${GAMES_DATADIR}/${MY_PN}/data"
	doins -r . || die "doins data failed"

	prepgamesdirs
}
