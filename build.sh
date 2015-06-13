#!/bin/sh

ROOT=`pwd`
SRCDIR=$ROOT/src
BUILDDIR=$ROOT/build
PREFIX=$ROOT/install

GCC_SRC=gcc-4.5.2.tar.bz2
GCC_VERSION=4.5.2
GCC_DIR=gcc-$GCC_VERSION

BINUTILS_SRC=binutils-2.21.1a.tar.bz2
BINUTILS_VERSION=2.21.1
BINUTILS_DIR=binutils-$BINUTILS_VERSION

NEWLIB_SRC=newlib-1.19.0.tar.gz
NEWLIB_VERSION=1.19.0
NEWLIB_DIR=newlib-$NEWLIB_VERSION

TEXINFO_SRC=texinfo-4.13a.tar.gz
TEXINFO_VERSION=4.13a
TEXINFO_DIR=texinfo-$TEXINFO_VERSION

echo "I will build an arm-elf cross-compiler:

  Prefix: $PREFIX
  Sources: $SRCDIR
  Build files: $BUILDDIR

Press ^C now if you do NOT want to do this."
read IGNORE

#
# Helper functions.
#
unpack_source()
{
(
    cd $SRCDIR
    ARCHIVE_SUFFIX=${1##*.}
    if [ "$ARCHIVE_SUFFIX" = "gz" ]; then
      tar zxvf $1
    elif [ "$ARCHIVE_SUFFIX" = "bz2" ]; then
      tar jxvf $1
    else
      echo "Unknown archive format for $1"
      exit 1
    fi
)
}

# Create all the directories we need.
#mkdir -p $SRCDIR $BUILDDIR $PREFIX

(
cd $SRCDIR

# Unpack the sources.
unpack_source $(basename $GCC_SRC)
unpack_source $(basename $BINUTILS_SRC)
unpack_source $(basename $NEWLIB_SRC)
unpack_source $(basename $TEXINFO_SRC)
)

# Set the PATH to include the binaries we're going to build.
OLD_PATH=$PATH
export PATH=$PREFIX/bin:$PATH

#
# Stage 0: Texinfo downgrade
#
(
  (
    # Entering the directory...
    cd $SRCDIR/$BINUTILS_DIR
  ) || exit 1

  (
    # Configuring...
    ./configure
  ) || exit 1

  (
    # Building...
    make all && make install
  ) || exit 1
)

#
# Stage 1: Build binutils
#
(
(
# autoconf check.
cd $SRCDIR/$BINUTILS_DIR

) || exit 1

# Now, build it.
mkdir -p $BUILDDIR/$BINUTILS_DIR
cd $BUILDDIR/$BINUTILS_DIR

$SRCDIR/$BINUTILS_DIR/configure --target=arm-elf --prefix=$PREFIX \
    --enable-interwork --enable-threads=posix --enable-multilib --with-float=soft --disable-werror \
    && make all install

) || exit 1

#
# Stage 2: Patch the GCC multilib rules, then build the gcc compiler only
#
(
MULTILIB_CONFIG=$SRCDIR/$GCC_DIR/gcc/config/arm/t-arm-elf

echo "

MULTILIB_OPTIONS += mno-thumb-interwork/mthumb-interwork
MULTILIB_DIRNAMES += normal interwork

" >> $MULTILIB_CONFIG

mkdir -p $BUILDDIR/$GCC_DIR
cd $BUILDDIR/$GCC_DIR

$SRCDIR/$GCC_DIR/configure --target=arm-elf --prefix=$PREFIX \
    --enable-interwork --enable-multilib --with-float=soft --disable-werror \
    --enable-languages="c,c++" --with-newlib \
    --with-headers=$SRCDIR/$NEWLIB_DIR/newlib/libc/include \
    --with-system-zlib --disable-shared \
    && make all-gcc install-gcc

) || exit 1

#
# Stage 3: Build and install newlib
#
(
(
# Same issue, we have to patch to support makeinfo >= 4.11.
cd $SRCDIR/$NEWLIB_DIR

) || exit 1

# And now we can build it.
mkdir -p $BUILDDIR/$NEWLIB_DIR
cd $BUILDDIR/$NEWLIB_DIR

$SRCDIR/$NEWLIB_DIR/configure --target=arm-elf --prefix=$PREFIX \
    --enable-interwork --enable-multilib --with-float=soft --disable-werror \
    && make all install

) || exit 1

#
# Stage 4: Build and install the rest of GCC.
#
(
cd $BUILDDIR/$GCC_DIR

make all install

) || exit 1

#
# Stage 5: Build and install INSIGHT.
#
# edit: we currently don't need that for OsmocomBB

#(
# Now, build it.
#mkdir -p $BUILDDIR/$INSIGHT_DIR

#cd $BUILDDIR/$INSIGHT_DIR

#$SRCDIR/$INSIGHT_DIR/configure --target=arm-elf --prefix=$PREFIX \
#    --enable-interwork --enable-multilib --with-float=soft --disable-werror \
#    && make all install

#) || exit 1


export PATH=$OLD_PATH

echo "
Build complete! Add $PREFIX/bin to your PATH to make arm-elf-gcc and friends
accessible directly.
"
