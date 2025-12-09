#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    label 'process_low'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample_id), path(bam_sorted)

    output:
    tuple val(sample_id), path("*.txt")

    shell:
    """ 
    samtools flagstat $bam_sorted > ${sample_id}_flagstat.txt
    """

    stub:
    """
    touch ${sample_id}_flagstat.txt
    """
}