CC = gcc
CFLAGS = -Wall -Wextra -Iinclude -O2
SRC_DIR = src
INC_DIR = include
BIN_DIR = bin
BUILD_DIR = build

MKDIR = mkdir -p $1
RM    = rm -rf

# Detect OS
ifeq ($(OS),Windows_NT)
    TARGET = $(BIN_DIR)/app.exe

    CFLAGS += $(shell pkg-config --cflags sdl3 sdl3-image libserialport)

    LDFLAGS = $(shell pkg-config --libs sdl3 sdl3-image libserialport) \
              -lsetupapi

else
    TARGET = $(BIN_DIR)/app

    SERIALPORT_PREFIX := $(shell brew --prefix libserialport 2>/dev/null)

    # Fall back to /opt if brew didn't find it
    ifeq ($(SERIALPORT_PREFIX),)
        SERIALPORT_INC = /opt/include
        SERIALPORT_LIB = /opt/lib
    else
        SERIALPORT_INC = $(SERIALPORT_PREFIX)/include
        SERIALPORT_LIB = $(SERIALPORT_PREFIX)/lib
    endif

    CFLAGS += $(shell pkg-config --cflags sdl3 sdl3-image) \
              -I$(SERIALPORT_INC)

    LDFLAGS = $(shell pkg-config --libs sdl3 sdl3-image) \
              -L$(SERIALPORT_LIB) \
              -lserialport
endif

SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRCS))

all: $(TARGET)

$(TARGET): $(OBJS)
	$(call MKDIR,$(BIN_DIR))
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(call MKDIR,$(BUILD_DIR))
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) $(BUILD_DIR)
	rm -f $(TARGET)

run: $(TARGET)
	$(TARGET)

.PHONY: all clean run