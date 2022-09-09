#!/bin/sh

print_info() {
	printf "\e[1;35m$1\e[0m - \e[0;37m$2\e[0m\n"
}

help() {
	print_info help "Display callable targets"
	print_info clean "Cleanup build artifacts"
	print_info build "Build .love file"
	print_info run "Run .love file"
	print_info launch "Launch the game without building"
	print_info debug "Launch the game with console output"
}

clean() {
	rm -f Anniversary.love
}

build() {
	clean
	zip -9 -r Anniversary.love .
}

run() {
	build
	open Anniversary.love
}

launch() {
	open -n -a love .
}

debug() {
	/Applications/love.app/Contents/MacOS/love .
}

if [ ${1:+x} ]; then
	$1
else
	help
fi
	