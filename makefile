cflags = -g -Wall -pedantic-errors -D_GNU_SOURCE -Wno-switch -std=c2x

calculadora.exe : main.o scanner.o parser.o calc.o
	gcc scanner.o parser.o calc.o main.o -o calculadora -L\msys64\usr\lib  -lfl

main.o: main.c scanner.c parser.c calc.c
	gcc $(cflags) -c main.c
	
calc.o: calc.c parser.h
	gcc $(cflags) -c calc.c

scanner.o: scanner.c parser.h
	gcc -c scanner.c

parser.o: parser.c scanner.h
	gcc $(cflags) -c parser.c

scanner.c scanner.h: scanner.l
	flex scanner.l

parser.c parser.h: parser.y
	bison parser.y

clean:
	rm scanner.c parser.c scanner.h parser.h scanner.o parser.o main.o calc.o calculadora.exe
