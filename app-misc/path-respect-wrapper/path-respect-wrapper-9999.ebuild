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

DESCRIPTION="Wrapper for apps moved to /usr, checking whether PATH is respected"
HOMEPAGE="https://bitbucket.org/mgorny/path-respect-wrapper"
SRC_URI="mirror://bitbucket/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-process/procps"
DEPEND=${RDEPEND}

#if LIVE
SRC_URI=
KEYWORDS=
#endif
