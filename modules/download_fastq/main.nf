#!/usr/bin/env nextflow

process DOWNLOAD_FASTQ {
   
    input:
    tuple val(sample), val(url)

    output:
    tuple val(sample), path('*fastq.gz')

    script:
    """
    wget $url
    """
    
}
