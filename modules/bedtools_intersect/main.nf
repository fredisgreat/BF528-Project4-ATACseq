#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    label 'process_low'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    path(bed_files)

    output:
    path("repr_peaks.bed")

    script:
    """
    bedtools intersect -a ${bed_files[0]} -b ${bed_files[1]} > repr_peaks.bed
    
    """

    stub:
    """
    touch repr_peaks.bed
    """
}