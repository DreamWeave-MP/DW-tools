#!/usr/bin/env bash
set -euo pipefail

function get_umo() {
    # v0.4.7
    # linux
    curl -sL -o umo-linux.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/157200382/download
    echo "8a5174ed625e4321e4a19b39d89241c828d35f5016ab625f47063c13ab63c17b00e8a0e2a599cf1004b9c63012c26dc7534330098913247f5260733983d1e63f  umo-linux.tar.gz" | sha512sum -c
    tar xf umo-linux.tar.gz
    mv umo/umo momw-tools-pack-linux/

    # macos universal2
    curl -sL -o umo-macos.tar.gz https://gitlab.com/modding-openmw/umo/-/package_files/157200402/download
    echo "70d155a3e89ba5a99b35d65412f7195d2bdf18cfbbfa8ab028b813d7cb14d2c8ca6fb03642fac0320cb73adce7ac5c0aeee328c13bd727c41b31c9b82612fbf2  umo-macos.tar.gz" | sha512sum -c
    tar xf umo-macos.tar.gz
    mv umo/umo* momw-tools-pack-macos/

    # windows
    curl -sL -o umo-windows.zip https://gitlab.com/modding-openmw/umo/-/package_files/157200413/download
    echo "f930863df8f83e640d2812d73cbf494eaa49b6a4a1fb68d418352f021683d580fa45cbb1d101b8665c9ce181652d46bcdb865b5021986829f8fe1e0605673eab  umo-windows.zip" | sha512sum -c
    # We have to catch this error since unzip complains about the folder separators and it causes a nonzero exit
    unzip -oqq umo-windows.zip || echo womp
    mv umo/umo.exe momw-tools-pack-windows/
}

function get_configurator() {
    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Fmomw-configurator/jobs/artifacts/master/raw/momw-configurator.zip?job=make"
    echo "47b9c376528ed786af81d731d21e7f4b4eb5df3fb0cd03f6c8505287a3025c902dec020c4d3bb8be9646af7027f58e772061ba0cc2acfc1603dc66dba72b6862  momw-configurator.zip" | sha512sum -c
    unzip -qq momw-configurator.zip
    mv momw-configurator/momw-configurator-linux* momw-tools-pack-linux/
    mv momw-configurator/momw-configurator-macos* momw-tools-pack-macos/
    mv momw-configurator/momw-configurator.exe momw-tools-pack-windows/
}

function get_tes3cmd() {
    # linux
    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Ftes3cmd/jobs/artifacts/master/raw/tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64.tar.gz?job=build_linux"
    echo "f07ff02343b8dbf3b3ed3791bfdced30fa4edcffde9d682d1ec062d454d5a489c36097bff41147b578042848dd3e512af52414d568de71b0eb5fad01f78570b1  tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64.tar.gz" | sha512sum -c
    tar xvf tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64.tar.gz
    mv tes3cmd.0.40-PRE-RELEASE-2.linux.x86_64 Docs Readme.txt momw-tools-pack-linux/

    # windows
    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Ftes3cmd/jobs/artifacts/master/raw/tes3cmd.0.40-PRE-RELEASE-2-win.zip?job=build_win"
    echo "06fdb7620a00d7402985495901a52ae50228e8e75d314740573c1b3dc3e4daa2ce3b69b04f34862857f880ddd11d42d5363a41bf05fa58651f2ce5e0949d6aee  tes3cmd.0.40-PRE-RELEASE-2-win.zip" | sha512sum -c
    # We have to catch this error since unzip complains about the folder separators and it causes a nonzero exit
    unzip -qq tes3cmd.0.40-PRE-RELEASE-2-win.zip || echo womp
    mv tes3cmd.0.40-PRE-RELEASE-2/tes3cmd.0.40-PRE-RELEASE-2.exe momw-tools-pack-windows/
    cp -r momw-tools-pack-linux/Docs momw-tools-pack-linux/Readme.txt momw-tools-pack-windows/

    # macos
    curl -sLO https://modding-openmw.com/files/tes3cmd-macOS-x86_64.zip
    echo "e1628b6006189eb651f9569e207752f84d56a37cbddc39a96949ec4594f1302ea5ea9a096d469c616d365283593cc1bc8774b963f31f22adbbb869abdfaea4c5  tes3cmd-macOS-x86_64.zip" | sha512sum -c
    unzip -qq tes3cmd-macOS-x86_64.zip
    mv tes3cmd-macOS-x86_64 momw-tools-pack-macos/
    cp -r momw-tools-pack-linux/Docs momw-tools-pack-linux/Readme.txt momw-tools-pack-macos/
}

function get_delta() {
    delta_version=0.22.0

    # macos
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/${delta_version}/downloads/delta-plugin-${delta_version}-darwin-amd64.zip
    echo "e5a989d3ec8cc8fd5b2b10384113e8165c906e81a4db09b7bfc67cc1d379ad2391f01c318f2e4cf87ba2cb413f8baf483627ac9a01fa5fbbb2d58991497e482b  delta-plugin-0.22.0-darwin-amd64.zip" | sha512sum -c
    unzip -oqq delta-plugin-${delta_version}-darwin-amd64.zip
    mv delta_plugin README.md LICENSE CHANGELOG.md THIRDPARTY.html momw-tools-pack-macos/

    # windows
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/${delta_version}/downloads/delta-plugin-${delta_version}-windows-amd64.zip
    echo "b2e49f54e37706b30d3d346eb10e5e3852ab0680495f7cf074ba18d71c5cf7e527f596b4e2ba517bf370869a5f51b6b86ece9ac2e24707afb82bd001d6479b31  delta-plugin-0.22.0-windows-amd64.zip" | sha512sum -c
    unzip -qq delta-plugin-${delta_version}-windows-amd64.zip
    mv delta_plugin.exe README.md LICENSE CHANGELOG.md THIRDPARTY.html momw-tools-pack-windows/

    # linux
    curl -sLO https://gitlab.com/bmwinger/delta-plugin/-/releases/${delta_version}/downloads/delta-plugin-${delta_version}-linux-amd64.zip
    echo "9ecbf451065f90cdaa77abd4965bcf0c158f12c3fdb9c2286e72895c8a05f32c6ea37cd00ffee222fd87bb79087f6aa37c4872aa38aef93d67a2b09a44df29c3  delta-plugin-0.22.0-linux-amd64.zip" | sha512sum -c
    unzip -oqq delta-plugin-${delta_version}-linux-amd64.zip
    mv delta_plugin README.md LICENSE CHANGELOG.md THIRDPARTY.html momw-tools-pack-linux/
}

function get_lightfixes() {
    lightfixes_version=0.3
    
    curl -sLO https://github.com/glassmancody/waza_lightfixes/releases/download/${lightfixes_version}/linux.zip
    echo "eb1301a65f68891551438686c217693d4fbd4095026de190ba18e680046272b99ecd10d7fd811be5ba7a4e1230b840c734a03ba33596ff20594509bab3b80180  linux.zip" | sha512sum -c
    unzip -qq linux.zip
    mv linux/* momw-tools-pack-linux/

    curl -sLO https://github.com/glassmancody/waza_lightfixes/releases/download/${lightfixes_version}/macOS.zip
    echo "1fccc27632b0439d41153c2d1ef95414b4379261a983fb1ba264899a9df08e8e05ba740f555b335f21764a9f3d58bd7964f5f51502d08b542a020374a367c641  macOS.zip" | sha512sum -c
    unzip -qq macOS.zip
    mv macOS/* momw-tools-pack-macos/

    curl -sLO https://github.com/glassmancody/waza_lightfixes/releases/download/${lightfixes_version}/windows.zip
    echo "64704c699fc088db0bb63decc8a45be2032d60ec1363e283eb3ea82b0ae18c8976c72c3c06b28e67add91f4aa316b3f14171bf01e3e9cc293774557fc2a4beb7  windows.zip" | sha512sum -c
    unzip -qq windows.zip
    mv windows/* momw-tools-pack-windows/
}

function get_groundcoverify() {
    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Fgroundcoverify/jobs/artifacts/exeify/raw/dist/groundcoverify-linux.tar.gz?job=linux"
    echo "b3d8b029b7a2998a0e430b3aef8ac5a729a387deb059c67c89e4e490baa72e13b2cc90a123850a3b5ea3835a24b055dd9c301963f1dadd95bc9452b60d7e6c36  groundcoverify-linux.tar.gz" | sha512sum -c
    tar xf groundcoverify-linux.tar.gz
    mv groundcoverify momw-tools-pack-linux/

    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Fgroundcoverify/jobs/artifacts/exeify/raw/dist/groundcoverify-macos.tar.gz?job=macos_arm64"
    echo "e558e3c7448f799ec5bc2fe96c5a25ca9373be7617bf540ce814c4193c949f5814296194785b48449f43ede7ab7eee70ee10d449b04bb82e4f8128e55350ed0b  groundcoverify-macos.tar.gz" | sha512sum -c
    tar xf groundcoverify-macos.tar.gz
    mv groundcoverify momw-tools-pack-macos/

    curl -sLO "https://gitlab.com/api/v4/projects/modding-openmw%2Fgroundcoverify/jobs/artifacts/exeify/raw/dist/groundcoverify-win.zip?job=windows"
    echo "02694cab57fb73b579c3d30891047cb4a14bb9dd9d6aa22dbda75aabf0218640cba34f55d974b7f12abd4bf013f429c3f81901ae3140550becab14d8219af8fb  groundcoverify-win.zip" | sha512sum -c
    # We have to catch this error since unzip complains about the folder separators and it causes a nonzero exit
    unzip -qq groundcoverify-win.zip || echo womp
    mv groundcoverify/groundcoverify.exe momw-tools-pack-windows/
}

function get_validator() {
    curl -sL -o validator.zip https://gitlab.com/modding-openmw/openmw-validator/-/package_files/155893529/download
    echo "15def0b533c756917b406a2390046654780ffba2116b16a8e8adabc8a1efeb2c8964ce003270fc9ef1facd3918baf280f80f85aae5c1ffaf099b07d2b2c7e03e  validator.zip" | sha512sum -c
    unzip -qq validator.zip
    mv openmw-validator/openmw-validator-macos-arm64 openmw-validator/openmw-validator-macos-amd64 momw-tools-pack-macos/
    mv openmw-validator/openmw-validator-linux-arm64 openmw-validator/openmw-validator-linux-amd64 momw-tools-pack-linux/
    mv openmw-validator/openmw-validator.exe momw-tools-pack-windows/
}

function main() {
    mkdir momw-tools-pack-linux
    mkdir momw-tools-pack-macos
    mkdir momw-tools-pack-windows

    get_umo
    get_configurator
    get_tes3cmd
    get_delta
    get_lightfixes
    get_groundcoverify
    get_validator

    tar cpzf momw-tools-pack-linux.tar.gz momw-tools-pack-linux
    zip -qqr momw-tools-pack-macos.zip momw-tools-pack-macos
    zip -qqr momw-tools-pack-windows.zip momw-tools-pack-windows
}

main
