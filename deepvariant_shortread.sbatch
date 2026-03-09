#!/bin/bash -l
#SBATCH -J calling_variants_shortread
#SBATCH --output=calling_variants_shortread-%j.output
#SBATCH --error=calling_variants_shortread-%j.error
#SBATCH -t 120:00:00
#SBATCH --partition=bmh
#SBATCH --mail-type=ALL
#SBATCH --mail-user=plunarodriguez@ucdavis.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G

set -euo pipefail
echo "Starting at: $(date)"

# Variables
BIN_VERSION="1.6.1"  # DeepVariant version, yes they are newer versions, but this is the one that works
REF=/group/gmonroegrp2/chaehee/Pablo/pistachio/genome_sequence/Pvera_Kerman_RefGen_v1.fasta  # Reference FASTA
READS=/group/gmonroegrp2/chaehee/Pablo/UCB1_hybridization/02_whatshap/01_align_reads/R1_B1_C6_S6.filtered.sorted.bam  # Input BAM, in my case I already siltered, sorted and index
OUTDIR=/group/gmonroegrp2/chaehee/Pablo/UCB1_hybridization/02_whatshap/02_call_variants  # Output directory

# Prepare output
PRE=$(basename "$READS" | sed 's/.bam//')  # Remove .bam for prefix, so my output prefix would be R1_B1_C6_S6.filtered.sorted
OUT=${PRE}_deepvariant

# Load module
module load apptainer

# Run DeepVariant
# Here there are some previous assumptions
# /group/gmonroegrp2/ is the directory where I have my input and output files
# docker is used to run deepvariant, be aware to have it installed before running this script, as well as apptainer
# model_type is WGS as I had short read data of whole genome sequencing
# num_shards sets the number of threads to use, DeepVariant is too much RAM demanding so think it twice before inscreasing the number of shards as you may need more RAM

singularity exec \
  --bind /group/gmonroegrp2:/group/gmonroegrp2 \
  --bind /usr/lib/locale/ \
  docker://google/deepvariant:${BIN_VERSION} \
  /opt/deepvariant/bin/run_deepvariant \
    --model_type WGS \
    --ref ${REF} \
    --reads ${READS} \
    --make_examples_extra_args="include_med_dp=true" \
    --output_vcf ${OUTDIR}/${OUT}.vcf.gz \
    --output_gvcf ${OUTDIR}/${OUT}.gvcf.gz \
    --num_shards 8

echo "DeepVariant finished. Outputs are in $OUTDIR"
