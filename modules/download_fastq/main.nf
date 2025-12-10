#!/usr/bin/env nextflow

process DOWNLOAD_FASTQ {
    label 'process_low'
    container 'ghcr.io/bf528/samtools:latest'

    input:
    tuple val(sample), val(url)

    output:
    tuple val(sample), path('*fastq.gz')

    script:
    """
    wget $url
    """
    
}
