#!/usr/bin/env nextflow

process TRIM {
    label 'process_low'
    container 'ghcr.io/bf528/trimmomatic:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample_id), path(reads)
    val(adapters)

    output:
    tuple val(sample_id), path("*_trim.log"), emit: log
    tuple val(sample_id), path("*_trimmed.fastq.gz"), emit: trimmed

    shell:
    """
    trimmomatic SE -threads $task.cpus -phred33 $reads ${sample_id}_trimmed.fastq.gz ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 -trimlog ${sample_id}_trim.log
    """

    NexteraPE-PE.fa:2:30:10

    stub:
    """
    touch ${sample_id}_trim.log
    touch ${sample_id}_trimmed.fastq.gz
    """
}
