##############################################################################
# Build global options
# NOTE: Can be overridden externally.
#

#default is stm32f4discovery if you don't set board

#BOARD=


# Architecture or project specific options
##############################################################################
USE_UTIL=y
USE_CONFIG=n
USE_MODBUS=n
USE_SERIAL_PACKET=n
USE_MOTOROLA_PACKET=n
USE_MODBUS=n
USE_ACCEL=y
##############################################################################
# Project, sources and paths
#

# Define project name here
PROJECT = acceltest
PROJECTSRC=$(patsubst %.c,%.o,$(wildcard *.c))

# List all default C defines here, like -D_DEBUG=1
DDEFS =

# List all default ASM defines here, like -D_DEBUG=1
DADEFS =

# List all default directories to look for include files here
DINCDIR =

# List the default directory to look for the libraries here
DLIBDIR =

# List all default libraries here
DLIBS =

#
# End of default section
##############################################################################

##############################################################################
# Start of user section
#

# List all user C define here, like -D_DEBUG=1
UDEFS =

# Define ASM defines here
UADEFS =

# List all user directories here
UINCDIR =

# List the user directory to look for the libraries here
ULIBDIR =

# List all user libraries here
ULIBS =

#
# End of user defines
##############################################################################

include ../settings.mk

$(info ======================================================)
$(info  Include dir:$(INCDIR))
$(info ======================================================)
$(info  Asm src:$(ASMSRC))
$(info ======================================================)
$(info C src:$(CSRC))
$(info ======================================================)
$(info Project src:$(PROJECTSRC))
$(info ======================================================)

acceltest.cbp:
	perl -p -i -e  's/(\.\.\/)+usr\/src/../' acceltest.cbp

help:global_help
	@echo "	acceltest.cbp"
	@echo "		- removes wrong absolute path from acceltest.cbp"
	@echo ""
	@echo "	createtask"
	@echo "		- create a new task for app"
	@echo ""

.PHONY: acceltest.cbp help

include ../targets.mk
include ../help.mk

