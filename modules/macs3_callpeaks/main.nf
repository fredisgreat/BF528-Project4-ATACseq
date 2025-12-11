#!/usr/bin/env nextflow

process FINDPEAKS {
    label 'process_high'
    container 'ghcr.io/bf528/macs3:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample), path(bam), path(bai)

    output:
    path("*_peaks.narrowPeak")

    shell:
    """
    macs3 callpeak -t $bam -f BAM -g mm -n $sample -B --nomodel --keep-dup auto --extsize 147 -q 0.01
    """
}