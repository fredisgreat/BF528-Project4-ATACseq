#!/usr/bin/env nextflow

process TAGDIR {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path("*_tags")

    shell:
    """ 
    mkdir ${sample_id}_tags
    makeTagDirectory ${sample_id}_tags $bam
    """

    stub:
    """
    mkdir ${sample_id}_tags
    """
}


