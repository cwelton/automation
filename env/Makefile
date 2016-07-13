.PHONY: build lint clean

all: lint build 

build:
	$(MAKE) -C build

lint: build/compile_commands.json
	@cp build/compile_commands.json automation/.
	cd automation && oclint-json-compilation-database
	@rm -rf automation/compile_commands.json

coverage:
	@mkdir -p build
	cd build && cmake -DCMAKE_BUILD_TYPE=Coverage ../automation
	$(MAKE) -C build

clean:
	@rm -rf build
	@rm -rf automation/compile_commands.json

build/compile_commands.json:
	@mkdir -p build
	cd build && cmake -DCMAKE_BUILD_TYPE=Lint ../automation

