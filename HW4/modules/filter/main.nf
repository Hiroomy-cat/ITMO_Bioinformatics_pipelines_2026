process FILTER_VARIANTS {

    tag "$vcf"

    input:
    path vcf

    output:
    path "${vcf.simpleName}.filtered.vcf"

    stub:
    """
    touch ${vcf.simpleName}.filtered.vcf
    """

    script:
    """
    bcftools filter -i 'QUAL>20' $vcf -o ${vcf.simpleName}.filtered.vcf
    """
}