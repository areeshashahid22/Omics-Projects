# Capstone Project

## Title

End-to-End Bash → Python → R Biological Data Workflow

## Project goal

This project analyzes gene-expression data from control and treated samples using a reproducible workflow spanning Linux/Bash, Python, and R.

## Workflow

1. Linux/Bash creates the project structure and summarizes input files.
2. Python parses FASTA, FASTQ, GFF3, and VCF files.
3. R imports gene-expression and sample-metadata data.
4. R reshapes and joins the data.
5. R calculates mean expression, standard deviation, and log2 fold-change.
6. R generates publication-quality figures.
7. Biological findings are interpreted and presented.

## Project folders

- `raw/` — original input files
- `scripts/` — Bash, Python, and R scripts
- `results/` — generated tables and summaries
- `figures/` — generated figures

## Requirements

### Linux

- Bash
- Python

### Python packages

- Biopython
- pandas

### R packages

- readr
- dplyr
- tidyr
- ggplot2
- ggrepel

## Reproducing the workflow

Run:

```bash
cd scripts
./setup_project.sh
python parse_biofiles.py
