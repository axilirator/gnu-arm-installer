sudo apt-get install libmpfr-dev
mkdir src/ install/ build/
rm src/*

wget http://ftp.gnu.org/gnu/gcc/gcc-4.5.2/gcc-4.5.2.tar.bz2 -O src/gcc-4.5.2.tar.bz2
wget http://ftp.gnu.org/gnu/binutils/binutils-2.21.1a.tar.bz2 -O src/binutils-2.21.1a.tar.bz2
wget ftp://sources.redhat.com/pub/newlib/newlib-1.19.0.tar.gz -O src/newlib-1.19.0.tar.gz

# You need downgrade your texinfo for successful compilation
wget http://ftp.gnu.org/gnu/texinfo/texinfo-4.13a.tar.gz -O src/texinfo-4.13a.tar.gz
