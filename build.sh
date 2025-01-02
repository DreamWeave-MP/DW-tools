#!/usr/bin/env bash
set -euo pipefail

_linux=momw-tools-pack-linux
_macos=momw-tools-pack-macos
_windows=momw-tools-pack-windows

umo_version=0.8.2
configurator_version=1.14
tes3cmd_version=0.40-PRE-RELEASE-2
delta_version=0.22.0
lightfixes_version=0.1.5
groundcoverify_version=0.2.1-3
validator_version=1.14

function get_umo() {
    # linux
    curl -sL -o umo-linux.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/167549858/download
    echo "fca02f10b50589f2e490df5c0764bd75b397aaa58ae61c98c7112c0ee1c006aca6061473f42aaae629f6c39d6bf0edcbc7872e8cd739cc2feeeccaac9bdc4e8d  umo-linux.tar.gz" | sha512sum -c
    tar xf umo-linux.tar.gz
    mv umo/umo ${_linux}/

    # macos universal2
    curl -sL -o umo-macos.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/167549875/download
    echo "1294b91d9482bcd983f2e74326db347a5d3b31a10d7c65e63b7856e2f125ae05138956a66b104ad343e6727fe7a0599660d6e955a658596d2beec8419f6bdc00  umo-macos.tar.gz" | sha512sum -c
    tar xf umo-macos.tar.gz
    mv umo/umo* ${_macos}/

    # windows
    curl -sL -o umo-windows.zip https://gitlab.com/modding-openmw/umo/-/package_files/167549889/download
    echo "5de386390b20be0bfbe595c5ea07d20fee87621d82737689be75d855f911577d47e95fdaad7280e1966e97e7dd3cdf03a0419518a7d31cd4a0509e7671384cc5  umo-windows.zip" | sha512sum -c
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
    curl -sL -o configurator.zip https://gitlab.com/modding-openmw/momw-configurator/-/package_files/167558870/download
    echo "f512b06a2619ae11e0cec3616ce5e05e801d02495797abcff52d2d3a71573b5867a2426f5d614c05a8dab8483b6c7bd65edb3b73bb49064dcfb9f51415ad4ef6  configurator.zip" | sha512sum -c
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
    echo "6a78db8605a6e92beebba673814bafaf7185afb8fa8cca4e437a0d369220daef885686291b811c479a72952d62290db515c74c5a6c5ec127f62e75f2e6d587ec  s3lightfixes-linux.zip" | sha512sum -c
    unzip -qq s3lightfixes-linux.zip
    mv s3lightfixes ${_linux}/

    curl -sL -o s3lightfixes-mac.zip https://github.com/magicaldave/S3LightFixes/releases/download/v${lightfixes_version}/macos-latest.zip
    echo "7227761df7bd7de851fa901892e86a5358e40608ba8ecf471eb4c2748988190708540fd49ecc3b878eeb648f313de43f7c4ae1c467839f39b55e39ab89725de5  s3lightfixes-mac.zip" | sha512sum -c
    unzip -qq s3lightfixes-mac.zip
    mv s3lightfixes ${_macos}/

    curl -sL -o s3lightfixes-win.zip https://github.com/magicaldave/S3LightFixes/releases/download/v${lightfixes_version}/windows-latest.zip
    echo "8a2dd5449fd6cc6f10fa27535e51dac4c97aa0eaceea8eb7cee52afbf56a019e0ccc2a2f19a65cb93eede92d6abb5ec50b96ff2871e2eef1f1c5f73cbde3f2b5  s3lightfixes-win.zip" | sha512sum -c
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
