#
# Copyright (c) Stewart H. Whitman, 2024.
#
# File:    Makefile
# Project: HP Z6 G4 Memory Fan Mounts
# License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
# Desc:    Makefile for directory
#

NAME = hp-z6-g4-memory-fan-mounts

OPENSCAD = openscad
PNGCRUSH = pngcrush -brute

SRCS = \
	hp-z6-memory-fan-mounts.scad \
	hp-z6-memory-fan-mount-single-80.scad \
	hp-z6-memory-fan-mount-dual-80-80.scad \
	hp-z6-memory-fan-mount-dual-80-92.scad \
	hp-z6-catch-bottom.scad \
	hp-z6-catch-top.scad \
	screw-hole.scad \
	fan.scad \
	hash.scad \
	rounded.scad \
	mitered.scad \
	gusset.scad \
	smidge.scad \

BUILDS = \
	hp-z6-memory-fan-mount-single-80.scad \
	hp-z6-memory-fan-mount-dual-80-80.scad \
	hp-z6-memory-fan-mount-dual-80-92.scad \

EXTRAS = \
	Makefile \
	README.md \
	LICENSE.txt \

TARGETS = $(BUILDS:.scad=.stl)
IMAGES = $(BUILDS:.scad=.png)
ICONS = $(BUILDS:.scad=.icon.png)

DEPDIR := .deps
DEPFLAGS = -d $(DEPDIR)/$*.d

COMPILE.scad = $(OPENSCAD) -o $@ $(DEPFLAGS)
RENDER.scad = $(OPENSCAD) -o $@ --render --colorscheme=Tomorrow
RENDERICON.scad = $(RENDER.scad) --imgsize=256,256

.PHONY: all images icons clean distclean

all: $(TARGETS)

images: $(IMAGES)

icons : $(ICONS)

%.stl : %.scad
%.stl : %.scad $(DEPDIR)/%.d | $(DEPDIR)
	$(COMPILE.scad) $<

%.unoptimized.png : %.scad
	$(RENDER.scad) $<

%.icon.unoptimized.png : %.scad
	$(RENDERICON.scad) $<

%.png : %.unoptimized.png
	$(PNGCRUSH) $< $@ || mv $< $@

clean:
	rm -f *.stl *.bak *.png

distclean: clean
	rm -rf $(DEPDIR)

$(DEPDIR): ; @mkdir -p $@

DEPFILES := $(TARGETS:%.stl=$(DEPDIR)/%.d)
$(DEPFILES):

include $(wildcard $(DEPFILES))
