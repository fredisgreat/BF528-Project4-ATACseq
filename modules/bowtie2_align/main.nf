#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/bowtie2:latest'

    input:
    tuple val(sample_id), path(trimmed)
    tuple val(genome), path(index)

    output:
    tuple val(sample_id), path("${sample_id}.bam")

    shell:
    """ 
    bowtie2 -p 8 --very-sensitive -x bowtie2_build/${genome} -U $trimmed | samtools view -bS - > ${sample_id}.bam
    """

}