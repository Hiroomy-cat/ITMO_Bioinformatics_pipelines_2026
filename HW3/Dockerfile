FROM continuumio/miniconda3

RUN conda install -y -c bioconda -c conda-forge \
    sra-tools bwa samtools bcftools fastqc fastp spades matplotlib pandas && \
    conda clean -a -y