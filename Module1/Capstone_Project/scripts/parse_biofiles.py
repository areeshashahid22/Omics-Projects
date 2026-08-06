from pathlib import Path
from collections import Counter

import pandas as pd
from Bio import SeqIO


# --------------------------------------------------
# 1. Define project paths
# --------------------------------------------------

PROJECT_DIR = Path(__file__).resolve().parents[1]

RAW_DIR = PROJECT_DIR / "raw"
RESULTS_DIR = PROJECT_DIR / "results"

RESULTS_DIR.mkdir(exist_ok=True)


# --------------------------------------------------
# 2. Parse FASTA
# --------------------------------------------------

fasta_file = RAW_DIR / "genes.fasta"

fasta_results = []

for record in SeqIO.parse(fasta_file, "fasta"):

    sequence = str(record.seq).upper()

    sequence_length = len(sequence)

    if sequence_length > 0:

        gc_percent = (
            (sequence.count("G") + sequence.count("C"))
            / sequence_length
        ) * 100

    else:

        gc_percent = 0

    fasta_results.append(
        {
            "sequence_id": record.id,
            "length": sequence_length,
            "GC_percent": gc_percent
        }
    )


fasta_df = pd.DataFrame(fasta_results)

fasta_df.to_csv(
    RESULTS_DIR / "fasta_summary.csv",
    index=False
)


# --------------------------------------------------
# 3. Parse FASTQ
# --------------------------------------------------

fastq_file = RAW_DIR / "sample_reads.fastq"

read_count = 0

all_mean_qualities = []

qc_pass_count = 0

QUALITY_THRESHOLD = 20


for record in SeqIO.parse(fastq_file, "fastq"):

    read_count += 1

    qualities = record.letter_annotations["phred_quality"]

    mean_quality = sum(qualities) / len(qualities)

    all_mean_qualities.append(mean_quality)

    if mean_quality >= QUALITY_THRESHOLD:

        qc_pass_count += 1


overall_mean_quality = (
    sum(all_mean_qualities)
    / len(all_mean_qualities)
    if all_mean_qualities
    else 0
)


with open(
    RESULTS_DIR / "fastq_summary.txt",
    "w"
) as output:

    output.write(
        "FASTQ SUMMARY\n"
    )

    output.write(
        "=============\n"
    )

    output.write(
        f"Total reads: {read_count}\n"
    )

    output.write(
        f"Mean read quality: "
        f"{overall_mean_quality:.2f}\n"
    )

    output.write(
        f"QC threshold: "
        f"{QUALITY_THRESHOLD}\n"
    )

    output.write(
        f"QC passing reads: "
        f"{qc_pass_count}\n"
    )


# --------------------------------------------------
# 4. Parse GFF3
# --------------------------------------------------

gff_file = RAW_DIR / "annotations.gff3"

feature_counts = Counter()


with open(gff_file) as input_file:

    for line in input_file:

        if line.startswith("#"):

            continue

        line = line.strip()

        if not line:

            continue

        columns = line.split("\t")

        if len(columns) >= 3:

            feature_type = columns[2]

            feature_counts[
                feature_type
            ] += 1


gff_df = pd.DataFrame(
    feature_counts.items(),
    columns=[
        "feature_type",
        "count"
    ]
)

gff_df.to_csv(
    RESULTS_DIR / "gff3_feature_counts.csv",
    index=False
)


# --------------------------------------------------
# 5. Parse VCF
# --------------------------------------------------

vcf_file = RAW_DIR / "variants.vcf"

total_variants = 0

snp_count = 0

indel_count = 0


with open(vcf_file) as input_file:

    for line in input_file:

        if line.startswith("#"):

            continue

        columns = line.strip().split("\t")

        if len(columns) < 5:

            continue

        reference = columns[3]

        alternate = columns[4]

        total_variants += 1

        if (
            len(reference) == 1
            and len(alternate) == 1
        ):

            snp_count += 1

        else:

            indel_count += 1


with open(
    RESULTS_DIR / "vcf_summary.txt",
    "w"
) as output:

    output.write(
        "VCF SUMMARY\n"
    )

    output.write(
        "===========\n"
    )

    output.write(
        f"Total variants: "
        f"{total_variants}\n"
    )

    output.write(
        f"SNPs: "
        f"{snp_count}\n"
    )

    output.write(
        f"Indels/other variants: "
        f"{indel_count}\n"
    )


# --------------------------------------------------
# 6. Print completion message
# --------------------------------------------------

print(
    "Python parsing completed."
)

print(
    f"Results saved in: "
    f"{RESULTS_DIR}"
)
