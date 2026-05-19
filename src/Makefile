SHELL		= /bin/sh

prefix		= /usr/local
exec_prefix	= ${prefix}

name		= hope
bindir		= ${exec_prefix}/bin
testdir		= ../test

AWK		= awk
CC		= gcc
CFLAGS		= -g -O2 -pipe -pedantic -Wall -W -Wshadow -Wbad-function-cast -Wcast-qual -Wwrite-strings -Wpointer-arith -Wnested-externs -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations
INSTALL		= /usr/bin/install -c
INSTALL_DATA	= ${INSTALL} -m 644
INSTALL_PROGRAM = ${INSTALL}
LDFLAGS		= 
LIBS		= -lm 
YACC		= bison -y
mandir		= ${prefix}/man/man1

hopelib		= ${prefix}/share/hope/lib

c_srcs = bad_rectype.c builtin.c cases.c char.c char_array.c compare.c \
        compile.c deftype.c eval.c expr.c functor_type.c functors.c \
        interpret.c interrupt.c main.c memory.c module.c newstring.c \
        number.c output.c path.c polarity.c pr_expr.c pr_ty_value.c \
        pr_type.c pr_value.c remember_type.c runtime.c set.c source.c \
        stream.c table.c type_check.c type_value.c value.c yylex.c

parser = yyparse

sources	   = $(c_srcs) $(parser).y
c_made	   = $(parser).c
h_made	   = hopelib.h $(parser).h
other_made = op.sed
tmps	   = y.output y.tab.y y.tab.h y.tab.c y.tab.o

assoc	= Assoc.sed
mult_op	= Mult-op.awk

cfiles	= $(c_srcs) $(c_made)
objects	= $(cfiles:.c=.o)

$(objects): $(h_made) $(c_made)

$(name): $(objects)
	$(CC) $(LDFLAGS) -o $@ $(objects) $(LIBS)

all: $(name) $(name).1

run: $(name)
	HOPEPATH=../lib ./$(name) $(ARGS)

install: check $(name).1
	$(INSTALL) -d $(hopelib)
	$(INSTALL_PROGRAM) -s $(name) $(bindir)
	$(INSTALL_DATA) $(name).1 $(mandir)

$(name).1: $(name).1.in
	sed -e 's:@hopelib@:$(hopelib):' -e 's:@fullpath@:$(bindir)/$(name):' $(name).1.in >$@

cfiles: $(c_made) $(h_made)

tags:	$(sources)
	ctags -tw $(sources)

distclean: cfiles
	rm -f *.o core a.out errors
	rm -f $(name)
	rm -f $(tmps)

new:
	rm -f *.o core a.out errors $(h_made)
	rm -f $(name)

clean:
	rm -f *.o core a.out errors tags LOG
	rm -f $(h_made) $(c_made) $(other_made)
	rm -f $(tmps)

clobber: clean
	rm -f $(name) $(name).1

errors:	$(name) $(testdir)/*.in $(testdir)/*.out ../lib/*
	for file in $(testdir)/*.in;\
	do	STEM=`basename $$file .in`;\
		HOPEPATH=../lib nice ./$(name) -f $$file 2>&1 |\
			diff - $(testdir)/$$STEM.out |\
			sed "s/^/$$STEM: /";\
	done >$@
	LC_ALL=C; for file in ../lib/[a-z]*.hop;\
	do	HOPEPATH=../lib nice ./$(name) -f $$file 2>&1;\
	done >>$@

check:	errors
	test ! -s errors

hopelib.h:
	echo '#define HOPELIB "$(hopelib)"' >$@

$(parser).h $(parser).c: $(parser).y op.sed $(assoc)
	sed -f op.sed $(parser).y | sed -f $(assoc) >y.tab.y
	$(YACC) $(YFLAGS) -d y.tab.y
	grep -v '^# *line' y.tab.c |\
		sed -e '1s/*malloc(), //' -e 's:^  int yyerrstatus;:/* & */:' >$(parser).c
	mv y.tab.h $(parser).h
	rm -f y.tab.y y.tab.c

op.sed: op.h $(mult_op)
	$(AWK) -f $(mult_op) op.h >$@

y.output: $(parser).y op.sed $(assoc)
	sed -f op.sed $(parser).y | sed -f $(assoc) >y.tab.y
	$(YACC) -v y.tab.y
	rm -f y.tab.y y.tab.c

depend:	cfiles
	../sh/makedepend -- $(DEFS) -- $(c_srcs) $(c_made)
