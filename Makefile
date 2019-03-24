build: clean
	pwd
	ls -l src
	fpc -O3 -Os -CX -XX -Xs -osnake src/projectsnake.lpr
	mv src/snake snake

clean:
	rm -f src/*.o
	rm -f src/*.ppu
	rm -f snake
