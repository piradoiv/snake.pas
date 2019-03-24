build: clean
	fpc -O3 -Os -CX -XX -Xs -osnake src/projectSnake.lpr
	mv src/snake snake
	strip snake

clean:
	rm -f src/*.o
	rm -f src/*.ppu
	rm -f snake
