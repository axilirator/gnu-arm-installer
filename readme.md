GNU ARM TOOLCHAIN INSTALLER
===========================
<h5 align="right">FOR OSMOCOM-BB</h5>

This latest version works with: 

 * gcc-4.5.2.tar.bz2
 * binutils-2.21.1a.tar.bz2
 * newlib-1.19.0.tar.gz

This version of the installer was tested with Ubuntu. Debian should work also. But there is at one point in the download.sh script an aptitude command. You can just ignore this with other systems, but nevertheless, you need to install this library.

<h3>Installation</h3>
Make sure that you already have installed following packages: <i>build-essential libgmp3-dev libmpfr-dev libx11-6 libx11-dev flex bison libncurses5 libncurses5-dbg libncurses5-dev libncursesw5 libncursesw5-dbg libncursesw5-dev zlibc zlib1g-dev libmpfr4 libmpc-dev</i>.

1. Download the latest installer:
	```bash
	git clone https://github.com/axilirator/gnu-arm-installer.git
	cd gnu-arm-installer
	```

2. Run this scripts:
	```bash
	./download.sh
	./build.sh
	```

The installer will extract and compile all of the source files automatically. If it is successful, you will get the toolchain in install/ directory.

License: 
GPL v3 (http://www.gnu.org/copyleft/gpl.html)

This script was originally written by Waipot Ngamsaad from mcuprogramming.com:
svn checkout http://hobbycode.googlecode.com/svn/trunk/gnu-arm-installer gnu-arm-installer

Patch written by Marcello Pogliani <pogliamarci@hotmail.it>.