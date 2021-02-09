# cellranger-nf
A Nextflow wrapper for 10X Cellranger to wrangle the 10,000+ output files per sample. 

# Usage

Point `cellranger-nf` at a directory containing the output of 10X Cellranger `mkfastq`.  
Subdirectories will be named with a unique identifier, which will be used as the sample ID.  

```
nextflow run /cellranger-nf/main.nf --fastq [full path] --reference [mouse/human/full path] --ncells [int]
```

## Required
+ `--fastq`
    + Full path to directory containing output of Cellranger `mkfastq`. `cellranger count` will not accept relative path
+ `--reference`
    + Either keywords `mosue`, `human`, or full path to 10X formatted reference. `cellranger count` will not accept relative path

+ `--ncells`
    + How many cells to expect. Int. Applied to all samples.

## Options
+ `--out`
    + Directory to publish results. Default is `./`

## Execution
Currently set up for `-profile slurm` or `-profile local`
10X `cellranger count` requires 120 GB of memory for each sample.
Currently configured to use 28 CPUs for each sample.

## Ouput
`cellranger-nf` will publish the contents of `/outs/` as well as `_cmdline`, `_versions`, and `_log` to `--out/[sample id]/`.
The thousands upon thousands of other logs and tmp files are NOT published.
