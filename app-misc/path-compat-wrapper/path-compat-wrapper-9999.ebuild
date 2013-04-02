# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="http://bitbucket.org/mgorny/${PN}.git"

inherit git-2
#endif

inherit autotools-utils

DESCRIPTION="Wrapper complaining when programs are run via compatibility paths"
HOMEPAGE="https://bitbucket.org/mgorny/path-compat-wrapper"
SRC_URI="mirror://bitbucket/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

RDEPEND="systemd? ( sys-apps/systemd )"
DEPEND=${RDEPEND}

#if LIVE
SRC_URI=
KEYWORDS=
#endif

src_configure() {
	local myeconfargs=(
		$(use_enable systemd systemd-journal)
	)

	autotools-utils_src_configure
}
