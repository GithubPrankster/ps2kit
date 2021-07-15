#The PS2kit Build Script
#by Uneven Prankster 2021
#feat. a noticeable lack of error checks
mkdir -p build && cd build

export GCC_VER=11.1.0
export BINU_VER=2.36.1
export PS2_TARGET=mips64r5900el-ps2-elf

# GCC's main folder separates subfolders for each version unlike binutils
# An interesting tradeoff going on.

echo "Downloading GCC ${GCC_VER} from GNU land."
wget -c https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.gz || { echo "Could not download GCC."; exit 1; }
echo "Downloading Binutils ${BINU_VER} from GNU land."
wget -c https://ftp.gnu.org/gnu/binutils/binutils-${BINU_VER}.tar.gz || { echo "Could not download Binutils."; exit 1; }

echo "Decompressing GCC and Binutils tarballs!"
echo "First, GCC, because its big as heck."
gzip -c gcc-${GCC_VER}.tar.gz | tar -xf - || { echo "Could not decompress GCC."; exit 1; }
echo "Now, Binutils, which ironically is the most important anyways."
gzip -c binutils-${BINU_VER}.tar.gz | tar -xf - || { echo "Could not decompress Binutils."; exit 1; }

echo "Heading to configure and build Binutils!"
mkdir -p binutils-build && cd binutils-build
../binutils-${BINU_VER}/configure --prefix=${PS2KIT} \
--target=${PS2_TARGET} --with-fpu=single --with-float=hard --disable-nls

echo "Now building Binutils for PS2!"
make -j || { echo "Could not build Binutils."; exit 1; }
make install-strip -j || { echo "Could not install Binutils."; exit 1; }
echo "Should be installed now! Remember to have the binary folder on your PATH."

${PS2_TARGET}-as --version || { echo "You didn't listen to me, did you."; exit 1; }

# Oh god.
echo "Heading to.. build GCC."
cd .. 
mkdir -p gcc-build && cd gcc-build
../gcc-${GCC_VER}/configure --prefix=${PS2KIT} \
--target=${PS2_TARGET} --disable-nls --disable-libada --disable-libssp \
--disable-libstdc++-v3 --disable-libquadmath --enable-languages=c \
--with-gnu-as --with-gnu-ld

echo "...Building GCC for PS2!"
make -j || { echo "Could not build GCC."; exit 1; }
make install-strip -j || { echo "Could not install GCC."; exit 1; }

${PS2_TARGET}-gcc --version || { echo "Still didn't listen to me, did you."; exit 1; }

echo "Sheesh, things should be done by now."
echo "You can get rid of that build stuff if you want to!"
cd ../..
