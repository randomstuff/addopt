# Copyright (c) 2013 Gabriel Corona <gabriel.corona@enst-bretagne.fr>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# Prepend path to given variable:
#   VARIABLE  : name of the variable
#   path      : path to prepend
#   default   : default (when the variable is not defined)
#   separator : path separator
_addopt_prepend() {
    if [ $# -le 1 ]; then
	echo "Error in prepend" >&2
	exit 1
    fi

    local VARIABLE="$1";
    local path="$2";
    local default="$3";
    local separator="$4";

    # Default separator:
    if [ $# -le 3 ]; then
        separator=":";
    fi

    # Default value:
    echo "$VARIABLE+=$path" >&2
    if [ -z $(eval echo \$$VARIABLE) ]; then
	if [ -z "$default" ]; then
	    eval "export $VARIABLE=\$path"
	    return
	fi
	eval "export \$VARIABLE=$default";
    fi

    # Prepend path:
    eval "export $VARIABLE=$path$separator\$$VARIABLE";
}

# Prepend some path if it exists
#   VARIABLE  : name of the variable
#   path      : path to prepend
#   default   : default (when the variable is not defined)
#   separator : path separator
_addopt_check() {
    if [ -e "$2" ]; then
	_addopt_prepend "$@"
    fi
}

# Update environment variables for a given path
#   path : path
_addopt_handle() {

    # Runtime

    _addopt_check LD_RUN_PATH "$1/lib"

    for p in "$1/games" "$1/bin" "$1/sbin"; do
	_addopt_check PATH "$p"
    done

    # Doc

    if which manpath > /dev/null ; then
	_addopt_check MANPATH "$1/share/man" `manpath`
    fi

    for p in "$1/share/info" "$1/info"; do
	_addopt_check INFOPATH "$p"
    done

    # Compilation

    _addopt_check LD_LIBRARY_PATH "$1/lib"

    # pkg-config
    for p in "$1/share/pkconfig" "$1/lib/pkgconfig"; do
    	_addopt_check PKG_CONFIG_PATH "$p"
    done

    _addopt_check CPATH "$1/include"

}

addopt() {
    while [ $# -gt 0 ]; do
	case "$1" in
	    --help)
		;;
	    /* | ./* | ../* )
                _addopt_handle "$(readlink -m "$1")"
		;;
	    *)
		_addopt_handle "/opt/$1"
		;;
	esac
	shift
    done
}
