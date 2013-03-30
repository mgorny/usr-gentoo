# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DEPEND="app-misc/path-respect-wrapper"

usr_wrap_begin() {
	if [[ ! -d ${T}/wrap-build ]]; then
		mkdir "${T}"/wrap-build || die
		pushd "${T}"/wrap-build >/dev/null || die

		einfo 'Building path-respect-wrappers ...'
		sh /usr/src/path-respect-wrapper/configure -C || die
	else
		pushd "${T}"/wrap-build >/dev/null || die
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
		cat > app.c <<-EOF
			const char* const real_path = "/usr/bin/${app}";
			const char* const real_name = "/bin/${app}";
		EOF

		einfo "Wrapping /bin/${app}"
		emake
		newbin app ${app}
	done

	usr_wrap_end
}

usr_wrap_sbin() {
	usr_wrap_begin

	local DESTTREE=/

	local app
	for app; do
		cat > app.c <<-EOF
			const char* const real_path = "/usr/sbin/${app}";
			const char* const real_name = "/sbin/${app}";
		EOF

		einfo "Wrapping /sbin/${app}"
		emake
		newsbin app ${app}
	done

	usr_wrap_end
}
