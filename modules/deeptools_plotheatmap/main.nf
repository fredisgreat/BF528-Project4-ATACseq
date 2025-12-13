#!/usr/bin/env nextflow

process PLOTHEATMAP {
    label 'process_high'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(beds), path(bigwigs)

    output:
    path('*center_matrix.gz'), emit: matrix
    path('*heatmap.png'), emit: heatmap

    script:
    """
    computeMatrix reference-point --referencePoint center -S ${bigwigs.join(' ')} -R ${beds.join(' ')} -b 2000 -a 2000 -o ${sample_id}_center_matrix.gz -p $task.cpus
    plotHeatmap -m ${sample_id}_center_matrix.gz -o ${sample_id}_heatmap.png
    """
}