nextflow.enable.dsl=2

include { FASTP; SPADES; PLOT_COVERAGE } from './modules/processes.nf'
include { MAPPING as MAPPING_VIRUS } from './modules/processes.nf'
include { MAPPING as MAPPING_BACTERIA } from './modules/processes.nf'
include { FASTQC as FASTQC_RAW } from './modules/processes.nf'
include { FASTQC as FASTQC_TRIM } from './modules/processes.nf'
include { BCFTOOLS_CALL } from './modules/bcftools/main.nf'
include { FILTER_VARIANTS } from './modules/filter/main.nf'

workflow {

    samples_ch = Channel
        .fromPath("samples.csv")
        .splitCsv(header: true)
        .map { row ->
            tuple(row.sample_id, row.group, file(row.reads_1), file(row.reads_2))
        }

    reads_ch = samples_ch.map { id, group, r1, r2 ->
        tuple(id, r1, r2)
    }


    ch_raw_qc  = FASTQC_RAW(reads_ch.map { id, r1, r2 -> tuple(id, [r1, r2]) })
    ch_trimmed = FASTP(reads_ch.map { id, r1, r2 -> tuple(id, [r1, r2]) })
    ch_trim_qc = FASTQC_TRIM(ch_trimmed.reads)


    group_ch = samples_ch.map { id, group, r1, r2 -> tuple(id, group) }

    trimmed_with_group = ch_trimmed.reads
        .map { id, reads -> tuple(id, reads[0], reads[1]) }
        .join(group_ch)


    branched = trimmed_with_group.branch {
        virus: it[3] == 'virus'
        bacteria: it[3] == 'bacteria'
    }

    reads_virus = branched.virus.map { id, r1, r2, group -> tuple(id, [r1, r2]) }
    reads_bacteria = branched.bacteria.map { id, r1, r2, group -> tuple(id, [r1, r2]) }

    if (params.reference) {
        ch_ref = file(params.reference)
    } else {
        ch_ref = SPADES(ch_trimmed.reads)
    }


    bam_virus = MAPPING_VIRUS(ch_ref, reads_virus)
    bam_bacteria = MAPPING_BACTERIA(ch_ref, reads_bacteria)

    bam_all = bam_virus.mix(bam_bacteria)


    ch_plot = PLOT_COVERAGE(bam_all)


    ch_vcf = BCFTOOLS_CALL(ch_ref, bam_all)


    ch_filtered = FILTER_VARIANTS(ch_vcf)

    // ---------------------------
    // OUTPUTS
    // ---------------------------
    publish:
    raw_qc      = ch_raw_qc
    trimmed     = ch_trimmed.reads
    trimmed_qc  = ch_trim_qc
    reference   = ch_ref
    bam         = bam_all
    plot        = ch_plot
    vcf         = ch_vcf
    filtered    = ch_filtered
}

output {
    raw_qc      { path "qc/raw" }
    trimmed     { path "trimmed_reads" }
    trimmed_qc  { path "qc/trimmed" }
    reference   { path "reference_genome" }
    bam         { path "alignment" }
    plot        { path "plots" }
    vcf         { path "variants" }
    filtered    { path "filtered_variants" }
}