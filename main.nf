nextflow.enable.dsl=2

params.help = false
if (params.help) {
    log.info"""
    ------------------------------------------------------
    cellranger_count-nf: a workflow for CellRanger count
    ======================================================

    Required arguments:
    -------------------

    --reference         Path to reference files in 10X format.
                        Allowed: "mouse", "human", or FULL path.

    --ncells            The number of cells to expect. Int.

    --fastq             Directory that contains the fastqs. FULL path.


    Optional arguments:
    -------------------
    --out               Directory to publish results.
                        Default is directory where workflow is started.
   
    --mode              Run count for standard libraries, ATAC or VDJ. Default is standard.
                        Allowed: atac, vjd

    --chemistry         10X library chemistry version. Str. Default is auto.
                        Allowed: threeprime, fiveprime, SC3Pv2, SC3Pv3, SC5P-PE, SC5P-R2, SC3Pv1

    ------------------------------------------------------
    """.stripIndent()
    exit 0
}

// set default run mode
params.mode = 'standard'

// Required arguments
params.ncells = false
if ( !params.ncells && params.mode == 'standard' ) { exit 1, "--ncells is not defined" }

params.reference = false
if ( !params.reference ) { exit 1, "--reference is not defined" }

// convert reference keywords to paths in group space
if ( params.reference == "mouse" ) {
    if ( params.mode == "standard" ) {
        reference = "/uufs/chpc.utah.edu/common/PE/hci-bioinformatics1/atlatl/data/Mouse/GRCm38/10x_star/refdata-gex-mm10-2020-A"
    } else if ( params.mode == "atac" ) {
        reference = "/uufs/chpc.utah.edu/common/PE/hci-bioinformatics1/atlatl/data/Mouse/GRCm38/10x_star/refdata-cellranger-atac-mm10-1.2.0"
    } else if ( params.mode == "vdj" ) {
        reference = "/uufs/chpc.utah.edu/common/PE/hci-bioinformatics1/atlatl/data/Mouse/GRCm38/10x_star/refdata-cellranger-vdj-GRCm38-alts-ensembl-5.0.0"
    } else {
        exit 1, "keywords for mode and species do not match"
    }
} else if ( params.reference == "human" ) {
    if ( params.mode == "standard" ) {
        reference = "/uufs/chpc.utah.edu/common/PE/hci-bioinformatics1/atlatl/data/Human/GRCh38/10x_star/refdata-gex-GRCh38-2020-A"
    } else if ( params.mode == "atac" ) {
        reference = "/uufs/chpc.utah.edu/common/PE/hci-bioinformatics1/atlatl/data/Human/GRCh38/10x_star/refdata-cellranger-atac-GRCh38-1.2.0"
    } else if ( params.mode == "vdj" ) {
        reference = "/uufs/chpc.utah.edu/common/PE/hci-bioinformatics1/atlatl/data/Human/GRCh38/10x_star/refdata-cellranger-vdj-GRCh38-alts-ensembl-5.0.0"
    } else {
        exit 1, "keywords for mode and species do not match"
    }    
} else {
    reference = "${params.reference}"
}

// Optional arguments
params.out = "./"
params.chemistry = 'auto'

// Logging
log.info("\n")
log.info("Input directory (--fastq)       :${params.fastq}")
log.info("Reference       (--reference)   :$reference")
log.info("Expect cells    (--ncells)      :${params.ncells}")
log.info("Chemistry       (--chemistry)   :${params.chemistry}")
log.info("Run mode        (--mode)        :${params.mode}")
log.info("Output dir      (--out)         :${params.out}")

// Input channel: each directory is output of cellranger mkfastq
Channel
    .fromPath("${params.fastq}/*", type: 'dir')
    .map { tuple(it.getName(), it) }
    .set { fastqs }

// Run CellRanger Count
process cellranger_count {
  module 'singularity/3.6.4'
  publishDir path: "${params.out}/$id", mode: "copy", saveAs: { "${file(it).getName()}"}

  input:
    path(reference)
    tuple val(id), path('fastq')

  output:
    path("$id/outs/*")
    path("$id/_cmdline")
    path("$id/_versions")
    path("$id/_log")

  script:
    if( params.mode == 'standard' ) {
    """
    cellranger count --id=$id \
                     --fastqs=$fastq \
                     --transcriptome=${reference} \
                     --expect-cells=${params.ncells} \
                     --chemistry=${params.chemistry} \
                     --localcores=28 \
                     --localmem=95
    """
    } else if( params.mode == 'atac' ) {
    """
    cellranger-atac count --id=$id \
                          --fastqs=$fastq \
                          --reference=${reference} \
                          --localcores=28 \
                          --localmem=95
    """
    } else if( params.mode == 'vdj' ) {
    """
    cellranger vdj --id=$id \
                   --fastqs=$fastq\
                   --reference=${reference} \
                   --localcores=28 \
                   --localmem=95
    """
    } else { 
        exit 1, "run mode not assigned correctly. Try --atac, --vdj, or omit" 
    }
}

workflow {
    cellranger_count(reference, fastqs)
}
