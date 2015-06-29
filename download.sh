sudo apt-get install libmpfr-dev texinfo
mkdir src/ install/ build/
rm src/*

wget http://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2 -O src/gcc-4.8.2.tar.bz2
wget http://ftp.gnu.org/gnu/binutils/binutils-2.21.1a.tar.bz2 -O src/binutils-2.21.1a.tar.bz2
wget ftp://sources.redhat.com/pub/newlib/newlib-1.19.0.tar.gz -O src/newlib-1.19.0.tar.gz