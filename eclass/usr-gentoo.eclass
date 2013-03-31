# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DEPEND="app-misc/path-respect-wrapper"

usr_wrap_begin() {
	if [[ ! -d ${T}/usr-wrap-build ]]; then
		mkdir "${T}"/usr-wrap-build || die
		pushd "${T}"/usr-wrap-build >/dev/null || die

		einfo 'Building path-respect-wrappers ...'
		echo 'LDLIBS = -lpath-respect-wrapper' > Makefile || die
	else
		pushd "${T}"/usr-wrap-build >/dev/null || die
	fi
}

usr_wrap_end() {
	popd >/dev/null || die
}

usr_wrap_bin() {
	usr_wrap_begin

	local DESTTREE=/

	local app
	for app; do
		cat > ${app}.c <<-EOF || die
			const char* const real_path = "/usr/bin/${app}";
			const char* const real_name = "/bin/${app}";
		EOF

		echo "all: ${app}" >> Makefile || die
	done

	emake CC="$(tc-getCC)" || die
	dobin "${@}" || die

	usr_wrap_end
}

usr_wrap_sbin() {
	usr_wrap_begin

	local DESTTREE=/

	local app
	for app; do
		cat > ${app}.c <<-EOF || die
			const char* const real_path = "/usr/sbin/${app}";
			const char* const real_name = "/sbin/${app}";
		EOF

		echo "all: ${app}" >> Makefile || die
	done

	emake CC="$(tc-getCC)" || die
	dosbin "${@}" || die

	usr_wrap_end
}

# wrap all /usr/bin/* and /usr/sbin/*
usr_wrap_all() {
	if [[ -d ${ED}/usr/bin ]]; then
		pushd "${ED}"/usr/bin >/dev/null || die
		usr_wrap_bin *
		popd >/dev/null || die
	fi

	if [[ -d ${ED}/usr/sbin ]]; then
		pushd "${ED}"/usr/sbin >/dev/null || die
		usr_wrap_sbin *
		popd >/dev/null || die
	fi
}

# in case build system was broken and unoverridable
usr_move_all() {
	local f
	if [[ -d ${ED}/bin ]]; then
		pushd "${ED}"/bin >/dev/null || die
		f=( * )
		dodir /usr/bin
		mv "${f[@]}" "${ED}"/usr/bin || die
		usr_wrap_bin "${f[@]}"
		popd >/dev/null || die
	fi

	if [[ -d ${ED}/sbin ]]; then
		pushd "${ED}"/sbin >/dev/null || die
		f=( * )
		dodir /usr/sbin
		mv "${f[@]}" "${ED}"/usr/sbin || die
		usr_wrap_sbin "${f[@]}"
		popd >/dev/null || die
	fi
}
