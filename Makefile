build: clean
	fpc -O3 -Os -CX -XX -Xs -osnake projectsnake.lpr

clean:
	rm -f *.o
	rm -f *.ppu
	rm -f snake
