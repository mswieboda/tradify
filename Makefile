default: build_and_run

build_exec:
	env LIBRARY_PATH="$(PWD)/lib_ext" crystal build src/tradify.cr -o build/tradify

build_exec_release:
	env LIBRARY_PATH="$(PWD)/lib_ext" crystal build --release src/tradify.cr -o build/tradify_release

build_and_run: build_exec run

build_release_and_run: build_exec_release run_release

run:
	env LD_LIBRARY_PATH="$(PWD)/lib_ext" ./build/tradify

run_release:
	env LD_LIBRARY_PATH="$(PWD)/lib_ext" ./build/tradify_release
