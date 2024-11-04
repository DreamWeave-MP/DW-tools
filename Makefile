build:
	./build.sh

clean:
	rm -fr *.zip *.tar.gz groundcoverify/ linux/ macOS/ momw-configurator/ momw-tools-pack-* openmw-validator/ tes3cmd.0.40-PRE-RELEASE-2/ umo/ windows/

clean-all: clean web-clean

web-all: web-clean web-build local-web

web-debug-all: web-clean web-debug local-web

web-clean:
	cd web && rm -rf build site/*.md sha256sums soupault-*-linux-x86_64.tar.gz site/index.html

web-build:
	cd web && ./build.sh

web-debug:
	cd web && ./build.sh --debug

web-verbose:
	cd web && ./build.sh --verbose

local-web:
	cd web && python3 -m http.server -d build
