
TOPDIR = .

LATEX = latex
PDFLATEX = pdflatex
BIBTEX = bibtex 
DVIPS = dvips
DVIPDF = dvipdf
FIG2DEV = fig2dev
MAKEINDEX = makeindex
CD = cd
ECHO = echo
MAKE = make

BIB_FLAG =
TEX_FLAG = 
INDEX_FLAG = -s nomencl.ist

BIB_SRC = $(TOPDIR)/bibli.bib
EPS = 
MAIN = CV_complet
PRES = Projet

.PHONY: images dot clean
 
all: pdf
dvi: $(MAIN).dvi
pdf: $(MAIN).pdf $(PRES).pdf
pres : $(PRES).pdf

clean:
	rm -f *.dvi *.eps *.aux *.bbl *.nlo *.nls *.log *.ilg *.blg *.toc
	rm -f $(MAIN).pdf $(PRES).pdf

images:
	@$(CD) Images; \
	echo "--> Images ..." >&2; \
        $(MAKE) ; \
	echo "<-- Images ..." >&2

dot:
	@$(CD) Dot; \
	echo "--> Dot ..." >&2; \
        $(MAKE) ; \
	echo "<-- Dot ..." >&2


$(MAIN).dvi: $(MAIN).bbl $(MAIN).tex
	$(LATEX) $(TEX_FLAG) $(MAIN).tex


$(MAIN).pdf: $(MAIN).bbl $(MAIN).tex
	$(PDFLATEX) $(TEX_FLAG) $(MAIN).tex

$(MAIN).bbl : $(BIB_SRC)
	$(PDFLATEX) $(MAIN).tex
	$(BIBTEX) $(MAIN)
	$(PDFLATEX) $(MAIN).tex

$(MAIN).nlo : $(MAIN).tex
	$(PDFLATEX) $(MAIN).tex

$(MAIN).nls : $(MAIN).nlo
	$(MAKEINDEX) $(MAIN).nlo $(INDEX_FLAG) -o $(MAIN).nls

$(PRES).pdf: $(PRES).bbl $(PRES).tex
	$(PDFLATEX) $(TEX_FLAG) $(PRES).tex

$(PRES).bbl : $(BIB_SRC)
	$(PDFLATEX) $(PRES).tex
	$(BIBTEX) $(PRES)
	$(PDFLATEX) $(PRES).tex


.SUFFIXES: .eps .fig .dvi .pdf

%.eps : %.fig
	$(FIG2DEV) -L eps $< > $@

%.pdf : %.eps
	epstopdf $< --outfile=$@

%.pdf : %.dvi
	$(DVIPDF) $<


