CC = gcc
CFLAGS = -Wall -Wextra -Iinclude -O2

SRC_DIR = src
INC_DIR = include
BIN_DIR = bin
BUILD_DIR = build

TARGET = $(BIN_DIR)/app

SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRCS))

# --- Raylib (Homebrew auto-detect) ---
RAYLIB_PREFIX := $(shell brew --prefix raylib)

CFLAGS += -I$(RAYLIB_PREFIX)/include
LDFLAGS = -L$(RAYLIB_PREFIX)/lib -lraylib \
	-framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo

all: $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)
	rm -f $(TARGET)

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run