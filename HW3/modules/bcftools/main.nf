process BCFTOOLS_CALL {
    tag "$bam"

    input:
    path ref
    path bam

    output:
    path "${bam.simpleName}.vcf"

    conda "bioconda::bcftools=1.17"

    script:
    """
    bcftools mpileup -f $ref $bam | \
    bcftools call -mv -Ov -o ${bam.simpleName}.vcf
    """
}