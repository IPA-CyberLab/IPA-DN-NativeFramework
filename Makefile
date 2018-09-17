# Makefile

OPTIONS_COMPILE_DEBUG=-D_DEBUG -DDEBUG -D_REENTRANT -DREENTRANT -D_THREAD_SAFE -D_THREADSAFE -DTHREAD_SAFE -DTHREADSAFE -D_FILE_OFFSET_BITS=64 -I./nativelib_src/ -I/usr/local/opt/openssl/include -I /opt/local/include/ -g -fsigned-char

OPTIONS_LINK_DEBUG=-g -fsigned-char -lm -ldl -lrt -lpthread -lssl -lcrypto -lreadline -lncurses -lz

OPTIONS_COMPILE_RELEASE=-DNDEBUG -DVPN_SPEED -D_REENTRANT -DREENTRANT -D_THREAD_SAFE -D_THREADSAFE -DTHREAD_SAFE -DTHREADSAFE -D_FILE_OFFSET_BITS=64 -I./nativelib_src/ -I/usr/local/opt/openssl/include -I /opt/local/include/ -O2 -fsigned-char

OPTIONS_LINK_RELEASE=-O2 -fsigned-char -lm -ldl -lrt -lpthread -lssl -lcrypto -lreadline -lncurses -lz

HEADERS_NATIVELIB=nativelib_src/nativelib.h

OBJECTS_NATIVELIB=obj/obj/linux/nativelib.o obj/obj/linux/nativelib_test.o

ifeq ($(DEBUG),YES)
	OPTIONS_COMPILE=$(OPTIONS_COMPILE_DEBUG)
	OPTIONS_LINK=$(OPTIONS_LINK_DEBUG)
else
	OPTIONS_COMPILE=$(OPTIONS_COMPILE_RELEASE)
	OPTIONS_LINK=$(OPTIONS_LINK_RELEASE)
endif


# Build Action
default:	build

build:	$(OBJECTS_NATIVELIB) bin/sectest

obj/obj/linux/nativelib.o: nativelib_src/nativelib.c $(HEADERS_NATIVELIB)
	@mkdir -p obj/obj/linux/
	@mkdir -p bin/
	$(CC) $(OPTIONS_COMPILE) -c nativelib_src/nativelib.c -o obj/obj/linux/nativelib.o

obj/obj/linux/nativelib_test.o: nativelib_src/nativelib_test.c $(HEADERS_NATIVELIB)
	$(CC) $(OPTIONS_COMPILE) -c nativelib_src/nativelib_test.c -o obj/obj/linux/nativelib_test.o

bin/sectest: obj/obj/linux/nativelib.o $(HEADERS_NATIVELIB) $(OBJECTS_NATIVELIB)
	$(CC) obj/obj/linux/nativelib.o obj/obj/linux/nativelib_test.o $(OPTIONS_LINK) -o bin/sectest

clean:
	-rm -f $(OBJECTS_NATIVELIB)
	-rm -f bin/sectest

help:
	@echo "make [DEBUG=YES]"
	@echo "make install"
	@echo "make clean"


