#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_high'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path(bed)
    path(genome)

    output:
    path('motifs')

    script:
    """
    mkdir motifs
    findMotifsGenome.pl $bed $genome motifs -p $task.cpus
    """

    stub:
    """
    mkdir motifs
    """
}


