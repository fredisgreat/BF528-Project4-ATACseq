include {DOWNLOAD_FASTQ} from './modules/download_fastq'
include {FASTQC} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_REMOVEMITO} from './modules/samtools_removeMito'
include {FINDPEAKS} from './modules/macs3_callpeaks'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {MULTIQC} from './modules/multiqc'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {ANNOTATE} from './modules/homer_annotatepeaks'
include {FIND_MOTIFS_GENOME} from './modules/homer_findmotifsgenome'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'
include {COMPUTEMATRIX} from './modules/deeptools_computematrix'
include {PLOTHEATMAP} from './modules/deeptools_plotheatmap'

workflow {

Channel.fromPath(params.samplesheet)
    .splitCsv(header:true)
    .map { row -> tuple(row.sample, row.ftp) }
    .set { ftp_download_ch }

DOWNLOAD_FASTQ(ftp_download_ch)
FASTQC(DOWNLOAD_FASTQ.out)
TRIM(DOWNLOAD_FASTQ.out)
BOWTIE2_BUILD(params.genome)
BOWTIE2_ALIGN(TRIM.out.trimmed, BOWTIE2_BUILD.out)
SAMTOOLS_SORT(BOWTIE2_ALIGN.out)
SAMTOOLS_IDX(SAMTOOLS_SORT.out)
SAMTOOLS_REMOVEMITO(SAMTOOLS_IDX.out)
SAMTOOLS_FLAGSTAT(SAMTOOLS_REMOVEMITO.out)

fastqc_zip = FASTQC.out.zip.map { name, zip -> tuple(name, zip) }
trim_log = TRIM.out.log.map { name, log -> tuple(name, log) }
flagstat_out = SAMTOOLS_FLAGSTAT.out.map { name, flag -> tuple(name, flag) }

multiqc_ch = fastqc_zip
    .mix(trim_log)
    .mix(flagstat_out)
    .map { name, file -> file }
    .collect()

MULTIQC(multiqc_ch)

FINDPEAKS(SAMTOOLS_REMOVEMITO.out)

Channel.of(
    ['DC1', file('DC1_significant_peaks.bed')],
    ['DC2', file('DC2_significant_peaks.bed')]
).set { peaks_ch }

ANNOTATE(peaks_ch, params.genome, params.gtf)
FIND_MOTIFS_GENOME(peaks_ch, params.genome)

BAMCOVERAGE(SAMTOOLS_REMOVEMITO.out)
COMPUTEMATRIX(BAMCOVERAGE.out, params.ucsc_tss)

bigwig_ch = BAMCOVERAGE.out.bigwig
    .map { name, bw ->
        def celltype = name.toUpperCase().contains("DC1") ? "DC1" : "DC2"
        tuple(celltype, bw)
    }

bigwig_grouped_ch = bigwig_ch.groupTuple()

bed_grouped_ch = Channel.fromPath("*figure.bed")
    .map { bedfile ->
        def base = bedfile.baseName.toUpperCase()
        def parts = base.split('_')
        def celltype = parts[0]
        def key = "${parts[0]}_${parts[1]}"
        tuple(key, bedfile)
    }

bed_by_celltype_ch = bed_grouped_ch
    .map { key, bedfile ->
        def celltype = key.split('_')[0]
        tuple(celltype, bedfile)
    }
    .groupTuple()

matrix_input_ch = bed_by_celltype_ch
    .join(bigwig_grouped_ch)
    .map { celltype, bedfiles, bigwigs ->
        tuple(celltype, bedfiles, bigwigs)
    }
    .view()

PLOTHEATMAP(matrix_input_ch)

}