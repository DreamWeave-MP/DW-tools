#!/usr/bin/env bash
set -euo pipefail

_linux=momw-tools-pack-linux
_macos=momw-tools-pack-macos
_windows=momw-tools-pack-windows

umo_version=0.8.8
configurator_version=1.15
tes3cmd_version=0.40-PRE-RELEASE-2
delta_version=0.22.0
lightfixes_version=0.1.6
groundcoverify_version=0.2.1-3
validator_version=1.14

function get_umo() {
    # linux
    curl -sL -o umo-linux.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/168340738/download
    echo "d869d29093e8a9472ca840a06a843e5f313ab035c17e907a2c7518b075bf562f24e4bacdd8c17e977c3d36c1b7a6f5b7972690d7955d31163866ed7ed7c9bde4  umo-linux.tar.gz" | sha512sum -c
    tar xf umo-linux.tar.gz
    mv umo/umo ${_linux}/

    # macos universal2
    curl -sL -o umo-macos.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/168340761/download
    echo "ac177972a9e8e52e35662b0e75f1bfcab4fb6b537a7ea9cc99e79ea335106dce46d9c98fe4c7a0f749494c9a46b4e9d0ddecb7cc1a9d53efa71dbfe2a974431a  umo-macos.tar.gz" | sha512sum -c
    tar xf umo-macos.tar.gz
    mv umo/umo* ${_macos}/

    # windows
    curl -sL -o umo-windows.zip https://gitlab.com/modding-openmw/umo/-/package_files/168340793/download
    echo "f985e63034493de3d470150e29a9cf5c90e7c43a8d42f829d1151ac97fcc4fda191ba5f248eb8a513dcb1cd1e6ff296a5476862a5c652c404b6050646ef3553f  umo-windows.zip" | sha512sum -c
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
    curl -sL -o configurator.zip https://gitlab.com/modding-openmw/momw-configurator/-/package_files/167937394/download
    echo "3d33e3ade2c49ab44c6fb38f1a8464652cf46aea5e1bd92af8da10fd5686ea9ef3752771879c7988360aed90bf6ea1469eb017228baa5429ca85cd4e1e3912ec  configurator.zip" | sha512sum -c
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
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/${delta_version}/downloads/delta-plugin-${delta_version}-darwin-amd64.zip
    echo "e5a989d3ec8cc8fd5b2b10384113e8165c906e81a4db09b7bfc67cc1d379ad2391f01c318f2e4cf87ba2cb413f8baf483627ac9a01fa5fbbb2d58991497e482b  delta-plugin-0.22.0-darwin-amd64.zip" | sha512sum -c
    unzip -oqq delta-plugin-${delta_version}-darwin-amd64.zip
    mv delta_plugin ${_macos}/
    mv README.md ${_macos}/Readmes/README-DeltaPlugin.md
    mv LICENSE ${_macos}/Readmes/LICENSE-DeltaPlugin
    mv CHANGELOG.md ${_macos}/Readmes/CHANGELOG-DeltaPlugin.md
    mv THIRDPARTY.html ${_macos}/Readmes/THIRDPARTY-DeltaPlugin.html

    # windows
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/${delta_version}/downloads/delta-plugin-${delta_version}-windows-amd64.zip
    echo "b2e49f54e37706b30d3d346eb10e5e3852ab0680495f7cf074ba18d71c5cf7e527f596b4e2ba517bf370869a5f51b6b86ece9ac2e24707afb82bd001d6479b31  delta-plugin-0.22.0-windows-amd64.zip" | sha512sum -c
    unzip -qq delta-plugin-${delta_version}-windows-amd64.zip
    mv delta_plugin.exe ${_windows}/
    mv README.md ${_windows}/Readmes/README-DeltaPlugin.md
    mv LICENSE ${_windows}/Readmes/LICENSE-DeltaPlugin
    mv CHANGELOG.md ${_windows}/Readmes/CHANGELOG-DeltaPlugin.md
    mv THIRDPARTY.html ${_windows}/Readmes/THIRDPARTY-DeltaPlugin.html

    # linux
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/${delta_version}/downloads/delta-plugin-${delta_version}-linux-amd64.zip
    echo "9ecbf451065f90cdaa77abd4965bcf0c158f12c3fdb9c2286e72895c8a05f32c6ea37cd00ffee222fd87bb79087f6aa37c4872aa38aef93d67a2b09a44df29c3  delta-plugin-0.22.0-linux-amd64.zip" | sha512sum -c
    unzip -oqq delta-plugin-${delta_version}-linux-amd64.zip
    mv delta_plugin ${_linux}/
    mv README.md ${_linux}/Readmes/README-DeltaPlugin.md
    mv LICENSE ${_linux}/Readmes/LICENSE-DeltaPlugin
    mv CHANGELOG.md ${_linux}/Readmes/CHANGELOG-DeltaPlugin.md
    mv THIRDPARTY.html ${_linux}/Readmes/THIRDPARTY-DeltaPlugin.html
}

function get_lightfixes() {
    curl -sL -o s3lightfixes-linux.zip https://github.com/magicaldave/S3LightFixes/releases/download/v${lightfixes_version}/ubuntu-latest.zip
    echo "251552882a6717e81910058e5c2cd3b4fe5b76dd8905e56342226913a2591fcfd87826bc68e85f1cff1a80bd5be6746a10a01f23fb3815858aa64e0c58d20a48  s3lightfixes-linux.zip" | sha512sum -c
    unzip -qq s3lightfixes-linux.zip
    mv s3lightfixes ${_linux}/

    curl -sL -o s3lightfixes-mac.zip https://github.com/magicaldave/S3LightFixes/releases/download/v${lightfixes_version}/macos-latest.zip
    echo "c6fcdc561a04dacfe35e8825c832a5125d77b91d0638e2afd0457f85bce03c75627a33748cad8dcebee4e0204f62fc5d04eb002e10082906bf81bc9ce971087e  s3lightfixes-mac.zip" | sha512sum -c
    unzip -qq s3lightfixes-mac.zip
    mv s3lightfixes ${_macos}/

    curl -sL -o s3lightfixes-win.zip https://github.com/magicaldave/S3LightFixes/releases/download/v${lightfixes_version}/windows-latest.zip
    echo "5c7e35980ad36db5482c16f6294c7866930259af75e78dbc4d9c23d77f9f4ddb1dd58f7f71b3274b90bd94c0ea69b3939aa43c8a8bb7da43fb0da107ad01e850  s3lightfixes-win.zip" | sha512sum -c
    unzip -qq s3lightfixes-win.zip
    mv s3lightfixes.exe ${_windows}/

    cat > lightConfig.toml <<EOF
auto_install = false
disable_flickering = true
save_log = false
standard_hue = 0.6000000238418579
standard_saturation = 0.800000011920929
standard_value = 0.5699999928474426
standard_radius = 1.2
colored_hue = 1.0
colored_saturation = 0.8999999761581421
colored_value = 0.699999988079071
colored_radius = 1.100000023841858
EOF
    for d in ${_linux} ${_macos} ${_windows}; do
        cp lightConfig.toml "${d}"/
    done

    curl -sL -o README-s3lightfixes.md https://raw.githubusercontent.com/magicaldave/S3LightFixes/refs/heads/main/Readme.md
    cp README-s3lightfixes.md ${_linux}/Readmes/
    cp README-s3lightfixes.md ${_macos}/Readmes/
    cp README-s3lightfixes.md ${_windows}/Readmes/
}

function get_groundcoverify() {
    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Fgroundcoverify/jobs/artifacts/exeify/raw/dist/groundcoverify-linux.tar.gz?job=linux"
    echo "b3d8b029b7a2998a0e430b3aef8ac5a729a387deb059c67c89e4e490baa72e13b2cc90a123850a3b5ea3835a24b055dd9c301963f1dadd95bc9452b60d7e6c36  groundcoverify-linux.tar.gz" | sha512sum -c
    tar xf groundcoverify-linux.tar.gz
    mv groundcoverify ${_linux}/

    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Fgroundcoverify/jobs/artifacts/exeify/raw/dist/groundcoverify-macos.tar.gz?job=macos_arm64"
    echo "e558e3c7448f799ec5bc2fe96c5a25ca9373be7617bf540ce814c4193c949f5814296194785b48449f43ede7ab7eee70ee10d449b04bb82e4f8128e55350ed0b  groundcoverify-macos.tar.gz" | sha512sum -c
    tar xf groundcoverify-macos.tar.gz
    mv groundcoverify ${_macos}/

    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Fgroundcoverify/jobs/artifacts/exeify/raw/dist/groundcoverify-win.zip?job=windows"
    echo "02694cab57fb73b579c3d30891047cb4a14bb9dd9d6aa22dbda75aabf0218640cba34f55d974b7f12abd4bf013f429c3f81901ae3140550becab14d8219af8fb  groundcoverify-win.zip" | sha512sum -c
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
    for d in ${_linux} ${_macos} ${_windows}; do
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
