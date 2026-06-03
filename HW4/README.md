# Bioinformatics Pipeline (Homework 4 – Advanced Techniques)

This pipeline extends Homework 3 by supporting multi-sample processing and advanced Nextflow features.

## New Features

### 1. Multi-sample input via CSV

The pipeline now accepts a samplesheet (`samples.csv`) with multiple samples:

* Each sample includes:

  * sample_id
  * group (e.g. virus / bacteria)
  * paired-end reads

### 2. Channel transformations

* All samples are read into a single channel
* Samples are split by `group`
* Each group is processed independently
* Results are merged back into a single channel

### 3. Variant filtering (new step)

A final analysis step was added:

* Variants are filtered using `bcftools filter`
* Only high-quality variants are retained (QUAL > 20)

### 4. Stub mode support

The filtering step supports `stub` execution:

```bash
nextflow run main.nf -stub-run
```

This allows rapid pipeline testing without heavy computation.

---

## Usage

### Run with samplesheet

```bash
nextflow run main.nf -profile local
```

### Run in stub mode (fast test)

```bash
nextflow run main.nf -profile local -stub-run
```

---

## Input format

Example `samples.csv`:

```
sample_id,group,reads_1,reads_2
sample1,virus,data/sample1_1.fastq.gz,data/sample1_2.fastq.gz
sample2,virus,data/sample2_1.fastq.gz,data/sample2_2.fastq.gz
sample3,bacteria,data/sample3_1.fastq.gz,data/sample3_2.fastq.gz
```

---

## Output structure

* `qc/` — FastQC reports
* `trimmed_reads/` — trimmed reads
* `alignment/` — BAM files
* `plots/` — coverage plots
* `variants/` — raw VCF files
* `filtered_variants/` — filtered VCF files

---

## Summary

This version demonstrates:

* multi-sample handling
* channel transformations (split / join)
* modular pipeline design
* stub-based development
