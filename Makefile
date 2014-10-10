TARGET = hello
LIBS   = 
CC     = gcc
CFLAGS = -Wall

.PHONY: all clean test

all: $(TARGET)

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) $(CFLAGS) $(LIBS) -o $@

test:
	test/hello_test.py

clean:
	rm -f *.o
	rm -f $(TARGET)
