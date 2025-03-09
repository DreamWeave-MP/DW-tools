#!/usr/bin/env bash
set -euo pipefail

_linux=momw-tools-pack-linux
_macos=momw-tools-pack-macos
_windows=momw-tools-pack-windows

umo_version=0.8.16
configurator_version=1.18
tes3cmd_version=0.40-PRE-RELEASE-2
delta_version=0.22.1
lightfixes_version=0.3.0
groundcoverify_version=0.2.2
validator_version=1.14

function get_umo() {
    # linux
    curl -sL -o umo-linux.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/179592837/download
    echo "6b261979ad02b2bcc27e2da4001a16eeaec431355385c2c5b76bcb2b4b9f30bfad03f71d5ef98aa4d662d96a46fcc2cbb7d182cf8388d18c20b3a65da6a4a31f  umo-linux.tar.gz" | sha512sum -c
    tar xf umo-linux.tar.gz
    mv umo/umo ${_linux}/

    # macos universal2
    curl -sL -o umo-macos.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/179592845/download
    echo "f919035946282fe310f9037a2230a8864a7356ea451f9130ee8cf162db50db52c64918c3495e18b8804702fd98eaa96837301603b128782d8054316d2fcd3712  umo-macos.tar.gz" | sha512sum -c
    tar xf umo-macos.tar.gz
    mv umo/umo* ${_macos}/

    # windows
    curl -sL -o umo-windows.zip https://gitlab.com/modding-openmw/umo/-/package_files/179592863/download
    echo "fa141ec2d6a158f878f2afa1e6284937f653f7325fee41c37ca4091c7366208b68151c2b8165ee5f3f667218debb5ebf251f32b2417f4da7ff94c58fff4d5cbc  umo-windows.zip" | sha512sum -c
    # We have to catch this error since unzip complains about the folder separators and it causes a nonzero exit
    cd ${_windows}/
    unzip -oqq ../umo-windows.zip || printf "" #TODO: use 7z
    cd -

    curl -sL -o README-umo.org https://gitlab.com/modding-openmw/umo/-/raw/master/README.org
    cp README-umo.org ${_linux}/Readmes/
    cp README-umo.org ${_macos}/Readmes/
    cp README-umo.org ${_windows}/Readmes/
}

function get_configurator() {
    curl -sL -o configurator.zip https://gitlab.com/modding-openmw/momw-configurator/-/package_files/179588151/download
    echo "d6de654b658a5aeee8a20dfd01ee03cc65af5c76d36bf988eaa7f091fa128d1a9239ed8e5d1d3953abd5b91f03f1c5b8673cc232571ac28520c31bd03202f472  configurator.zip" | sha512sum -c
    unzip -qq configurator.zip
    mv momw-configurator/momw-configurator-linux* ${_linux}/
    mv momw-configurator/momw-configurator-macos* ${_macos}/
    mv momw-configurator/momw-configurator.exe ${_windows}/
    cp momw-configurator/README.org ${_linux}/Readmes/README-MOMW-Configurator.org
    cp momw-configurator/README.org ${_macos}/Readmes/README-MOMW-Configurator.org
    cp momw-configurator/README.org ${_windows}/Readmes/README-MOMW-Configurator.org
}

function get_tes3cmd() {
    # linux
    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Ftes3cmd/jobs/artifacts/master/raw/tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64.tar.gz?job=build_linux"
    echo "f07ff02343b8dbf3b3ed3791bfdced30fa4edcffde9d682d1ec062d454d5a489c36097bff41147b578042848dd3e512af52414d568de71b0eb5fad01f78570b1  tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64.tar.gz" | sha512sum -c
    tar xvf tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64.tar.gz
    mv tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64 ${_linux}/tes3cmd
    mv Docs ${_linux}/Readmes/Docs-TES3CMD
    mv Readme.txt ${_linux}/Readmes/Readme-TES3CMD.txt

    # windows
    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Ftes3cmd/jobs/artifacts/master/raw/tes3cmd.0.40-PRE-RELEASE-2-win.zip?job=build_win"
    echo "06fdb7620a00d7402985495901a52ae50228e8e75d314740573c1b3dc3e4daa2ce3b69b04f34862857f880ddd11d42d5363a41bf05fa58651f2ce5e0949d6aee  tes3cmd.0.40-PRE-RELEASE-2-win.zip" | sha512sum -c
    # We have to catch this error since unzip complains about the folder separators and it causes a nonzero exit
    unzip -qq tes3cmd.0.40-PRE-RELEASE-2-win.zip || printf ""
    mv tes3cmd.0.40-PRE-RELEASE-2/tes3cmd.0.40-PRE-RELEASE-2.exe ${_windows}/tes3cmd.exe
    cp -r ${_linux}/Readmes/Docs-TES3CMD ${_linux}/Readmes/Readme-TES3CMD.txt ${_windows}/Readmes/

    # macos
    curl -sLO https://modding-openmw.com/files/tes3cmd-macOS-x86_64.zip
    echo "e1628b6006189eb651f9569e207752f84d56a37cbddc39a96949ec4594f1302ea5ea9a096d469c616d365283593cc1bc8774b963f31f22adbbb869abdfaea4c5  tes3cmd-macOS-x86_64.zip" | sha512sum -c
    unzip -qq tes3cmd-macOS-x86_64.zip
    mv tes3cmd-macOS-x86_64 ${_macos}/tes3cmd
    cp -r ${_linux}/Readmes/Docs-TES3CMD ${_linux}/Readmes/Readme-TES3CMD.txt ${_macos}/Readmes/
}

function get_delta() {
    # macos
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/0.22.0/downloads/delta-plugin-0.22.0-darwin-amd64.zip
    echo "e5a989d3ec8cc8fd5b2b10384113e8165c906e81a4db09b7bfc67cc1d379ad2391f01c318f2e4cf87ba2cb413f8baf483627ac9a01fa5fbbb2d58991497e482b  delta-plugin-0.22.0-darwin-amd64.zip" | sha512sum -c
    unzip -oqq delta-plugin-0.22.0-darwin-amd64.zip
    mv delta_plugin ${_macos}/
    mv README.md ${_macos}/Readmes/README-DeltaPlugin.md
    mv LICENSE ${_macos}/Readmes/LICENSE-DeltaPlugin
    mv CHANGELOG.md ${_macos}/Readmes/CHANGELOG-DeltaPlugin.md
    mv THIRDPARTY.html ${_macos}/Readmes/THIRDPARTY-DeltaPlugin.html

    # windows
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/${delta_version}/downloads/delta-plugin-${delta_version}-windows-amd64.zip
    echo "86b1b16fb530ff9c36d7f3d7455b1d31b0a3139d52d3925a487d9120fb09e43dd229c95417cb6bdb3fc70649e4ef45f12247b3a4785fa19a0256a18023426a60  delta-plugin-${delta_version}-windows-amd64.zip" | sha512sum -c
    unzip -qq delta-plugin-${delta_version}-windows-amd64.zip
    mv delta_plugin.exe ${_windows}/
    mv README.md ${_windows}/Readmes/README-DeltaPlugin.md
    mv LICENSE ${_windows}/Readmes/LICENSE-DeltaPlugin
    mv CHANGELOG.md ${_windows}/Readmes/CHANGELOG-DeltaPlugin.md
    mv THIRDPARTY.html ${_windows}/Readmes/THIRDPARTY-DeltaPlugin.html

    # linux
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/${delta_version}/downloads/delta-plugin-${delta_version}-linux-amd64.zip
    echo "e00c895efe07649d76cf554f80709917d4a916f413b5d6b0497b75d009c27496e516e9260177f64e29d8f8421507ed98ebd65b94ce7ddcdf5da0a3fb791c097b  delta-plugin-${delta_version}-linux-amd64.zip" | sha512sum -c
    unzip -oqq delta-plugin-${delta_version}-linux-amd64.zip
    mv delta_plugin ${_linux}/
    mv README.md ${_linux}/Readmes/README-DeltaPlugin.md
    mv LICENSE ${_linux}/Readmes/LICENSE-DeltaPlugin
    mv CHANGELOG.md ${_linux}/Readmes/CHANGELOG-DeltaPlugin.md
    mv THIRDPARTY.html ${_linux}/Readmes/THIRDPARTY-DeltaPlugin.html
}

function get_lightfixes() {
    curl -sL -o s3lightfixes-linux.zip https://github.com/magicaldave/S3LightFixes/releases/download/v${lightfixes_version}/ubuntu-latest.zip
    echo "a0ed379af4a9c8c3030045c6c0cf5d28514439bf10df1215545492d437d81aa0944d3b7c32929a720fa26781ed6ab2751d86a2d74fa9ef7b9d9dd44ad1c89d53  s3lightfixes-linux.zip" | sha512sum -c
    unzip -qq s3lightfixes-linux.zip
    mv s3lightfixes ${_linux}/

    curl -sL -o s3lightfixes-mac.zip https://github.com/magicaldave/S3LightFixes/releases/download/v${lightfixes_version}/macos-latest.zip
    echo "128593b3fd13f2a59ab9390c68f84665fb772da425c99b7ff98b398986e7e15155e5d01c5e287ce7ee5d218684baa9ced0ac437d158d2245133af5718e86f819  s3lightfixes-mac.zip" | sha512sum -c
    unzip -qq s3lightfixes-mac.zip
    mv s3lightfixes ${_macos}/

    curl -sL -o s3lightfixes-win.zip https://github.com/magicaldave/S3LightFixes/releases/download/v${lightfixes_version}/windows-latest.zip
    echo "bfb484036d75a40d257425088a905e7edfa79c5668d8ed1959aa73a3517eb954e1d258de90bf77987a29e8c7bbba01fc771f115a6c4cd1a79903415b8194de93  s3lightfixes-win.zip" | sha512sum -c
    unzip -qq s3lightfixes-win.zip
    mv s3lightfixes.exe ${_windows}/

    curl -sL -o README-s3lightfixes.md https://raw.githubusercontent.com/magicaldave/S3LightFixes/refs/heads/main/Readme.md
    cp README-s3lightfixes.md ${_linux}/Readmes/
    cp README-s3lightfixes.md ${_macos}/Readmes/
    cp README-s3lightfixes.md ${_windows}/Readmes/
}

function get_groundcoverify() {
    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Fgroundcoverify/jobs/artifacts/exeify/raw/dist/groundcoverify-linux.tar.gz?job=linux"
    echo "ccc4987c7ac82aebb2bbb87ba24b7dd1a3d2a6825dd4a2a0fc7e57046e52d9307fa2da2e4640402db5da7464ae86dea1853cec0eda3f54b88a4c608257bcacd4  groundcoverify-linux.tar.gz" | sha512sum -c
    tar xf groundcoverify-linux.tar.gz
    mv groundcoverify ${_linux}/

    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Fgroundcoverify/jobs/artifacts/exeify/raw/dist/groundcoverify-macos.tar.gz?job=macos_arm64"
    echo "e13319e2ec05dc9004968b8f6933e2ab64d699c41e214fc5e6e9227405707f35c8a15f073145a40218b8bc8f896c51a7e4a46c9a1a5fcffbbc8098e92a1007e6  groundcoverify-macos.tar.gz" | sha512sum -c
    tar xf groundcoverify-macos.tar.gz
    mv groundcoverify ${_macos}/

    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Fgroundcoverify/jobs/artifacts/exeify/raw/dist/groundcoverify-win.zip?job=windows"
    echo "c3d86b2e2916daf432e0b1c8648c2b64a3fb530c697287adf494bf96507d6297407bb5d55a6f10dc5afa9592f2c90303c0d01c1faee464768f26e0b2917f3f23  groundcoverify-win.zip" | sha512sum -c
    # We have to catch this error since unzip complains about the folder separators and it causes a nonzero exit
    unzip -qq groundcoverify-win.zip || printf ""
    mv groundcoverify/groundcoverify.exe ${_windows}/

    curl -sL -o LICENSE-groundcoverify.md https://gitlab.com/bmwinger/groundcoverify/-/raw/main/LICENSE
    curl -sL -o README-groundcoverify.md https://gitlab.com/bmwinger/groundcoverify/-/raw/main/README.md
    cp README-groundcoverify.md LICENSE-groundcoverify.md ${_linux}/Readmes/
    cp README-groundcoverify.md LICENSE-groundcoverify.md ${_macos}/Readmes/
    cp README-groundcoverify.md LICENSE-groundcoverify.md ${_windows}/Readmes/
}

function get_validator() {
    curl -sL -o validator.zip https://gitlab.com/modding-openmw/openmw-validator/-/package_files/159324029/download
    echo "14251cf16d557ef9c33d7df22de19e48ae9dca8a6e4bd0979f9be49ab3853766c01ad69287280004e12de00a0b89978fca76b913113f6f8cc4ca10bf77683fb8  validator.zip" | sha512sum -c
    unzip -qq validator.zip
    mv openmw-validator/openmw-validator-macos-arm64 openmw-validator/openmw-validator-macos-amd64 ${_macos}/
    mv openmw-validator/openmw-validator-linux-arm64 openmw-validator/openmw-validator-linux-amd64 ${_linux}/
    mv openmw-validator/openmw-validator.exe ${_windows}/

    curl -sL -o README-openmw-validator.md https://gitlab.com/modding-openmw/openmw-validator/-/raw/master/README.md
    cp README-openmw-validator.md ${_linux}/Readmes/
    cp README-openmw-validator.md ${_macos}/Readmes/
    cp README-openmw-validator.md ${_windows}/Readmes/
}

function main() {
    mkdir -p ${_linux}/Readmes
    mkdir -p ${_macos}/Readmes
    mkdir -p ${_windows}/Readmes

    cp README.org ${_linux}/Readmes/README-MOMW-Tools-Pack.org
    cp README.org ${_macos}/Readmes/README-MOMW-Tools-Pack.org
    cp README.org ${_windows}/Readmes/README-MOMW-Tools-Pack.org
    cp CHANGELOG.md ${_linux}/Readmes/CHANGELOG-MOMW-Tools-Pack.md
    cp CHANGELOG.md ${_macos}/Readmes/CHANGELOG-MOMW-Tools-Pack.md
    cp CHANGELOG.md ${_windows}/Readmes/CHANGELOG-MOMW-Tools-Pack.md

    get_umo
    get_configurator
    get_tes3cmd
    get_delta
    get_lightfixes
    get_groundcoverify
    get_validator

    version="$(git describe --tags)"
    for d in ${_linux} ${_windows} ${_macos}; do
        if [ "$d" = momw-tools-pack-macos ]; then
            delta_version=0.22.0
        fi
        cat > "${d}"/version.txt <<EOF
MOMW Tools Pack version:		$version
umo version:					$umo_version
MOMW Configurator version:		$configurator_version
TES3CMD version:				$tes3cmd_version
Delta Plugin version:			$delta_version
S3LightFixes version:			$lightfixes_version
Groundcoverify version:			$groundcoverify_version
OpenMW-Validator version:		$validator_version
EOF
    done

    tar cpzf ${_linux}.tar.gz ${_linux}
    zip -qqr ${_macos}.zip ${_macos}
    zip -qqr ${_windows}.zip ${_windows}
}

main
