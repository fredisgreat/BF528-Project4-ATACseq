#!/usr/bin/env nextflow

process ANNOTATE {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(celltype), path(bed)
    path(genome)
    path(gtf)

    output:
    path("*_annotated_peaks.txt")

    script:
    """
    annotatePeaks.pl $bed $genome -gtf $gtf > ${celltype}_annotated_peaks.txt
    
    """
}



