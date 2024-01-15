.PHONY: all build format edit demo clean

src?=0
dst?=5
graph?=1
matrix?=12
team?=1

all: build

build:
	@echo "\n   🚨  COMPILING  🚨 \n"
	dune build src/ftest.exe
	ls src/*.exe > /dev/null && ln -fs src/*.exe .

format:
	ocp-indent --inplace src/*

edit:
	code . -n

demo1: build
	./ftest.exe 1 graphs/graph$(graph).txt $(src) $(dst) outfile1
	@echo "\n   🥁  RESULT (content of outfile1)  🥁\n"
	@dot -Tsvg outfile1 > output1.svg
	@display output1.svg


demo2: build
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./ftest.exe 2 matrices/matrix$(matrix).txt outfile2
	@dot -Tsvg outfile2 > output2.svg
	@display output2.svg

demo3: build
	./ftest.exe 3 outfile3 $(src) $(dst) $(team)
	@echo "\n   🥁  RESULT (content of outfile1)  🥁\n"
	@dot -Tsvg outfile3 > output3.svg
	@display output3.svg

clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean
