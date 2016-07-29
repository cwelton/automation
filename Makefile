.PHONY: all clean release debug lint coverage

LINT = ${HOME}/oclint/bin/oclint-json-compilation-database
CMAKE = `which cmake`

all: lint coverage

clean:
	@rm -rf build
	@rm -rf compile_commands.json

release:
	@mkdir -p build/release
	cd build/release && $(CMAKE) -DCMAKE_BUILD_TYPE=Release ../..
	$(MAKE) -C build/release

debug:
	@mkdir -p build/debug
	cd build/debug && $(CMAKE) -DCMAKE_BUILD_TYPE=Debug ../..
	$(MAKE) -C build/debug

lint: compile_commands.json
	@echo "-- Lint report written to: `pwd`/build/lint/lint.report"
	@$(LINT) -e test 1> build/lint/lint.report 2>&1 && cat -s build/lint/lint.report \
      || (rm compile_commands.json && cat -s build/lint/lint.report && exit 1)
	@rm -rf compile_commands.json

coverage:
	@mkdir -p build/coverage
	cd build/coverage && cmake -DCOVERAGE=ON ../..
	$(MAKE) -C build/coverage all coverage

compile_commands.json: build/lint/compile_commands.json
	@cp $< .

build/lint/compile_commands.json:
	@mkdir -p build/lint
	@cd build/lint && cmake -DCMAKE_BUILD_TYPE=Lint ../..
