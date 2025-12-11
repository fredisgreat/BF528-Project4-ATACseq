#!/usr/bin/env nextflow

process SAMTOOLS_REMOVEMITO {
    label 'process_medium'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample), path(bam), path(bai)

    output:
    tuple val(sample), path("*.sorted.bam"), path("*.bai"), emit: noMT

    shell:
    """ 
    samtools idxstats $bam | cut -f1 | grep -v "chrM" > chroms.txt
    xargs samtools view -b $bam -o ${sample}.noMT.bam < chroms.txt
    samtools sort -@ $task.cpus ${sample}.noMT.bam -o ${sample}.noMT.sorted.bam
    samtools index ${sample}.noMT.sorted.bam
    """
}