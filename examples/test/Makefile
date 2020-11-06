PREFIX = mips64r5900el-ps2-elf-

CFILES		= $(notdir $(wildcard *.c))
AFILES		= $(notdir $(wildcard *.s))

OFILES		= $(addprefix build/,$(CFILES:.c=.o)) \
		$(addprefix build/,$(AFILES:.s=.o))

CC = $(PREFIX)gcc
AS = $(PREFIX)as
LD = $(PREFIX)ld

CFLAGS = -fno-builtin -fdata-sections -ffunction-sections

LDFLAGS = 
TARGET = test.elf

all: $(OFILES)
	$(LD) $(LDFLAGS) $(OFILES) -o $(TARGET)
	
build/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@
	
build/%.o: %.s
	@mkdir -p $(dir $@)
	$(CC) $(AFLAGS) -c $< -o $@
	
clean:
	rm -rf build $(TARGET)
