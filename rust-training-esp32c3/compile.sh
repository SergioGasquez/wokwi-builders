#!/bin/bash

set -e

cd espressif-trainings/intro/hardware-check
if [ "$(find ${HOME}/build-in -name '*.rs')" ]; then
    cp ${HOME}/build-in/*.rs src
fi

if [ -f ${HOME}/build-in/Cargo.toml ]; then
    cp ${HOME}/build-in/Cargo.toml Cargo.toml
    PROJECT_NAME=$(awk -F= '/name/ {gsub(/^[[:space:]]+|['\''"]|[[:space:]]+$/,"",$2); print $2}' Cargo.toml)
    PROJECT_NAME_UNDERSCORE=${PROJECT_NAME//-/_}
    find . -type f -exec sed -i "s/$PROJECT_NAME/hardware-check/g" {} +
    find . -type f -exec sed -i "s/$PROJECT_NAME_UNDERSCORE/hardware_check/g" {} +
fi

cargo build --offline --release
python3 -m esptool --chip ${WOKWI_MCU} elf2image --flash_size 4MB target/riscv32imc-esp-espidf/release/hardware-check -o ${HOME}/build-out/project.bin
cp target/riscv32imc-esp-espidf/release/hardware-check ${HOME}/build-out/project.elf
