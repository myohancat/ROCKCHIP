.SUFFIXES : .c .o

include tools.mk

Q_		   := @
PKG_CONFIG ?= pkg-config


CXXFLAGS  += -fPIC -Wno-unused-result
CFLAGS    += -fPIC -Wno-unused-result
LDFLAGS   += -lpthread -ldl

OUT_DIR   := out
TARGET    := HelloWorld

INCDIRS   :=
SRCDIRS   :=
SRCS      :=

LOCAL_DIR := $(shell pwd)
BASE_DIR  := $(LOCAL_DIR)/base

CHIP_NAME       := RK3588
WITH_RENDERABLE := yes
WITH_UI         := yes
#WITH_MULTIMEDIA := yes
#WITH_WIFI       := yes
#WITH_BLUETOOTH  := yes
#WITH_CLI        := yes
#WITH_JSON       := yes
#WITH_XML        := yes

include $(BASE_DIR)/base.mk

INCDIRS   += $(LOCAL_DIR)
SRCDIRS   += $(LOCAL_DIR)
SRCS      += Main.cpp

###############################################################################
# DO NOT MODIFY .......
###############################################################################
APP           := $(OUT_DIR)/$(TARGET)
APP_OBJS      := $(SRCS:%=$(OUT_DIR)/%.o)
APP_DEPS      := $(APP_OBJS:.o=.d)
APP_CFLAGS    := $(CFLAGS) $(DEFINES) -MMD -MP
APP_CXXFLAGS  := $(CXXFLAGS) $(DEFINES) -MMD -MP
APP_CXXFLAGS  += $(addprefix -I, $(INCDIRS))
APP_CFLAGS    += $(addprefix -I, $(INCDIRS))
APP_LDFLAGS   := $(addprefix -L, $(LIBDIRS))
APP_LDFLAGS   += $(LDFLAGS)

vpath %.cpp $(SRCDIRS)
vpath %.c $(SRCDIRS)

.PHONY: all clean

all: $(OUT_DIR) app

app: $(APP_OBJS)
	@echo "[Linking... $(notdir $(APP))]"
	$(Q_)$(CXX) -o $(APP) $(APP_OBJS) $(APP_LDFLAGS)

clean:
	@echo "[Clean... all objs]"
	$(Q_)rm -rf $(OUT_DIR)

$(OUT_DIR):
	$(Q_)mkdir -p $(OUT_DIR)

$(OUT_DIR)/%.c.o: %.c
	@echo "[Compile... $(notdir $<)]"
	$(Q_)$(CC) $(APP_CFLAGS) -c $< -o $@

$(OUT_DIR)/%.cpp.o: %.cpp
	@echo "[Compile... $(notdir $<)]"
	$(Q_)$(CXX) $(APP_CXXFLAGS) -c $< -o $@

-include $(APP_DEPS)

install: app
	@echo "[Install .... $(notdir $(APP))]"
	# TODO
