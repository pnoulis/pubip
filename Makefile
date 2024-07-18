#!/usr/bin/make

SHELL := /bin/bash
.DEFAULT_GOAL := all

srcdir_top	 =.
m4					 = /usr/bin/m4
macrosfiles	 = $(srcdir_top)/macros.m4

all: edithosts

edithosts: edithosts.sh
	$(m4) $(macrosfile) $< > $@
	chmod 755 $@

scratch: scratch.sh
	$(m4) $(macrosfiles) $<
