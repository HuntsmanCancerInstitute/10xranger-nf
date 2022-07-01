# 10xranger-nf
A Nextflow wrapper for 10X Cellranger  and spaceranger to wrangle the 10,000+ output files per sample. 
Provides access to `cellranger count`, `cellranger-atac`, and `cellranger vdj` with `--mode` parameter

# Usage
Point `10xranger-nf` at a directory containing the output of 10X Cellranger `mkfastq`.  
Subdirectories will be named with a unique identifier, which will be used as the sample ID.  

```
nextflow run 10xranger-nf --fastq [full path] --reference [mouse/human/full path]
```

By default `10xranger-nf` will run in its Docker container via Singularity. See Dockerfile for full details.  
Singularity will pull the container automatically on execution.  

## Required
+ `--fastq`
    + Full path to directory containing output of Cellranger `mkfastq`. 10X software will not accept relative paths.
+ `--reference`
    + Either keywords `mosue`, `human`, or full path to 10X formatted reference. 10X software will not accept relative paths.

## Options
+ `--out`
    + Directory to publish results. Default is `./`
+ `--mode`
    + Run count for standard 3/5 prime libraries, ATAC, or VDJ. Default is 3/5 prime.
+ `--chemistry`
    + Chemistry version for 3/5 prime libraries. Default is `auto`. Not valid for VJD or ATAC.
    + Allowed: threeprime, fiveprime, SC3Pv2, SC3Pv3, SC5P-PE, SC5P-R2, SC3Pv1

## Execution
Standard profile submits jobs to `slurm` scheduler and each runs inside a Singularity.   
10X software requires 120 GB of memory for each sample.  
Currently configured to use 28 CPUs for each sample.  

## Ouput
`10xranger-nf` will publish the contents of `/outs/` to `--out/[sample id]/`. 
Nextflow timeline, report, and trace are published to `${params.out}/logs`

The thousands upon thousands of other logs and tmp files are NOT published.
## Versions
`10xranger-nf` runs in a Docker container with:
`cellranger-7.0.0` released 17 May 2022  
`cellranger-atac-2.1.0` released 4 Apr 2022  
`cellranger-arc-2.0.1` release 3 Feb 2022  
`spaceranger-1.3.1` release 1 Nov 2021

`nextflow` version 20.10.0

+ 10X provided references are large and are NOT in the Docker container.
