# Running_DeepVariant

Hola! Hi!

This is just a small repository in which I add my 3 .sbatch scripts I use for calling variants with [DeepVariant](https://github.com/google/deepvariant), rather from [longreads](https://github.com/Luna-san-2911/DeepVariant---Easy-mode/blob/main/deepvariant_longread.sbatch), [shortreads](https://github.com/Luna-san-2911/DeepVariant---Easy-mode/blob/main/deepvariant_shortread.sbatch), or multiple shortreads samples.

# Issues I encountered

1. I got multiple times segmentation_fault error. This was given that deepvariant stores multiple files in a temporary directory and the temporary directory was at my home directory, which only had 20G of mem. Due to this, the updated script in the repository specifies the path of the tmp directory were there is enough space.
2. DeepVariant takes a while in variant calling, if possible increase shards to 64
3. Be aware that DeepVariant is RAM demanding too. Calling varianst for 1 long read sample used nearly 200G
4. You must know the nature of your sequencing data as you have to specify --model_type . In case you have whole-genome-sequencing do WGS and in case you have PacBio HiFi long reads do PACBIO
