#!/usr/bin/env bash
set -euo pipefail

_linux=momw-tools-pack-linux
_macos=momw-tools-pack-macos
_windows=momw-tools-pack-windows

umo_version=0.8.23
configurator_version=1.18
tes3cmd_version=0.40-PRE-RELEASE-2
delta_version=0.22.3
lightfixes_version=0.3.29
groundcoverify_version=0.2.2
validator_version=1.14
vfstool_version=0.1.6
_7zip_version=2409

function get_umo() {
    # linux
    curl -sL -o umo-linux.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/185011459/download
    echo "67744d162ac45360c988f0804c956e1b68cbedd91d8ed85b1371f10a03040f7c89ac3846852c5442a6769a5c49dcb1aa73c000a3b5fc65eb31c97b9646077b30  umo-linux.tar.gz" | sha512sum -c
    tar xf umo-linux.tar.gz
    mv umo/umo ${_linux}/

    # macos universal2
    curl -sL -o umo-macos.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/185011493/download
    echo "fcd003c484c1ba9d1d165840ecbfd49403e1b2d013461b7fdd01d142e3c9d15df1261ed5bfe90b389387581408eb8bfd447d073ef6e863a6c30af9c05b3566b0  umo-macos.tar.gz" | sha512sum -c
    tar xf umo-macos.tar.gz
    mv umo/umo* ${_macos}/

    # windows
    curl -sL -o umo-windows.zip https://gitlab.com/modding-openmw/umo/-/package_files/185011517/download
    echo "73bd78049d635ad337380d80fc79672b157db47bb1fe62b8bc873886b544414b4cbc9ab27d0b7926e1c6b9a70ab4b2aed7a0c0f1c5ebffb5a4db9ebbaba7dbed  umo-windows.zip" | sha512sum -c
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
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/${delta_version}/downloads/delta-plugin-${delta_version}-darwin-amd64.zip
    echo "1962ca33df4d9d6d49616c16f14ea0c123bd7c40062581642579921fa544e8bb5ac4df987fa043bc20d8e016423043de151f04b7ac7b3c4b958a46c5041121c8  delta-plugin-${delta_version}-darwin-amd64.zip" | sha512sum -c
    unzip -oqq delta-plugin-${delta_version}-darwin-amd64.zip
    mv delta_plugin ${_macos}/
    mv README.md ${_macos}/Readmes/README-DeltaPlugin.md
    mv LICENSE ${_macos}/Readmes/LICENSE-DeltaPlugin
    mv CHANGELOG.md ${_macos}/Readmes/CHANGELOG-DeltaPlugin.md
    mv THIRDPARTY.html ${_macos}/Readmes/THIRDPARTY-DeltaPlugin.html

    # windows
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/${delta_version}/downloads/delta-plugin-${delta_version}-windows-amd64.zip
    echo "8f2a589a2e51a69290bb40a4f6ff594e76467dc6ff6c982dcef0d98ba2ce824bafd2d61dd22f9cd7236dcd0cfff38be138aeb90f16a36938d9ccc874d12819ba  delta-plugin-${delta_version}-windows-amd64.zip" | sha512sum -c
    unzip -qq delta-plugin-${delta_version}-windows-amd64.zip
    mv delta_plugin.exe ${_windows}/
    mv README.md ${_windows}/Readmes/README-DeltaPlugin.md
    mv LICENSE ${_windows}/Readmes/LICENSE-DeltaPlugin
    mv CHANGELOG.md ${_windows}/Readmes/CHANGELOG-DeltaPlugin.md
    mv THIRDPARTY.html ${_windows}/Readmes/THIRDPARTY-DeltaPlugin.html

    # linux
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/${delta_version}/downloads/delta-plugin-${delta_version}-linux-amd64.zip
    echo "37a0a3ce8ea6e96690ca2450bace3c7ed23589828b5127256d69fa923013498d3533b77bf04afc819f81f8c080a73f327d34dbdd030ca2d2903e7d57fedc9148  delta-plugin-${delta_version}-linux-amd64.zip" | sha512sum -c
    unzip -oqq delta-plugin-${delta_version}-linux-amd64.zip
    mv delta_plugin ${_linux}/
    mv README.md ${_linux}/Readmes/README-DeltaPlugin.md
    mv LICENSE ${_linux}/Readmes/LICENSE-DeltaPlugin
    mv CHANGELOG.md ${_linux}/Readmes/CHANGELOG-DeltaPlugin.md
    mv THIRDPARTY.html ${_linux}/Readmes/THIRDPARTY-DeltaPlugin.html
}

function get_lightfixes() {
    curl -sL -o s3lightfixes-linux.zip https://github.com/magicaldave/S3LightFixes/releases/download/v${lightfixes_version}/ubuntu-latest.zip
    echo "89be0e5d42e0dd676bd0e306b16d0716b56c0da3a30ba00b29c783e90b4ece204cf4d837b9a9cd14360226f60989ece0de436e2b5a5eeed8a4de5b120c0b8667 s3lightfixes-linux.zip" | sha512sum -c
    unzip -qq s3lightfixes-linux.zip
    mv s3lightfixes ${_linux}/
    mv Readme.md ${_linux}/Readmes/Readme-s3lightfixes.md

    curl -sL -o s3lightfixes-mac.zip https://github.com/magicaldave/S3LightFixes/releases/download/v${lightfixes_version}/macos-latest.zip
    echo "cd57fb092fa9204b1cc59b1672135365a5da033318a6f897990e4de5f57d75877e61091ab1795f0863f96d063c6e2aae39fc74029bc5f520aecc4574c3fb92ff s3lightfixes-mac.zip" | sha512sum -c
    unzip -qq s3lightfixes-mac.zip
    mv s3lightfixes ${_macos}/
    mv Readme.md ${_macos}/Readmes/Readme-s3lightfixes.md

    curl -sL -o s3lightfixes-win.zip https://github.com/magicaldave/S3LightFixes/releases/download/v${lightfixes_version}/windows-latest.zip
    echo "f09d688f18b7395a9ec2a5cc06747e517c822ecd3bcae1785b660a600b1950fc95ccdfae80770f8c6ea37211abcbf1b40eed779effa8716d5dd8fa356dd91372 s3lightfixes-win.zip" | sha512sum -c
    unzip -qq s3lightfixes-win.zip
    mv s3lightfixes.exe ${_windows}/
    mv Readme.md ${_windows}/Readmes/Readme-s3lightfixes.md
}

function get_vfstool() {
    curl -sL -o vfstool-linux.zip https://github.com/magicaldave/vfstool/releases/download/v${vfstool_version}/ubuntu-latest.zip
    echo "8d8be9171e243fa065b7f9b14d2a6d4ff370bff3a5caa7b42f3e52bcc2065338ad47a65899b47f6b37737ee9a66c0967f4cdb0abd73289c19503a572264a28ff vfstool-linux.zip" | sha512sum -c
    unzip -qq vfstool-linux.zip
    mv vfstool ${_linux}/
    mv README.md ${_linux}/Readmes/Readme-vfstool.md

    curl -sL -o vfstool-mac.zip https://github.com/magicaldave/vfstool/releases/download/v${vfstool_version}/macos-latest.zip
    echo "4315825e86b12dabc74005b1039876c103f19f37543364ae6bbb3d0f8fb0c36562cfcecca406d45339c69dbab8768442411caed6d8777869ad891bce4e686fb4 vfstool-mac.zip" | sha512sum -c
    unzip -qq vfstool-mac.zip
    mv vfstool ${_macos}/
    mv README.md ${_macos}/Readmes/Readme-vfstool.md

    curl -sL -o vfstool-win.zip https://github.com/magicaldave/vfstool/releases/download/v${vfstool_version}/windows-latest.zip
    echo "0c21a745300bb27f0abe55e94f517782fcaed5108dd92a2ead5f3793ed28dfe10c2319c834c155a93b1c087e5e1f09e32fdac2adbff7c778138be7a09142573e vfstool-win.zip" | sha512sum -c
    unzip -qq vfstool-win.zip
    mv vfstool.exe ${_windows}/
    mv README.md ${_windows}/Readmes/Readme-vfstool.md
}

function get_7zip() {
    curl -sL -o 7zip-linux.tar.xz https://www.7-zip.org/a/7z${_7zip_version}-linux-x64.tar.xz
    echo "aebf18d861944e2b52d91434b1d59d80a5aadf3b2e80ab3d248357bcaf3c429442caf4ad3297057a559f2719cae9ce5b0aa391963570ffa75b6dcdf1f3c25603 7zip-linux.tar.xz" | sha512sum -c
    ls -la1 # Nani?
    tar xf 7zip-linux.tar.xz
    rm -rf 7zip-linux.tar.xz MANUAL 7zz History.txt 
    mv 7zzs ${_linux}/7zmo
    mv readme.txt ${_linux}/Readmes/README-7zip.txt
    mv License.txt ${_linux}/Readmes/License-7zip.txt

    curl -sL -o 7zip-mac.tar.xz https://www.7-zip.org/a/7z${_7zip_version}-mac.tar.xz
    echo "c0879717d13930c4bbd132171fb20bb17a04e5b5cc357bdc1c8cc2c8d005f8b1761b41c5bef9cb0fea11b149de98a384d8fa017ebc64b2d56ba4af84897de73f 7zip-mac.tar.xz" | sha512sum -c
    tar xf 7zip-mac.tar.xz
    rm -rf 7zip-mac.tar.xz MANUAL History.txt
    mv 7zz ${_macos}/7zmo
    mv readme.txt ${_macos}/Readmes/README-7zip.txt
    mv License.txt ${_macos}/Readmes/License-7zip.txt

    curl -sL -o 7zip.msi https://www.7-zip.org/a/7z${_7zip_version}-x64.msi
    echo "a3396a70b739f3a80b25fe64103d1e98ea584dcdbdba740884ea10e00edfb37966ceb85f5cca995865fe90371eadff9df8132124d3dc2598a2d78bf86f6ddd6e  7zip.msi" | sha512sum -c
    ${_linux}/7zmo x 7zip.msi _7zip.dll _7z.exe readme.txt License.txt
    mv _7z.exe 7zmo.exe
    mv _7zip.dll 7zip.dll
    mv 7zmo.exe 7zip.dll ${_windows}/
    mv readme.txt ${_windows}/Readmes/README-7zip.txt
    mv License.txt ${_windows}/Readmes/License-7zip.txt
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
    get_vfstool
    get_7zip

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
VFSTool version:                $vfstool_version
Groundcoverify version:			$groundcoverify_version
OpenMW-Validator version:		$validator_version
7-zip version:                  $_7zip_version
EOF
    done

    tar cpzf ${_linux}.tar.gz ${_linux}
    zip -qqr ${_macos}.zip ${_macos}
    zip -qqr ${_windows}.zip ${_windows}

    # I jest don't feel like fixin' this some other way here, feller
    cp ${_linux}/Readmes/CHANGELOG-MOMW-Tools-Pack.md CHANGELOG.md
}

main
