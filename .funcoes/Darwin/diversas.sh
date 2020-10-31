#!/bin/bash
# Autor: Paulo Jerônimo (pj@paulojeronimo, @paulojeronimo)
#
# Funções diversas e específicas ao ambiente ao ambiente do OS X

# show/hidde files on OS X
showHiddenFiles() {
   local op=`echo -n ${1:-true} | tr '[:lower:]' '[:upper:]'`

   case $op in
      TRUE|FALSE);;
      *)
         echo 'Informe "true" ou "false"!'
         return 1
   esac

   defaults write com.apple.finder AppleShowAllFiles $op
   killall Finder
}

# prevent .DS_Store file creation over the network connections
# Refs: 
#   http://support.apple.com/kb/ht1629
#   http://osxdaily.com/2010/02/03/how-to-prevent-ds_store-file-creation/
# Related:
#   http://www.aorensoftware.com/blog/2011/12/24/death-to-ds_store/
disableDotDS_Store() {
   local op=`echo -n ${1:-true} | tr '[:lower:]' '[:upper:]'`
   
   case $op in
      TRUE|FALSE);;
      *)
         echo 'Informe "true" ou "false"!'
         return 1
   esac

   defaults write com.apple.desktopservices DSDontWriteNetworkStores $op
}

brew_install() {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

jdk() {
	! [ $# = 0 ] || {
		cat - <<-EOF
		Usage: `basename $0` [1.8|11|15]
		EOF
		return
	}

	case "$1" in
		"1.8"|11|15) v=$1;;
		*) echo "Invalid jdk version!"; return 1;;
	esac
	export JAVA_HOME=$(/usr/libexec/java_home -v $1)
}
