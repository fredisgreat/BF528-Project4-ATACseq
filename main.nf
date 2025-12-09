include {DOWNLOAD_FASTQ} from './modules/download_fastq'
include {FASTQC} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'

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

}