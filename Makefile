SHELL	= /bin/sh

configure_args =
dirs	= lib src

all: config.status
	for dir in $(dirs); do (cd $$dir; $(MAKE) all); done

install: config.status
	for dir in $(dirs); do (cd $$dir; $(MAKE) install); done

clean: config.status
	for dir in $(dirs); do (cd $$dir; $(MAKE) clean); done

distclean: config.status
	for dir in $(dirs); do (cd $$dir; $(MAKE) distclean); done
	rm -f config.cache config.log config.status

clobber: config.status
	for dir in $(dirs); do (cd $$dir; $(MAKE) clobber); done
	for dir in $(dirs); do rm -f $$dir/Makefile; done
	rm -f src/config.h src/config.h.in src/stamp-h.in
	rm -f config.cache config.log config.status
	rm -f configure

config.status: configure
	./configure $(configure_args)

configure: configure.in
	autoheader
	autoconf

run: all
	HOPEPATH=lib src/hope $(ARGS)

%.run: all
	HOPEPATH=lib src/hope -f $*.hop

test check: all
	cd src && $(MAKE) check
