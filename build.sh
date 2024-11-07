#!/usr/bin/env bash
set -euo pipefail

_linux=momw-tools-pack-linux
_macos=momw-tools-pack-macos
_windows=momw-tools-pack-windows

function get_umo() {
    # v0.4.13
    # linux
    curl -sL -o umo-linux.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/157704194/download
    echo "fcc235cf03295006cf6dfb983bc35dc7e649ab8f24a90f2299e463a1b9302557bddc9a95c4f5611bf88a1ae494d58a727a2e8f4b7e9dd065d7c5d3f38a98175c  umo-linux.tar.gz" | sha512sum -c
    tar xf umo-linux.tar.gz
    mv umo/umo ${_linux}/

    # macos universal2
    curl -sL -o umo-macos.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/157704222/download
    echo "cfec9f40d3b16e085e9a537c46e2b3ce7da2eb8a553018042ad0b1d107c628d4e14719f66af33d001c1c65390e392ccb41b2af23e1fbbe21bb0bc4044a2e4b30  umo-macos.tar.gz" | sha512sum -c
    tar xf umo-macos.tar.gz
    mv umo/umo* ${_macos}/

    # windows
    curl -sL -o umo-windows.zip https://gitlab.com/modding-openmw/umo/-/package_files/157704241/download
    echo "a5b2f9b9272b0094f0cdb44ac236a8ad3573087d4fd828f3f9cb76a97660e3f6e5b324366c7717661d9d9cd7dcb9fd1d4d831770709625cbbe088606a1078a2c  umo-windows.zip" | sha512sum -c
    # We have to catch this error since unzip complains about the folder separators and it causes a nonzero exit
    unzip -oqq umo-windows.zip || printf ""
    mv umo/umo.exe ${_windows}/

    curl -sL -o README-umo.org https://gitlab.com/modding-openmw/umo/-/raw/master/README.org
    cp README-umo.org ${_linux}/Readmes/
    cp README-umo.org ${_macos}/Readmes/
    cp README-umo.org ${_windows}/Readmes/
}

function get_configurator() {
    # v1.1
    curl -sL -o configurator.zip https://gitlab.com/modding-openmw/momw-configurator/-/package_files/158005741/download
    echo "05b29ba24796416976b3dbd106f185ddfa515971a8c89a2613514f1c248dbaf829c378c5a2c1bc9ba2fa8e1fc3536daf150762a9de12eaa3d6354d7c084cfa99  configurator.zip" | sha512sum -c
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
    delta_version=0.22.0

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
    lightfixes_version=0.3
    
    curl -sLO https://github.com/glassmancody/waza_lightfixes/releases/download/${lightfixes_version}/linux.zip
    echo "eb1301a65f68891551438686c217693d4fbd4095026de190ba18e680046272b99ecd10d7fd811be5ba7a4e1230b840c734a03ba33596ff20594509bab3b80180  linux.zip" | sha512sum -c
    unzip -qq linux.zip
    mv linux/* ${_linux}/

    curl -sLO https://github.com/glassmancody/waza_lightfixes/releases/download/${lightfixes_version}/macOS.zip
    echo "1fccc27632b0439d41153c2d1ef95414b4379261a983fb1ba264899a9df08e8e05ba740f555b335f21764a9f3d58bd7964f5f51502d08b542a020374a367c641  macOS.zip" | sha512sum -c
    unzip -qq macOS.zip
    mv macOS/* ${_macos}/

    curl -sLO https://github.com/glassmancody/waza_lightfixes/releases/download/${lightfixes_version}/windows.zip
    echo "64704c699fc088db0bb63decc8a45be2032d60ec1363e283eb3ea82b0ae18c8976c72c3c06b28e67add91f4aa316b3f14171bf01e3e9cc293774557fc2a4beb7  windows.zip" | sha512sum -c
    unzip -qq windows.zip
    mv windows/* ${_windows}/

    curl -sL -o README-waza-lightfixes.md https://raw.githubusercontent.com/glassmancody/waza_lightfixes/refs/heads/master/README.md
    cp README-waza-lightfixes.md ${_linux}/Readmes/
    cp README-waza-lightfixes.md ${_macos}/Readmes/
    cp README-waza-lightfixes.md ${_windows}/Readmes/
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

    curl -sL -o README-groundcoverify.md https://gitlab.com/bmwinger/groundcoverify/-/raw/main/README.md
    cp README-groundcoverify.md ${_linux}/Readmes/
    cp README-groundcoverify.md ${_macos}/Readmes/
    cp README-groundcoverify.md ${_windows}/Readmes/
}

function get_validator() {
    curl -sL -o validator.zip https://gitlab.com/modding-openmw/openmw-validator/-/package_files/155893529/download
    echo "15def0b533c756917b406a2390046654780ffba2116b16a8e8adabc8a1efeb2c8964ce003270fc9ef1facd3918baf280f80f85aae5c1ffaf099b07d2b2c7e03e  validator.zip" | sha512sum -c
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

    tar cpzf ${_linux}.tar.gz ${_linux}
    zip -qqr ${_macos}.zip ${_macos}
    zip -qqr ${_windows}.zip ${_windows}
}

main
