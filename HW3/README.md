## Update (Homework 3 Improvement)

Variant calling was updated to use `bcftools` as an external module instead of a custom implementation. This follows best practices for reproducible and modular pipeline design.
------------------------------------------------------------------




# Bioinformatics Pipeline (Homework 3)

This repository contains an automated \*\*Nextflow pipeline\*\* for processing sequencing data from raw reads to variant calling and coverage visualization.

## Completed steps (all 8 steps):



**1. \*\*Data Download\*\***  

&#x20;  **Automatically download reads from NCBI SRA using `fasterq-dump`.**



**2. \*\*QC (Raw)\*\***  

&#x20;  **Quality control of raw reads using `FastQC`.**



**3. \*\*Trimming\*\***  

&#x20;  **Removing adapters and low-quality bases using `fastp`.**



**4. \*\*QC (Trimmed)\*\***  

&#x20;  **Quality control after trimming.**



**5. \*\*Assembly\*\***  

&#x20;  **De novo genome assembly using `SPAdes`.**



**6. \*\*Mapping\*\***  

&#x20;  **Alignment of trimmed reads to the assembled reference**  

&#x20;  **(`BWA mem` + `Samtools`, sorting and indexing).**



**7. \*\*Coverage Visualization\*\***  

&#x20;  **Calculation of coverage (`samtools depth`) and plotting using Python (`matplotlib`).**



**8. \*\*Variant Calling (NEW)\*\***  

&#x20;  **Variant calling using `bcftools` to produce a VCF file.**Requirements

* Nextflow
* Docker (the pipeline is fully containerized)



\## Requirements



\- Nextflow

\- Docker (pipeline is fully containerized)



## Usage

### &#x20;Run with SRA accession (default example)

### 

### ```bash

### nextflow run main.nf -profile container --accession DRR030302

### ```

### 

### &#x20;Resume run

### 

### ```bash

### nextflow run main.nf -profile container --accession DRR030302 -resume

### ```

### 

### &#x20;Run with local data

### 

### ```bash

### nextflow run main.nf -profile container \\

### &#x20;   --reads 'path/to/reads\_{1,2}.fastq.gz' \\

### &#x20;   --reference 'path/to/ref.fasta'

### ```

### 

### \## Results Structure

### 

### After completion, results are stored in the `results/` directory:

### 

### \- `qc/` — FastQC reports (raw and trimmed)

### \- `trimmed\_reads/` — trimmed reads

### \- `reference\_genome/` — assembled genome (scaffolds)

### \- `alignment/` — sorted and indexed BAM file

### \- `plots/` — genome coverage plot (`coverage\_plot.png`)

### \- `variants/` — variant calls (`.vcf` file)

### 

