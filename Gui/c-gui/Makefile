CC = gcc
CFLAGS = -Wall -Wextra -Iinclude -O2
SRC_DIR = src
INC_DIR = include
BIN_DIR = bin
BUILD_DIR = build

# Detect OS
ifeq ($(OS),Windows_NT)
    TARGET = $(BIN_DIR)/app.exe

    # Adjust these paths to your installations
    RAYLIB_PATH    ?= C:/raylib
    SERIALPORT_PATH ?= C:/libserialport

    CFLAGS += -I$(RAYLIB_PATH)/include \
              -I$(SERIALPORT_PATH)/include

    LDFLAGS = -L$(RAYLIB_PATH)/lib \
              -L$(SERIALPORT_PATH)/lib \
              -lraylib \
              -lserialport \
              -lopengl32 \
              -lgdi32 \
              -lwinmm \
              -lsetupapi

    MKDIR = if not exist "$(subst /,\,$1)" mkdir "$(subst /,\,$1)"
    RM    = rmdir /s /q

else
    TARGET = $(BIN_DIR)/app

    RAYLIB_PREFIX     := $(shell brew --prefix raylib 2>/dev/null)
    SERIALPORT_PREFIX := $(shell brew --prefix libserialport 2>/dev/null)

    # Fall back to /opt if brew didn't find it
    ifeq ($(SERIALPORT_PREFIX),)
        SERIALPORT_INC = /opt/include
        SERIALPORT_LIB = /opt/lib
    else
        SERIALPORT_INC = $(SERIALPORT_PREFIX)/include
        SERIALPORT_LIB = $(SERIALPORT_PREFIX)/lib
    endif

    CFLAGS += -I$(RAYLIB_PREFIX)/include \
              -I$(SERIALPORT_INC)

    LDFLAGS = -L$(RAYLIB_PREFIX)/lib \
              -L$(SERIALPORT_LIB) \
              -lraylib \
              -lserialport \
              -framework OpenGL \
              -framework Cocoa \
              -framework IOKit \
              -framework CoreVideo

    MKDIR = mkdir -p $1
    RM    = rm -rf
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
ifeq ($(OS),Windows_NT)
	-$(RM) $(BUILD_DIR)
	-del /q $(TARGET) 2>nul
else
	$(RM) $(BUILD_DIR)
	rm -f $(TARGET)
endif

run: $(TARGET)
	$(TARGET)

.PHONY: all clean run