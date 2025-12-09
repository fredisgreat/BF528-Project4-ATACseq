#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
    label 'process_low'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    path(bed_intersect)
    path(blacklist)

    output:
    path("repr_peaks_filtered.bed")

    script:
    """
    bedtools subtract -a $bed_intersect -b $blacklist > repr_peaks_filtered.bed
    
    """

    stub:
    """
    touch repr_peaks_filtered.bed
    """
}