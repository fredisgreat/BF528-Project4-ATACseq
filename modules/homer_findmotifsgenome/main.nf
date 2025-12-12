#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_high'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(celltype), path(bed)
    path(genome)

    output:
    path("motifs_${celltype}")

    script:
    """
    mkdir motifs_${celltype}
    findMotifsGenome.pl $bed $genome motifs_${celltype} -p $task.cpus
    """
}


