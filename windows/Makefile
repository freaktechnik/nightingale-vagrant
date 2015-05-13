SHELL = /bin/sh

OBJDIR = dist

RM = rm
VAGRANT = vagrant

all: build

build:
	$(VAGRANT) up
	$(VAGRANT) destroy -f

clean:
	$(RM) -rf $(OBJDIR)

.PHONY : clean all build

