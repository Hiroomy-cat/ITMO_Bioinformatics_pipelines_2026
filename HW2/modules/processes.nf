// modules/processes.nf

process DOWNLOAD_SRA {
    tag "$accession"
    input: val accession
    output: tuple val(accession), path("${accession}_{1,2}.fastq")
    script:

}

process FASTQC {
    tag "$sample_id"
    input: tuple val(sample_id), path(reads)
    output: path "fastqc_${sample_id}_logs"
    script:
    """
    mkdir fastqc_${sample_id}_logs
    fastqc -o fastqc_${sample_id}_logs $reads
    """
}

process FASTP {
    tag "$sample_id"
    input: tuple val(sample_id), path(reads)
    output: 
        tuple val(sample_id), path("${sample_id}_trimmed_{1,2}.fastq.gz"), emit: reads
        path "${sample_id}.json", emit: report
    script:
    """
    fastp -i ${reads[0]} -I ${reads[1]} \
          -o ${sample_id}_trimmed_1.fastq.gz -O ${sample_id}_trimmed_2.fastq.gz \
          -j ${sample_id}.json
    """
}

process SPADES {
    tag "$sample_id"
    input: tuple val(sample_id), path(reads)
    output: path "scaffolds.fasta"
    script:
    """
    spades.py -1 ${reads[0]} -2 ${reads[1]} -o assembly_dir --only-assembler
    mv assembly_dir/scaffolds.fasta .
    """
}

process MAPPING {
    tag "$sample_id"
    input: 
        path ref
        tuple val(sample_id), path(reads)
    output: path "${sample_id}.sorted.bam"
    script:
    """
    bwa index $ref
    bwa mem $ref ${reads[0]} ${reads[1]} | samtools view -bS - | samtools sort -o ${sample_id}.sorted.bam
    samtools index ${sample_id}.sorted.bam
    """
}

process PLOT_COVERAGE {
    tag "Plotting"
    input: path bam
    output: path "coverage_plot.png"
    script:
    """
    # Installing matplotlib if it is not in the container
    pip install matplotlib --user || true
    
    samtools depth $bam > depth.txt
    plot_coverage.py depth.txt coverage_plot.png
    """
}
