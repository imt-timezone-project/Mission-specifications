build: cahierCharges.tex
	pdflatex cahierCharges.tex

full:
	pdflatex cahierCharges.tex
	pdflatex cahierCharges.tex

clean:
	rm -fr *.aux *.log *.out *.toc

mrproper: clean
	rm -fr cahierCharges.pdf
