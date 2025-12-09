#!/usr/bin/env nextflow

process FINDPEAKS {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample_id), path(input), path(ip)

    output:
    tuple val(sample_id), path("*_peaks.txt")

    script:
    """
    findPeaks $ip -style factor -i $input -o ${sample_id}_peaks.txt
    """

    stub:
    """
    touch ${sample_id}_peaks.txt
    """
}


