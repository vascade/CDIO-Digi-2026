CC = gcc

SRC_DIR   = src
INC_DIR   = include
BIN_DIR   = bin
BUILD_DIR = build

CFLAGS = -Wall -Wextra -O2 -I$(INC_DIR)

MKDIR = mkdir -p $1
RM    = rm -rf

UNAME_S := $(shell uname -s)

$(info CFLAGS=$(CFLAGS))
$(info LDFLAGS=$(LDFLAGS))

# --------------------
# Windows (MinGW/MSYS)
# --------------------
ifeq ($(OS),Windows_NT)

    TARGET = $(BIN_DIR)/app.exe

    CFLAGS += $(shell pkg-config --cflags sdl3 sdl3-image libserialport)

    LDFLAGS += $(shell pkg-config --libs sdl3 sdl3-image libserialport)
    LDFLAGS += -lsetupapi

# --------------------
# macOS
# --------------------
else ifeq ($(UNAME_S),Darwin)

    TARGET = $(BIN_DIR)/app

    CFLAGS += $(shell pkg-config --cflags sdl3 sdl3-image libserialport)
    LDFLAGS += $(shell pkg-config --libs sdl3 sdl3-image libserialport)

# --------------------
# Linux
# --------------------
else

    TARGET = $(BIN_DIR)/app

    CFLAGS += $(shell pkg-config --cflags sdl3 sdl3-image libserialport)
    LDFLAGS += $(shell pkg-config --libs sdl3 sdl3-image libserialport)

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
	./$(TARGET)

.PHONY: all clean run