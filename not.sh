#!/bin/bash
LN_PATH="/usr/bin"

KERNEL_NAME="not_kernel-zero-"

KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc"

KERNEL_BUILD_ENV="ARCH=arm64 \
                  CROSS_COMPILE="$LN_PATH/aarch64-linux-gnu-" \
                  PATH=$LN_PATH:$PATH"

IMAGE="/home/skye/bomb/out2/arch/arm64/boot/Image"
OUT_DIR="/home/skye/bomb/out2"
ANYKERNEL_DIR="/home/skye/bomb/AnyKernel3/zero"

echo "*****************************************"
echo "*****************************************"

rm -rf "$OUT_DIR/arch/arm64/boot/Image"
rm -rf .version .local
make O="$OUT_DIR" $KERNEL_BUILD_ENV exynos7420-zerolte_defconfig

echo "*****************************************"
echo "*****************************************"

# Build Kernel Image

make -j12 O="$OUT_DIR" $KERNEL_MAKE_ENV $KERNEL_BUILD_ENV \
     CC="$LN_PATH/aarch64-linux-gnu-gcc" Image

echo "**Build outputs**"
ls "$OUT_DIR/arch/arm64/boot"
echo "**Build outputs**"

cp "$IMAGE" "$ANYKERNEL_DIR/Image"

# Package Kernel

cd "$ANYKERNEL_DIR" || exit 1
rm -f *.zip

zip -r9 "${KERNEL_NAME}$(date +"%Y%m%d")+zerolte.zip" .

echo "The bomb has been planted."

