TOPDIR ?= $(shell pwd)/..
WM_TOOL ?= $(TOPDIR)/tools/wm_tool
TOOLDIR ?= $(TOPDIR)/toolchain/bin

DIRS=asm c

all clean:
	@for subdir in $(DIRS); do \
		_nextdir_=$${_thisdir_+$$_thisdir_/}$$subdir; \
		echo "===> $$_nextdir_"; \
		(_thisdir_=$$_nextdir_; export _thisdir_; cd $$subdir && \
		    exec $(MAKE) TOPDIR=$(TOPDIR) TOOLDIR=$(TOOLDIR) WM_TOOL=$(WM_TOOL) $@) || exit $$?; \
		echo "<=== $$_nextdir_"; \
	done
