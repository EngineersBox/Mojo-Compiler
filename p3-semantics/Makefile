.PHONY: all prep build clean
all:	build
prep:
	javacc -OUTPUT_DIRECTORY="lib/mojo/parse" src/mojo/Parser.jj
build:
	javac -cp bin -d bin src/*/*.java
clean:
	rm -rf bin/mojo/*.class lib output
run:
	java -classpath bin/ mojo.Semant tests/$(target)