% ADDOPT(1) | Enable extra software packages
% Gabriel Corona
% February 2018

# Name

`addopt` - enable extra software packages

# Options

`addopt` `/opt/foo` `bar`


`/opt/foo`

: path to a software package

`bar`

: package name (looked up in `/opt`)

# Description

Enable extra software packages (installed for exemple in `/opt/foobar/`)
in the current environment.

This makes available in the current environment:

binaries

: via `PATH`


man pages

: via `MANPATH`

info pages

: via `INFOPATH`

libraries

: via `LD_RUN_PATH`, `LIBRARY_PATH`

`pkg-config` definitions

: via `PKG_CONFIG_PATH`

C, C++, Objective-C include files

: via `CPATH`

# Examples

~~~sh
. addopt.sh
addopt llvm-8.0
addopt /opt/nodejs-11.10.0
~~~
