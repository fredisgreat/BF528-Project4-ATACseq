#!/usr/bin/env nextflow

process SAMTOOLS_REMOVEMITO {
    label 'process_medium'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample), path(bam_sorted)

    output:
    tuple val(sample), path("*.noMT.bam"), emit: noMT

    shell:
    """ 
    samtools view -h $bam_sorted | grep -v -w "chrM" | samtools view -b -o ${sample}.noMT.bam
    """
}