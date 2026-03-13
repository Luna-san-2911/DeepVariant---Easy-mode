#!/bin/bash -l
#SBATCH -J calling_variants_longread
#SBATCH --output=calling_variants_longread-%j.output
#SBATCH --error=calling_variants_longread-%j.error
#SBATCH -t 120:00:00
#SBATCH --partition=bmh
#SBATCH --mail-type=ALL
#SBATCH --mail-user=plunarodriguez@ucdavis.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=200G

set -euo pipefail
echo "Starting at: $(date)"

BIN_VERSION="1.6.1"

REF=/group/gmonroegrp2/chaehee/Pablo/pistachio/genome_sequence/Pvera_Kerman_RefGen_v1.fasta
READS=/group/gmonroegrp2/chaehee/Pablo/UCB1_hybridization/02_whatshap/01_align_reads/Patl.filtered.sorted.bam
OUTDIR=/group/gmonroegrp2/chaehee/Pablo/UCB1_hybridization/02_whatshap/02_call_variants

# Use node-local scratch
TMPROOT=/tmp/$USER/deepvariant_${SLURM_JOB_ID:-$$}

# Create directories
mkdir -p ${OUTDIR}
mkdir -p ${TMPROOT}

# Redirect caches and temp files
export TMPDIR=${TMPROOT}
export APPTAINER_CACHEDIR=${TMPROOT}/apptainer_cache
export XDG_CACHE_HOME=${TMPROOT}/.cache

mkdir -p ${APPTAINER_CACHEDIR}
mkdir -p ${XDG_CACHE_HOME}

# Prepare output names
PRE=$(basename "$READS" .bam)
OUT=${PRE}_deepvariant

# Load apptainer
module load apptainer/latest

echo "Running DeepVariant (PacBio mode)"
echo "Temporary files stored in: ${TMPROOT}"

apptainer exec \
  --bind /group/gmonroegrp2:/group/gmonroegrp2 \
  --bind ${TMPROOT}:${TMPROOT} \
  --bind /usr/lib/locale \
  --env TMPDIR=${TMPDIR} \
  --env XDG_CACHE_HOME=${XDG_CACHE_HOME} \
  docker://google/deepvariant:${BIN_VERSION} \
  /opt/deepvariant/bin/run_deepvariant \
    --model_type PACBIO \
    --ref ${REF} \
    --reads ${READS} \
    --make_examples_extra_args="include_med_dp=true,max_reads_per_partition=150" \
    --output_vcf ${OUTDIR}/${OUT}.vcf.gz \
    --output_gvcf ${OUTDIR}/${OUT}.gvcf.gz \
    --num_shards 4

echo "DeepVariant finished."
echo "Outputs in ${OUTDIR}"
