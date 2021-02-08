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
                        Accepts "mouse", "human", or FULL path 

    --ncells            The number of cells to expect. Int.

    --fastq             Directory that contains the fastqs. FULL path.


    Optional arguments:
    -------------------
    --out               Directory to publish results
                        Default is directory where workflow is started
    
    ------------------------------------------------------
    """.stripIndent()
    exit 0
}

// Required arguments
params.ncells = false
if ( !params.ncells) { exit 1, "--ncells is not defined" }

params.reference = false
if ( !params.reference ) { exit 1, "--reference is not defined" }

// convert reference keywords to paths in group space
if ( params.reference == "mouse" ) {
    reference = "/uufs/chpc.utah.edu/common/PE/hci-bioinformatics1/atlatl/data/CellRanger/refdata-gex-mm10-2020-A"
} else if ( params.reference == "human" ) {
    reference = "/uufs/chpc.utah.edu/common/PE/hci-bioinformatics1/atlatl/data/CellRanger/refdata-gex-GRCh38-2020-A"
} else {
    reference = params.reference
}

// Optional arguments
params.out = false
if ( !params.out ) { 
    out = "./" 
} else {
    out = "${params.out}"
}

// Logging
log.info("\n")
log.info("Input directory (--fastq)       :${params.fastq}")
log.info("Reference       (--reference)   :$reference")
log.info("Expect cells    (--ncells)      :${params.ncells}")

// Input channel: each directory is output of cellranger mkfastq
Channel
    .fromPath(params.fastq, type: 'dir')
    .map { tuple(it.getName(), it) }
    .set { fastqs }

// Run CellRanger Count
process cellranger_count {
  module 'cellranger/5.0.0'
  publishDir path: "${out}/$id", mode: "copy", saveAs: { "${file(it).getName()}"}

  input:
    path(reference)
    tuple val(id), path('fastq')
    val(ncells)

  output:
    path("$id/outs/*")
    path("$id/_cmdline")
    path("$id/_versions")
    path("$id/_log")

  script:
    """
    cellranger count --id=$id\
                     --fastqs=$fastq\
                     --transcriptome=$reference\
                     --expect-cells=$ncells\
                     --jobmode=local\
                     --localmem=95
    """
}

workflow {
    cellranger_count(reference, fastqs, params.ncells)
}
