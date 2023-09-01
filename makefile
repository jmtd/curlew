#  You may need to customize the next seven lines as described in README

HELP = /usr/local/lib
SEDSTRING = ""
PCFLAGS = -c
LINKFLAGS =
LIBS =
PASCAL = pc
LINK = pc

#  To compile curlew to run with SSMP, un-comment the following 4 lines by
#  removing the #REMOTE prefix.
#REMOTE LOCREM = REMOTE
#REMOTE PRIMS = stprim.o
#REMOTE HEADS = st.h
#REMOTE BASE = bsd

#  To compile curlew to run with termcap, un-comment the following 4 lines
#  by removing the #LOCAL prefix.
#LOCAL  LOCREM = LOCAL
#LOCAL  PRIMS = stprim.o tpprim.o
#LOCAL  HEADS = st.h tp.h
#LOCAL  BASE = sun

all : cl2 curlew.l curlew.help curlew
	touch all

clean :
	rm -f typecheck?.o ??prim.o cl*.o
	rm -f typecheck typecheck.ok ??.h all

veryclean : clean
	rm -f cl2 curlew.l st.typ.h typedefs typedefs.o

install : all
	rm -f /usr/local/bin/cl /usr/local/bin/cl2 /usr/local/bin/curlew
	install -c -m 711 -s cl2 /usr/local/bin
	install -c -m 755 curlew /usr/local/bin
	cd /usr/local/bin; ln -s curlew cl
	rm -f /usr/man/manl/curlew.l /usr/man/manl/cl.l
	install -c -m 444 curlew.l /usr/man/manl
	echo ".so manl/curlew.l" >/usr/man/manl/cl.l
	install -c -m 444 curlew.help ${HELP}

cl-.p : README
	@echo "To compile curlew, you must first modify the makefile to choose"
	@echo "either a local (Termcap) or Remote (SSMP) implementation"
	@echo "Details are contained in the file README"
	@false

curlew.l : curlew.t
	tbl curlew.t >curlew.l

cl2 : ${PRIMS} cl-${BASE}.o
	${LINK} ${LINKFLAGS} -o cl2 cl-${BASE}.o ${PRIMS} ${LIBS}

cl-${BASE}.o : cl-${BASE}.p ${HEADS}
	${PASCAL} ${PCFLAGS} cl-${BASE}.p

st.h : st-${BASE}.h
	sed ${SEDSTRING} <st-${BASE}.h >st.h

tp.h : tp-${BASE}.h
	sed ${SEDSTRING} <tp-${BASE}.h >tp.h

stprim.o : stprim.c st.typ.h local.h iso.h typecheck.ok
	cc -c -DHELPDIR=\"${HELP}\" -D${LOCREM} stprim.c

tpprim.o : tpprim.c st.typ.h local.h iso.h typecheck.ok
	cc -c tpprim.c

typecheck.ok : typecheck
	typecheck
	touch typecheck.ok

typecheck : typecheck1.o typecheck2.o
	${LINK} ${LINKFLAGS} -o typecheck typecheck1.o typecheck2.o ${LIBS}

typecheck1.o : typecheck1.p tc.h
	${PASCAL} ${PCFLAGS} typecheck1.p

typecheck2.o : st.typ.h typecheck2.c
	cc -c typecheck2.c

tc.h : typecheck1.h
	sed ${SEDSTRING} <typecheck1.h >tc.h

st.typ.h : typedefs
	typedefs >st.typ.h
	chmod a-w st.typ.h

typedefs : typedefs.o
	${LINK} ${LINKFLAGS} -o typedefs typedefs.o ${LIBS}

typedefs.o : typedefs.p
	${PASCAL} ${PCFLAGS} typedefs.p
