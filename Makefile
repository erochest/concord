
SRC=$(shell find src -name '*.hs')

CABAL=cabal
FLAGS=--enable-tests

all: init test docs package

init: stackage
	${CABAL} sandbox init
	make deps

test: build
	${CABAL} test --test-option=--color

specs: build
	./dist/build/concord-specs/concord-specs

run:
	${CABAL} run -- --input data --output concord.output


# docs:
# generate api documentation
#
# package:
# build a release tarball or executable
#
# dev:
# start dev server or process. `vagrant up`, `yesod devel`, etc.
#
# install:
# generate executable and put it into `/usr/local`
#
# deploy:
# prep and push

tags: ${SRC}
	hasktags --ctags *.hs src

hlint:
	hlint *.hs src specs

clean:
	${CABAL} clean

distclean: clean
	-rm cabal.config
	${CABAL} sandbox delete

configure: clean
	${CABAL} configure ${FLAGS}

deps: clean
	${CABAL} install --only-dependencies --allow-newer ${FLAGS}
	make configure

build:
	${CABAL} build

restart: distclean init build

rebuild: clean configure build

stackage:
	curl 'http://www.stackage.org/snapshot/nightly-'`date "+%Y-%m-%d"`'/cabal.config?download=true' > cabal.config
	cabal update

.PHONY: all init test run clean distclean configure deps build rebuild hlint stackage
