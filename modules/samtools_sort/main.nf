#!/usr/bin/env nextflow

process SAMTOOLS_SORT {
    label 'process_medium'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path("*.sorted.bam"), emit: sorted

    shell:
    """ 
    samtools sort -@ $task.cpus $bam > ${bam.baseName}.sorted.bam
    """

    stub:
    """
    touch ${bam.baseName}.sorted.bam
    """
}