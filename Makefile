all: rom

TARGET := hello-rs-64

ROM := $(TARGET).z64

DEBUG := 0
IPL3 := 1

ifeq ($(DEBUG),0)
	MODE_STR := release
	MODE_FLAG := --release
else
	MODE_STR := debug
	MODE_FLAG := 
endif

OBJCOPY := llvm-objcopy
DD := dd
CARGO := cargo
CARGOFLAGS :=
SPIMDISASM := spimdisasm
SPIMFLAGS := singleFileDisasm $(ROM) disasm --start 0x1000 --vram 0x80000400 --disasm-unknown
RM := rm
IQUECRYPT := iquecrypt
CID := 00bbc0de
APP := $(CID).app
KEY := 00000000000000000000000000000000
IV := 00000000000000000000000000000000

ifeq ($(IPL3),1)
	CARGOFLAGS += -F ipl3
endif

CWD := $(shell pwd)
TARGET_DIR := $(CWD)/target
BUILD_DIR := $(TARGET_DIR)/mips-ultra64-cpu/$(MODE_STR)
RUST_OBJ := $(BUILD_DIR)/$(TARGET)

%.z64: $(TARGET_DIR)/%.bin
	$(DD) if=$< of=$@ bs=16K conv=sync status=none

$(TARGET_DIR)/%.bin: $(RUST_OBJ)
	$(OBJCOPY) -O binary $< $@

$(RUST_OBJ): targets/linker.ld Cargo.toml build.rs src/main.rs
	$(CARGO) build $(MODE_FLAG) $(CARGOFLAGS)

$(APP): $(ROM)
	$(IQUECRYPT) encrypt -app $< -key $(KEY) -iv $(IV) -o $@

rom: $(ROM)

app: $(APP)

asm: disasm/$(TARGET)_80000400.text.s

disasm/%.s: rom
	$(SPIMDISASM) $(SPIMFLAGS)

clean:
	$(CARGO) clean
	$(RM) -rf disasm
	$(RM) -f $(ROM)
	$(RM) -f $(APP)

.PHONY: rom asm all clean app

.DEFAULT: all

-include $(RUST_OBJ).d