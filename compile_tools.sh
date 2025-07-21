#!/usr/bin/env bash
set -euo pipefail

_linux=dreamweave-tools-linux
_macos=dreamweave-tools-macos
_windows=dreamweave-tools-windows

umo_version=0.10.9
tes3cmd_version=0.40-PRE-RELEASE-2
lightfixes_version=0.4.4
vfstool_version=0.2.0
tes3merge_version=0.11.3
_7zip_version=2500

function list_gitlab_package_files() {
    local repo_url="$1"

    local project_path
    project_path=$(echo "$repo_url" | sed -E 's|^https?://[^/]+/([^/]+/[^/]+?)(\.git)?/?$|\1|')

    local api_url="https://gitlab.com/api/v4/projects/${project_path//\//%2F}/packages"

    local package_json
    package_json=$(curl -s "$api_url?order_by=created_at&sort=desc&per_page=1")

    if ! jq -e '.[0]' <<< "$package_json" >/dev/null; then
        echo "Error: Failed to fetch package info or no packages found" >&2
        return 1
    fi

    local package_id
    package_id=$(jq -r '.[0].id' <<< "$package_json")

    local files_json
    files_json=$(curl -s "$api_url/$package_id/package_files")

    # Assumes there is a universal2 binary for macOS, or otherwise that the other two extensions don't exist
    jq -r --arg project_path "$project_path" '
        .[] | 
        select(.file_name | test("(.txt|.minisig|macos-x86_64.tar.gz|macos-arm64.tar.gz)$") | not) | 
        "\(.file_name)\thttps://gitlab.com/\($project_path)/-/package_files/\(.id)/download?file_name=\(.file_name)"
    ' <<< "$files_json" | column -t -s $'\t'
}

function get_umo() {
    # linux
    curl -sL -o umo-linux.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/185011459/download
    # echo "67744d162ac45360c988f0804c956e1b68cbedd91d8ed85b1371f10a03040f7c89ac3846852c5442a6769a5c49dcb1aa73c000a3b5fc65eb31c97b9646077b30  umo-linux.tar.gz" | sha512sum -c
    tar xf umo-linux.tar.gz
    mv umo/umo ${_linux}/

    # macos universal2
    curl -sL -o umo-macos.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/185011493/download
    # echo "fcd003c484c1ba9d1d165840ecbfd49403e1b2d013461b7fdd01d142e3c9d15df1261ed5bfe90b389387581408eb8bfd447d073ef6e863a6c30af9c05b3566b0  umo-macos.tar.gz" | sha512sum -c
    tar xf umo-macos.tar.gz
    mv umo/umo* ${_macos}/

    # windows
    curl -sL -o umo-windows.zip https://gitlab.com/modding-openmw/umo/-/package_files/185011517/download
    # echo "73bd78049d635ad337380d80fc79672b157db47bb1fe62b8bc873886b544414b4cbc9ab27d0b7926e1c6b9a70ab4b2aed7a0c0f1c5ebffb5a4db9ebbaba7dbed  umo-windows.zip" | sha512sum -c
    # We have to catch this error since unzip complains about the folder separators and it causes a nonzero exit
    cd ${_windows}/
    unzip -oqq ../umo-windows.zip || printf "" #TODO: use 7z
    cd -

    curl -sL -o README-umo.org https://gitlab.com/modding-openmw/umo/-/raw/master/README.org
    cp README-umo.org ${_linux}/Doc/
    cp README-umo.org ${_macos}/Doc/
    cp README-umo.org ${_windows}/Doc/
}

function get_tes3cmd() {
    # linux
    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Ftes3cmd/jobs/artifacts/master/raw/tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64.tar.gz?job=build_linux"
    echo "f07ff02343b8dbf3b3ed3791bfdced30fa4edcffde9d682d1ec062d454d5a489c36097bff41147b578042848dd3e512af52414d568de71b0eb5fad01f78570b1  tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64.tar.gz" | sha512sum -c
    tar xvf tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64.tar.gz
    mv tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64 ${_linux}/tes3cmd
    mv Readme.txt ${_linux}/Doc/Readme-TES3CMD.txt

    # windows
    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Ftes3cmd/jobs/artifacts/master/raw/tes3cmd.0.40-PRE-RELEASE-2-win.zip?job=build_win"
    echo "06fdb7620a00d7402985495901a52ae50228e8e75d314740573c1b3dc3e4daa2ce3b69b04f34862857f880ddd11d42d5363a41bf05fa58651f2ce5e0949d6aee  tes3cmd.0.40-PRE-RELEASE-2-win.zip" | sha512sum -c
    # We have to catch this error since unzip complains about the folder separators and it causes a nonzero exit
    unzip -qq tes3cmd.0.40-PRE-RELEASE-2-win.zip || printf ""
    mv tes3cmd.0.40-PRE-RELEASE-2/tes3cmd.0.40-PRE-RELEASE-2.exe ${_windows}/tes3cmd.exe
    cp ${_linux}/Doc/Readme-TES3CMD.txt ${_windows}/Doc/

    # macos
    curl -sLO 'https://gitlab.com/modding-openmw/tes3cmd/-/raw/master/tes3cmd?ref_type=heads&inline=false'
    # echo "e1628b6006189eb651f9569e207752f84d56a37cbddc39a96949ec4594f1302ea5ea9a096d469c616d365283593cc1bc8774b963f31f22adbbb869abdfaea4c5  tes3cmd-macOS-x86_64.zip" | sha512sum -c
    mv tes3cmd ${_macos}/tes3cmd
    cp -r ${_linux}/Doc/Readme-TES3CMD.txt ${_macos}/Doc/
}

function get_tes3merge() {
    curl -sL -o tes3merge-linux.zip https://github.com/DreamWeave-MP/TES3Merge/releases/download/${tes3merge_version}/TES3Merge-linux.zip
    echo "18264207ffd6c069c5a61daac1f22daf6ac6b5bd6e8d135fa3fb9b4c6fe78566 tes3merge-linux.zip" | sha256sum -c
    unzip -oqq tes3merge-linux.zip
    mv publish/linux/tes3merge publish/linux/TES3Merge.ini ${_linux}/

    curl -sL -o tes3merge-osx.zip https://github.com/DreamWeave-MP/TES3Merge/releases/download/${tes3merge_version}/tes3merge-osx.zip
    echo "4136355a2c40f13638cffcee97d706e46d53044821c717a1d4af8166d67c6114 tes3merge-osx.zip" | sha256sum -c
    unzip -oqq tes3merge-osx.zip
    mv publish/osx/tes3merge publish/osx/TES3Merge.ini ${_macos}/

    curl -sL -o tes3merge-win.zip https://github.com/DreamWeave-MP/TES3Merge/releases/download/${tes3merge_version}/TES3Merge-win.zip
    echo "2ae05b1e27b89b82ee7a054dfe3cb419c5fb9e3eeb47a7275f474c92fba0614b  tes3merge-win.zip" | sha256sum -c
    unzip -oqq tes3merge-win.zip
    mv tes3merge.exe TES3Merge.ini ${_windows}/
}

function get_lightfixes() {
    curl -sL -o s3lightfixes-linux.zip https://github.com/DreamWeave-MP/S3LightFixes/releases/download/${lightfixes_version}/ubuntu-latest.zip
    # echo "5f062b02476f07a1baa2669832eaa2f9ce96e3d231871383be0732e076ea846dfc5df95d7a09e18c4ae9859b8d1d67df9c4fb7c54b797f3174d6970809f07b3c s3lightfixes-linux.zip" | sha512sum -c
    unzip -oqq s3lightfixes-linux.zip
    mv s3lightfixes ${_linux}/
    mv Readme.md ${_linux}/Doc/Readme-s3lightfixes.md
    mv *.bundle ${_linux}/Cert/

    curl -sL -o s3lightfixes-mac.zip https://github.com/DreamWeave-MP/S3LightFixes/releases/download/${lightfixes_version}/macos-latest.zip
    # echo "7b126bd69f4092c8bc808f463168426837a5095a01cc0ce182e88cf97ddf554dbbc1712361cbb28d4766750f58e783d32a07f99afa2984558f137ffddc68a84f s3lightfixes-mac.zip" | sha512sum -c
    unzip -oqq s3lightfixes-mac.zip
    mv s3lightfixes ${_macos}/
    mv Readme.md ${_macos}/Doc/Readme-s3lightfixes.md
    mv *.bundle ${_macos}/Cert/

    curl -sL -o s3lightfixes-win.zip https://github.com/DreamWeave-MP/S3LightFixes/releases/download/${lightfixes_version}/windows-latest.zip
    # echo "a5226f2dd65f063aa92e642c29c52bae77491791ae4449189e59f8b8454b9257fc51a01316c85ab1b0f5ed9d9def9e7311f274c368f114327ff05fb7153ff8d2 s3lightfixes-win.zip" | sha512sum -c
    unzip -oqq s3lightfixes-win.zip
    mv s3lightfixes.exe ${_windows}/
    mv Readme.md ${_windows}/Doc/Readme-s3lightfixes.md
    mv *.bundle ${_windows}/Cert/
}

function get_vfstool() {
    curl -sL -o vfstool-linux.zip https://github.com/DreamWeave-MP/vfstool/releases/download/${vfstool_version}/ubuntu-latest.zip
    echo "ff26568fa740e56bdd6e81cbb9fbefb9f5f587b311c3c312bd6694653aab6c7c vfstool-linux.zip" | sha256sum -c
    unzip -oqq vfstool-linux.zip
    mv vfstool ${_linux}/
    mv README.md ${_linux}/Doc/Readme-vfstool.md
    mv *.bundle ${_linux}/Cert/

    curl -sL -o vfstool-mac.zip https://github.com/DreamWeave-MP/vfstool/releases/download/${vfstool_version}/macos-latest.zip
    echo "4991772884bb975dd808c8ff053e7449fc0127a28f731ab648272975d5324e69 vfstool-mac.zip" | sha256sum -c
    unzip -oqq vfstool-mac.zip
    mv vfstool ${_macos}/
    mv README.md ${_macos}/Doc/Readme-vfstool.md
    mv *.bundle ${_macos}/Cert/

    curl -sL -o vfstool-win.zip https://github.com/DreamWeave-MP/vfstool/releases/download/${vfstool_version}/windows-latest.zip
    echo "07d3259e402256a3838ed1323e23d120f1c191febb8d7de4c20cd3f6adb02bf4 vfstool-win.zip" | sha256sum -c
    unzip -oqq vfstool-win.zip
    mv vfstool.exe ${_windows}/
    mv README.md ${_windows}/Doc/Readme-vfstool.md
    mv *.bundle ${_windows}/Cert/
}

function get_7zip() {
    curl -sL -o 7zip-linux.tar.xz https://www.7-zip.org/a/7z${_7zip_version}-linux-x64.tar.xz
    # echo "aebf18d861944e2b52d91434b1d59d80a5aadf3b2e80ab3d248357bcaf3c429442caf4ad3297057a559f2719cae9ce5b0aa391963570ffa75b6dcdf1f3c25603 7zip-linux.tar.xz" | sha512sum -c
    tar xf 7zip-linux.tar.xz
    rm -rf 7zip-linux.tar.xz MANUAL 7zz History.txt 
    mv 7zzs ${_linux}/7zmo
    mv readme.txt ${_linux}/Doc/README-7zip.txt
    mv License.txt ${_linux}/Doc/License-7zip.txt

    curl -sL -o 7zip-mac.tar.xz https://www.7-zip.org/a/7z${_7zip_version}-mac.tar.xz
    # echo "c0879717d13930c4bbd132171fb20bb17a04e5b5cc357bdc1c8cc2c8d005f8b1761b41c5bef9cb0fea11b149de98a384d8fa017ebc64b2d56ba4af84897de73f 7zip-mac.tar.xz" | sha512sum -c
    tar xf 7zip-mac.tar.xz
    rm -rf 7zip-mac.tar.xz MANUAL History.txt
    mv 7zz ${_macos}/7zmo
    mv readme.txt ${_macos}/Doc/README-7zip.txt
    mv License.txt ${_macos}/Doc/License-7zip.txt

    curl -sL -o 7zip.msi https://www.7-zip.org/a/7z${_7zip_version}-x64.msi
    # echo "a3396a70b739f3a80b25fe64103d1e98ea584dcdbdba740884ea10e00edfb37966ceb85f5cca995865fe90371eadff9df8132124d3dc2598a2d78bf86f6ddd6e  7zip.msi" | sha512sum -c
    ${_linux}/7zmo x 7zip.msi _7zip.dll _7z.dll _7z.exe readme.txt License.txt
    mv _7z.exe 7zmo.exe
    mv _7zip.dll 7zip.dll
    mv _7z.dll 7z.dll
    mv 7zmo.exe 7zip.dll 7z.dll ${_windows}/
    mv readme.txt ${_windows}/Doc/README-7zip.txt
    mv License.txt ${_windows}/Doc/License-7zip.txt
}

function main() {
    mkdir -p ${_linux}/Doc
    mkdir -p ${_linux}/Cert
    mkdir -p ${_macos}/Doc
    mkdir -p ${_macos}/Cert
    mkdir -p ${_windows}/Doc
    mkdir -p ${_windows}/Cert

    cp CHANGELOG.md ${_linux}/Doc/CHANGELOG-DreamWeave-Tools.md
    cp CHANGELOG.md ${_macos}/Doc/CHANGELOG-DreamWeave-Tools.md
    cp CHANGELOG.md ${_windows}/Doc/CHANGELOG-DreamWeave-Tools.md

    get_umo
    get_tes3cmd
    get_lightfixes
    get_vfstool
    get_7zip
    get_tes3merge

    version="$(git describe --always)"
    for d in ${_linux} ${_windows} ${_macos}; do
        cat > "${d}"/version.txt <<EOF
Dreamweave Tools version:		$version
S3LightFixes version:			$lightfixes_version
TES3CMD version:			  $tes3cmd_version
TES3Merge version:             $tes3merge_version
umo version:					 $umo_version
VFSTool version:                $vfstool_version
7-zip version:                    $_7zip_version
EOF
    done

    zip -qqr ${_linux}.zip ${_linux}
    zip -qqr ${_macos}.zip ${_macos}
    zip -qqr ${_windows}.zip ${_windows}

    # I jest don't feel like fixin' this some other way here, feller
    cp ${_linux}/Doc/CHANGELOG-DreamWeave-Tools.md CHANGELOG.md
}

main
# list_gitlab_package_files https://gitlab.com/modding-openmw/umo
