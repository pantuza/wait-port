#
#
#
# Makefile of wait-port project
#
# Author: Gustavo Pantuza Coelho Pinto
# Since: 24.03.2016
#
#
#


# Color definition for print purpose
BROWN=\e[0;33m
BLUE=\e[1;34m
END_COLOR=\e[0m


# Source code directory structure
BINDIR := bin
SRCDIR := src
LIBDIR := lib


# Source code file extension
SRCEXT := c


# Defines the C Compiler
CC := gcc


# Defines the language standards for GCC
STD := -std=gnu99

# Protection for stack-smashing attack
STACK := -fstack-protector-all -Wstack-protector

# Specifies to GCC the required warnings
WARNS := -Wall -Wextra -pedantic -pedantic

# Flags for compiling
CFLAGS := -O3 $(STD) $(STACK) $(WARNS)

# Debug options
DEBUG := -g3 -DDEBUG=1


#
# The binary file name
#
BINARY := wait-port


# %.o file names
NAMES := $(notdir $(basename $(wildcard $(SRCDIR)/*.$(SRCEXT))))
OBJECTS :=$(patsubst %,$(LIBDIR)/%.o,$(NAMES))



#
# COMPILATION RULES
#


# Rule for link and generate the binary file
all: $(OBJECTS)
	@echo -en "$(BROWN)LD $(END_COLOR)";
	$(CC) -o $(BINDIR)/$(BINARY) $+ $(DEBUG) $(CFLAGS) $(LIBS)
	@echo -en "\n--\nBinary file placed at" \
			  "$(BROWN)$(BINDIR)/$(BINARY)$(END_COLOR)\n";


# Rule for object binaries compilation
$(LIBDIR)/%.o: $(SRCDIR)/%.$(SRCEXT)
	@echo -en "$(BROWN)CC $(END_COLOR)";
	$(CC) -c $^ -o $@ $(DEBUG) $(CFLAGS) $(LIBS)


# Rule for run valgrind tool
valgrind:
	valgrind \
		--track-origins=yes \
		--leak-check=full \
		--leak-resolution=high \
		--log-file=$@.log \
		$(BINDIR)/$(BINARY)
	@echo -e "\nCheck the log file: $@.log\n"


# Rule for cleaning the project
clean:
	@rm -rvf $(BINDIR)/*;
	@rm -rvf $(LIBDIR)/*;
