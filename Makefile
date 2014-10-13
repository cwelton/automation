TARGET = hello
LIBS   = 
CC     = gcc
CFLAGS = -Wall

.PHONY: all clean test pgstart pgstop

all: $(TARGET)

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) $(CFLAGS) $(LIBS) -o $@

test: $(TARGET)
	test/hello_test.py

pgstart: pgstop
	pg_config

pgstop:
	which postgres

clean:
	rm -f *.o
	rm -f $(TARGET)
