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

test: $(TARGET) pgstart
	test/hello_test.py

pgstart: pgstop
	pg_config

pgstop:
	env
	which psql

clean:
	rm -f *.o
	rm -f $(TARGET)
