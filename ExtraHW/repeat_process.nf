nextflow.enable.dsl=2

params.input_reads_folder = './data'

process run_qc_initial {
    tag "$reads_label"

    input:
    tuple val(reads_label), path(reads)

    output:
    path "initial_qc_report/"

    script:
    """
    mkdir -p initial_qc_report
    fastqc -o initial_qc_report/ ${reads[0]} ${reads[1]}
    """
}

process trimm {
    tag "$reads_label"

    input:
    tuple val(reads_label), path(reads)

    output:
    tuple val(reads_label), path("out_R?_p.fq.gz")

    script:
    """
    trimmomatic PE ${reads[0]} ${reads[1]} \
    out_R1_p.fq.gz out_R1_u.fq.gz \
    out_R2_p.fq.gz out_R2_u.fq.gz \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
    LEADING:3 TRAILING:3 MINLEN:36
    """
}

process run_qc_trimmed {
    tag "$reads_label"

    input:
    tuple val(reads_label), path(reads)

    output:
    path "trimmed_qc_report/"

    script:
    """
    mkdir -p trimmed_qc_report
    fastqc -o trimmed_qc_report/ ${reads[0]} ${reads[1]}
    """
}

workflow {

    main:

    input_reads = Channel.fromFilePairs("${params.input_reads_folder}/*_{1,2}.fq")

    initial_qc = input_reads | run_qc_initial

    trimmed_reads = input_reads | trimm

    trimmed_qc = trimmed_reads | run_qc_trimmed


    publish:

    initial_qc_out = initial_qc
    trimmed_reads_out = trimmed_reads
    trimmed_qc_out = trimmed_qc
}

output {

    initial_qc_out {
        path 'initial_qc'
    }

    trimmed_reads_out {
        path 'trimmed_reads'
    }

    trimmed_qc_out {
        path 'trimmed_qc'
    }
}