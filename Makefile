.PHONY: all build format edit demo clean

src?=0
dst?=5
graph?=1
matrix?=matrix.txt

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
	./ftest.exe 1 graphs/graph$(graph).txt $(src) $(dst) outfile
	@echo "\n   🥁  RESULT (content of outfile)  🥁\n"
	@dot -Tsvg outfile > graph.svg
	@display graph.svg


demo2: build
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./ftest.exe 2 $(matrix) outfile1
	@dot -Tsvg outfile1 > bm_graph.svg
	@display bm_graph.svg

clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean
