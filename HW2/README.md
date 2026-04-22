# Bioinformatics Pipeline (Homework 2)

This repository contains an automated Nextflow pipeline for processing sequencing data.

## Completed steps (all 7 steps):
1. **Data Download**: Automatically download reads from NCBI SRA using `fasterq-dump`.
2. **QC (Raw)**: Quality control of raw reads using `FastQC`.
3. **Trimming**: Trimming adapters and low-quality bases using `fastp`.
4. **QC (Trimmed)**: Repeated quality control after trimming.
5. **Assembly**: De novo genome assembly using `SPAdes`. 6. **Mapping**: Alignment of trimmed reads to the assembled reference (`BWA mem` + `Samtools`).
7. **Visualization**: Plotting a genome coverage graph using `Python` (matplotlib).

## Requirements
- Nextflow
- Docker (the pipeline is fully containerized)

## Usage

### Running with data from NCBI (DRR030302 by default):
```bash
nextflow run main.nf
Running with local files and your own reference:
code
Bash
nextflow run main.nf --reads 'path/to/reads_{1,2}.fastq.gz' --reference 'path/to/ref.fasta'
Results Structure
After completion, the results are available in the results/ folder:
qc/ — FastQC reports (raw and trimmed).
trimmed_reads/ — trimmed reads.
reference_genome/ — assembled genome (scaffolds).
alignment/ — sorted BAM file.
plots/ — genome coverage plot (coverage_plot.png).
