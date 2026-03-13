# DeepVariant---Easy-mode

Hola! Hi!

This is just a small repository in which I add my 2 .sbatch scripts I use for calling variants with [DeepVariant](https://github.com/google/deepvariant), rather from [longreads](https://github.com/Luna-san-2911/DeepVariant---Easy-mode/blob/main/deepvariant_longread.sbatch) or [shortreads](https://github.com/Luna-san-2911/DeepVariant---Easy-mode/blob/main/deepvariant_shortread.sbatch).

# Issues I encountered

1. I got multiple times segmentation_fault error. This was given that deepvariant stores multiple files in a temporary directory and the temporary directory was at my home directory, which only had 20G of mem. Due to this, the updated script in the repository specifies the path of the tmp directory were there is enough space.
