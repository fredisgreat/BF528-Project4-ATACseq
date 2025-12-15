# Project 4 Nextflow Template

The data used in this project comes from the paper: "The histone deacetylase HDAC1 controls dendritic cell development and anti-tumor immunity"
Cell Reports (2024) https://www.cell.com/cell-reports/fulltext/S2211-1247(24)00636-3 

From this paper, the data was collected from its GEO accession number: GSE266584. The dataset included single-end ATAC-seq reads from 2 replicates of wildtype (WT) and HDAC-1 knockout (KO) mice across 2 different cell types (cDC1 and cDC2) totaling in 8 samples. 

The deliverables that this project covers is as follows:
1. A Nextflow workflow to perform the ATAC-seq analysis (described below)
2. A README.md file that describes how to run the pipeline
3. An Rmarkdown notebook that contains the analysis code
    - See diffbind.Rmd for the differential chromatin accessibility analysis code
    - See QC Metrics and Figure Recreation.Rmd
4. A report that addresses the project deliverables outlined below (please see Final_Report.ipynb or .html to see the report):
    - A brief discussion (1 paragraph) of the sequencing quality control results and any steps taken to address any identified issues
    - A brief discussion (1 paragraph) of the alignment statistics, and what they mean for your analysis
    - You must produce two ATAC-seq specific QC metrics from the following list: TSS Enrichment Score, Fraction of Reads in Peak (FRiP)
    - Report how many differentially accessible regions your pipeline discovered in each of the two conditions
    - A figure showing the enrichment results of the differentially accessible regions and a few sentences describing what the enrichment reveals
    - A figure showing the motif enrichment results from the differential peaks and a few sentences describing the key motifs found
    - Comment on the success of the reproductions of the panels from the original publication. Do you think the results are consistent with the original publication? What do your results show that is different from the original publication?

In order to run this pipeline, simply run the command to run the pipeline on the SCC: nextflow run main.nf -profile singularity,cluster

This command will automatically:

1. Download the FASTQ files

2. Run FASTQC

3. Trim reads with Trimmomatic

4. Build bowtie2 index and align reads

5. Sort and index BAM files

6. Remove mitochondrial reads

7. Find/Call peaks with MACS3

8. Generate a MultiQC report from FASTQC, Trimmomatic, and Samtools Flagstat

9. Create bigWig files from the indexed BAM files

10. Compute TSS enrichment with deeptools

Once FINDPEAKS has been run, open the Rmarkdown notebook labeled "diffbind.Rmd" and run all the code inside. This code will automatically:
11. Perfrom differential accessibility with DiffBind (edgeR + TMM)

12. Provide ATAC-seq QC metrics

13. Create bed files for downstream analyses

After running through the Rmarkdown notebook, the nextflow workflow can continue with: nextflow run main.nf -profile singularity,cluster

And this will finish the pipeline by running:

14. Annotate peaks with HOMER

15. Find motifs with HOMER

16. Generate a heatmap with deeptools

