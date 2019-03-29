build:
	fpc -O3 -Os -CX -XX -Xs -osnake src/projectSnake.lpr
	mv src/snake snake
	strip snake

releases:
	mkdir -p dist
	fpc -Tlinux -Px86_64 -O3 -Os -CX -XX -Xs -osnake src/projectSnake.lpr
	mv src/snake dist/snake-linux-x86_64
	fpc -Tdarwin -Px86_64 -O3 -Os -CX -XX -Xs -osnake src/projectSnake.lpr
	mv src/snake dist/snake-macos-x86_64
	strip dist/snake-macos-x86_64
	cd dist && zip snake-linux-x86_64.zip snake-linux-x86_64
	cd dist && zip snake-linux-macos-x86_64.zip snake-macos-x86_64

clean:
	rm -f src/*.o
	rm -f src/*.ppu
	rm -rf src/lib
	rm -f snake
	rm -rf dist

all: build releases

