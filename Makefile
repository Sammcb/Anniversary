.PHONY: help build run launch debug clean

# target: help - Display callable targets
help:
	@egrep "^# target:" Makefile | cut -c 10-

# target: build - Build .love file
build: clean
	zip -9 -r Anniversary.love .

# target: run - Run .love file
run: build
	open Anniversary.love

# target: launch - Launch the game without building
launch:
	open -n -a love .

# target: debug - Launch the game with console output
debug:
	/Applications/love.app/Contents/MacOS/love .

# target: clean - Cleanup build artifacts
clean:
	rm -f Anniversary.love

