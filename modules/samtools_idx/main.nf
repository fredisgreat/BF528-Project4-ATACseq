#!/usr/bin/env nextflow

process SAMTOOLS_IDX {
    label 'process_medium'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample), path(bam_noMT)

    output:
    tuple val(sample), path(bam_noMT), path("*.bai"), emit: index

    shell:
    """ 
    samtools index $bam_noMT
    """
}