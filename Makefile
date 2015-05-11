SHELL = /bin/sh

SUBDIRS = ubuntu-64 \
ubuntu-32 \
$(null)

SRCDIR = "nightingale-hacking"

BUILDDIRS = $(SUBDIRS)
CLEANDIRS = $(SUBDIRS:%=clean-%)

MAKE = make
VAGRANT = vagrant
RM = rm

all: configure build

configure:
	$(RM) -rf $(SRCDIR)/nightingale.config
	touch $(SRCDIR)/nightingale.config
	# Add global config options
	# echo 'ac_add_options --ennable-nightly >> $(SRCDIR)/nightingale.config

build: $(BUILDDIRS)

$(BUILDDIRS):
	$(MAKE) -C $@
clean: $(CLEANDIRS)

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean
	$(MAKE) -C $(SRCDIR) clobber
	$(RM) -rf $(SRCDIR)/nightingale.config

.PHONY : clean all build $(BUILDDIRS) $(CLEANDIRS) configure
