#!/usr/bin/make

SHELL									:= /bin/bash
.DEFAULT_GOAL					:= all

srcdir_top						=.
bindir								= /home/pnoul/src/pnoul/pubip/bin

m4										= /usr/bin/m4
macrosfiles						= $(srcdir_top)/macros.m4

proxy_login_username	?= $(USER)
proxy_hostname				?= localhost
proxy_port						?= 22
proxy_path						?= $(bindir)

all: edithosts

edithosts: edithosts.sh
	$(m4) $(macrosfile) $< > $@
	chmod 755 $@

scratch: scratch.sh
	$(m4) $(macrosfiles) $<

install: install_edithosts

install_edithosts: edithosts
# -p preserve file attributes
	scp -p -P 22 $(srcdir_top)/$< $(proxy_login_username)@$(proxy_hostname):$(proxy_path)
