#!/usr/bin/env nextflow

process MACS2_CALLPEAKS {
    label 'process_high'
    container 'ghcr.io/bf528/macs2:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample), path(bam), path(bai)

    output:
    tuple val(sample), path("*_peaks.narrowPeak"), emit: peaks

    shell:
    """
    macs2 callpeak -t $bam -f BAM -g mm -n ${sample} --outdir . --nomodel --keep-dup auto --extsize 147
    """
}