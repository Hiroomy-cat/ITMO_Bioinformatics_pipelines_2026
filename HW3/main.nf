nextflow.enable.dsl=2

include { DOWNLOAD_SRA; FASTP; SPADES; MAPPING; PLOT_COVERAGE; VARIANT_CALLING } from './modules/processes.nf'
include { FASTQC as FASTQC_RAW } from './modules/processes.nf'
include { FASTQC as FASTQC_TRIM } from './modules/processes.nf'

workflow {

    if (params.accession) {
        ch_input_reads = DOWNLOAD_SRA(params.accession)
    } else if (params.reads) {
        ch_input_reads = Channel.fromFilePairs(params.reads)
    } else {
        error "Specify --accession or --reads"
    }

    ch_raw_qc   = FASTQC_RAW(ch_input_reads)
    ch_trimmed  = FASTP(ch_input_reads)
    ch_trim_qc  = FASTQC_TRIM(ch_trimmed.reads)

    if (params.reference) {
        ch_ref = file(params.reference)
    } else {
        ch_ref = SPADES(ch_trimmed.reads)
    }

    ch_bam = MAPPING(ch_ref, ch_trimmed.reads)

    ch_plot = PLOT_COVERAGE(ch_bam)

    ch_vcf = VARIANT_CALLING(ch_ref, ch_bam)

    publish:
    raw_qc      = ch_raw_qc
    trimmed     = ch_trimmed.reads
    trimmed_qc  = ch_trim_qc
    reference   = ch_ref
    bam         = ch_bam
    plot        = ch_plot
    vcf         = ch_vcf
}

output {
    raw_qc      { path "qc/raw" }
    trimmed     { path "trimmed_reads" }
    trimmed_qc  { path "qc/trimmed" }
    reference   { path "reference_genome" }
    bam         { path "alignment" }
    plot        { path "plots" }
    vcf         { path "variants" }
}