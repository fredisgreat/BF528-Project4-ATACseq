include {DOWNLOAD_FASTQ} from './modules/download_fastq'
include {FASTQC} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'

workflow {

Channel.fromPath("samplesheet.csv")
    .splitCsv(header:true)
    .map { row -> tuple(row.sample, row.ftp) }
    .set { ftp_download_ch }

DOWNLOAD_FASTQ(ftp_download_ch)
FASTQC(DOWNLOAD_FASTQ.out)
TRIM(DOWNLOAD_FASTQ.out)

}