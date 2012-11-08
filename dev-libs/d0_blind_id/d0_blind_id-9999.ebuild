# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools git-2

DESCRIPTION="Blind-ID library for user identification using RSA blind signatures"
HOMEPAGE="http://git.xonotic.org/?p=xonotic/d0_blind_id.git;a=summary"
EGIT_REPO_URI="git://git.xonotic.org/xonotic/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="crypt openssl static-libs tommath"
REQUIRED_USE="openssl? ( !tommath )"

RDEPEND="
	openssl? ( !tommath? ( dev-libs/gmp ) )
	openssl? ( dev-libs/openssl )
	tommath? ( dev-libs/libtommath )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
DOCS=( d0_blind_id.txt )

pkg_setup() {
	use crypt || ewarn "You will have no encryption, only authentication."
	use openssl && ewarn "OpenSSL is for Mac OS X users only, GMP is faster."
	use tommath && ewarn "You enabled libtommath, GMP is faster."
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable crypt rijndael) \
		$(use_with openssl) \
		$(use_with tommath) \
		$(use_enable static-libs static)
}
