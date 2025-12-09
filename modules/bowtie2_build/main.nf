#!/usr/bin/env nextflow

process BOWTIE2_BUILD {
    label 'process_high'
    container 'ghcr.io/bf528/bowtie2:latest'
    publishDir params.outdir, mode:'copy'

    input:
    path(genome)

    output:
    tuple val("${genome.baseName}"), path("bowtie2_build/")

    shell:
    """ 
    mkdir bowtie2_build
    bowtie2-build --threads $task.cpus $genome bowtie2_build/${genome.baseName}
    """

    stub:
    """
    mkdir bowtie2_build
    """
}