### doc/lispintro/Makefile.  Generated from Makefile.in by configure.

# Copyright (C) 1994-1999, 2001-2024 Free Software Foundation, Inc.

# This file is part of GNU Emacs.

# GNU Emacs is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# GNU Emacs is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

SHELL = /bin/bash

srcdir = .
top_builddir = ../..

buildinfodir = $(srcdir)/../../info
# Directory with the (customized) texinfo.tex file.
texinfodir = $(srcdir)/../misc

prefix = /usr/local
datarootdir = ${prefix}/share
datadir = ${datarootdir}
PACKAGE_TARNAME = emacs
docdir = ${datarootdir}/doc/${PACKAGE_TARNAME}
dvidir = ${docdir}
htmldir = ${docdir}
pdfdir = ${docdir}
psdir = ${docdir}

MKDIR_P = /usr/bin/mkdir -p

GZIP_PROG = /usr/bin/gzip

HTML_OPTS = --no-split --html

# Options used only when making info output.
INFO_OPTS= --no-split

INSTALL = /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644

MAKEINFO = makeinfo
MAKEINFO_OPTS = --force -I $(emacsdir) -I $(srcdir)
TEXI2DVI = texi2dvi
TEXI2PDF = texi2pdf
DVIPS = dvips

-include ${top_builddir}/src/verbose.mk

ENVADD = \
  $(AM_V_GEN)TEXINPUTS="$(srcdir):$(texinfodir):$(emacsdir):$(TEXINPUTS)" \
  MAKEINFO="$(MAKEINFO) $(MAKEINFO_OPTS)"

DVI_TARGETS = sbcl-porting-guide.dvi
HTML_TARGETS = eintr.html
PDF_TARGETS = sbcl-porting-guide.pdf
PS_TARGETS = sbcl-porting-guide.ps

srcs = ${srcdir}/sbcl-porting-guide.texi ${srcdir}/doclicense.texi \
  ${emacsdir}/docstyle.texi

## Disable implicit rules.
%.texi: ;

.PHONY: info dvi html pdf ps

info: ${buildinfodir}/eintr.info
dvi: $(DVI_TARGETS)
html: $(HTML_TARGETS)
pdf: $(PDF_TARGETS)
ps: $(PS_TARGETS)

${buildinfodir}:
	${MKDIR_P} $@

# The file name eintr must fit within 5 characters, to allow for
# -NN extensions to fit into DOS 8+3 limits without clashing.
${buildinfodir}/eintr.info: ${srcs} | ${buildinfodir}
	$(AM_V_GEN)$(MAKEINFO) $(MAKEINFO_OPTS) $(INFO_OPTS) -o $@ $<

sbcl-porting-guide.dvi: ${srcs}
	$(ENVADD) $(TEXI2DVI) $<

sbcl-porting-guide.pdf: ${srcs}
	$(ENVADD) $(TEXI2PDF) $<

eintr.html: ${srcs}
	$(AM_V_GEN)$(MAKEINFO) $(MAKEINFO_OPTS) $(HTML_OPTS) -o $@ $<

sbcl-porting-guide.ps: sbcl-porting-guide.dvi
	$(DVIPS) -o $@ $<

.PHONY: mostlyclean clean distclean bootstrap-clean maintainer-clean infoclean

mostlyclean:
	rm -f ./*.aux ./*.log ./*.toc ./*.cp ./*.cps ./*.fn ./*.fns ./*.ky ./*.kys \
	  ./*.op ./*.ops ./*.pg ./*.pgs ./*.tp ./*.tps ./*.vr ./*.vrs

clean: mostlyclean
	rm -f $(DVI_TARGETS) $(HTML_TARGETS) $(PDF_TARGETS) $(PS_TARGETS)

distclean: clean
	rm -f Makefile

infoclean:
	rm -f \
	  $(buildinfodir)/eintr.info \
	  $(buildinfodir)/eintr.info-[1-9]

bootstrap-clean maintainer-clean: distclean infoclean
	rm -f TAGS

.PHONY: install-dvi install-html install-pdf install-ps install-doc

install-dvi: dvi
	umask 022; $(MKDIR_P) "$(DESTDIR)$(dvidir)"
	$(INSTALL_DATA) $(DVI_TARGETS) "$(DESTDIR)$(dvidir)"
install-html: html
	umask 022; $(MKDIR_P) "$(DESTDIR)$(htmldir)"
	$(INSTALL_DATA) $(HTML_TARGETS) "$(DESTDIR)$(htmldir)"
install-pdf: pdf
	 umask 022;$(MKDIR_P) "$(DESTDIR)$(pdfdir)"
	$(INSTALL_DATA) $(PDF_TARGETS) "$(DESTDIR)$(pdfdir)"
install-ps: ps
	umask 022; $(MKDIR_P) "$(DESTDIR)$(psdir)"
	for file in $(PS_TARGETS); do \
	  $(INSTALL_DATA) $${file} "$(DESTDIR)$(psdir)"; \
	  [ -n "${GZIP_PROG}" ] || continue; \
	  rm -f "$(DESTDIR)$(psdir)/$${file}.gz"; \
	  ${GZIP_PROG} -9n "$(DESTDIR)$(psdir)/$${file}"; \
	done

## Top-level Makefile installs the Info manuals.
install-doc: install-dvi install-html install-pdf install-ps


.PHONY: uninstall-dvi uninstall-html uninstall-pdf uninstall-ps uninstall-doc

uninstall-dvi:
	for file in $(DVI_TARGETS); do \
	  rm -f "$(DESTDIR)$(dvidir)/$${file}"; \
	done
uninstall-html:
	for file in $(HTML_TARGETS); do \
	  rm -f "$(DESTDIR)$(htmldir)/$${file}"; \
	done
uninstall-ps:
	ext= ; [ -n "${GZIP_PROG}" ] && ext=.gz; \
	for file in $(PS_TARGETS); do \
	  rm -f "$(DESTDIR)$(psdir)/$${file}$${ext}"; \
	done
uninstall-pdf:
	for file in $(PDF_TARGETS); do \
	  rm -f "$(DESTDIR)$(pdfdir)/$${file}"; \
	done

uninstall-doc: uninstall-dvi uninstall-html uninstall-pdf uninstall-ps

ETAGS = ../../lib-src/etags${EXEEXT}

${ETAGS}: FORCE
	$(MAKE) -C $(dir $@) $(notdir $@)

texifiles = $(wildcard ${srcdir}/*.texi)

TAGS: ${ETAGS} $(texifiles)
	$(AM_V_GEN)${ETAGS} $(texifiles)

tags: TAGS
.PHONY: tags

FORCE:
.PHONY: FORCE

### Makefile ends here
