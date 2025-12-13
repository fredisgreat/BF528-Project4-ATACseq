#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_high'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(bigwig)
    path(bed)

    output:
    path('*_matrix.gz'), emit: matrix
    path('*_matrix.tab'), emit: table

    script:
    """
    computeMatrix reference-point --referencePoint TSS -S $bigwig -R $bed -b 2000 -a 2000 -o ${sample_id}_TSS_matrix.gz --outFileNameMatrix ${sample_id}_TSS_matrix.tab -p $task.cpus
    """
}