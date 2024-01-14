.PHONY: all build format edit demo clean

src?=0
dst?=5
team?=1
graph?=1
matrix?=1

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
	@dot -Tpng outfile1 -o output1.png
	@display output1.png


demo2: build
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./ftest.exe 2 matrices/matrix$(matrix).txt outfile2
	@dot -Tsvg outfile2 > bm_graph.svg
	@dot -Tpng outfile2 -o output2.png
	@display output2.png

demo3: build
	./ftest.exe 3  outfile3 $(src) $(dst) $(team)
	@echo "\n   🥁  RESULT (content of outfile1)  🥁\n"
	@dot -Tpng outfile3 -o output3.png
	@display output3.png
clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean
