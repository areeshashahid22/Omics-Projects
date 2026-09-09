# 🧬 AI-Driven Peptide Binder Design Against Nipah Virus Receptor-Binding Protein

### Capstone Project — Module 3 | Foundations of Protein Language & AI

**Omics Summer School 2026 | Quaid-i-Azam University, Islamabad**

---

## 📌 Overview

This project demonstrates an end-to-end **AI-driven computational protein design pipeline** for generating candidate peptide binders against the **Nipah virus (NiV) receptor-binding protein (G protein)**.

Nipah virus is an important zoonotic pathogen and a WHO priority pathogen. Its receptor-binding protein mediates interaction with host-cell receptors, primarily **Ephrin-B2 and Ephrin-B3**. Computationally targeting this interaction provides a useful case study for applying modern protein-language models, structure prediction, generative protein design, inverse folding, and structure-based validation.

Starting from a **602-residue amino acid sequence**, the project follows a computational workflow consisting of:

1. Target structure prediction
2. Binding-pocket identification
3. Peptide-backbone generation
4. Inverse folding and sequence generation
5. Structure prediction and validation
6. Candidate ranking

> **Important:** The resulting peptides are computationally generated candidates. High structural-confidence scores do not by themselves demonstrate experimental binding, antiviral activity, stability, or therapeutic efficacy.

---

## 🎯 Objectives

The major objectives of this project were to:

- Predict the 3D structure of the Nipah virus G protein using AI-based structure prediction.
- Identify potential binding pockets and hotspot residues on the target protein.
- Generate novel peptide binder backbones using generative protein-design methods.
- Generate compatible amino-acid sequences using inverse-folding approaches.
- Validate candidate structures using structure-prediction confidence metrics.
- Rank the computational candidates and identify the **Top 10 peptide designs** for further investigation.

---

# 🦠 Target Protein

| Property | Details |
|---|---|
| **Virus** | Nipah virus (NiV) |
| **Protein** | Receptor-binding protein / G protein / Attachment glycoprotein |
| **PDB Reference** | [2VSM](https://www.rcsb.org/structure/2VSM) |
| **Sequence Length** | 602 amino acids |
| **Host Receptors** | Ephrin-B2, Ephrin-B3 |
| **Predicted pLDDT** | 0.67 |
| **Predicted pTM** | 0.65 |

### Target Sequence

```text
MPAENKKVRFENTTSDKGKIPSKVIKSYYGTMDIKKINEGLLDSKILSAFNTVIALLGSI
VIIVMNIMIIQQNYTRSTDNQAVIKDALQGIQQQQIKGLADKIGTEIGPKVSLIDTSSTI
TIPANIGLLGSKISQSTASINENVNEKCKFTLPPLKIHECNISCPNPLPFREYRPQTEGV
SNLVGLPNNICLQKTSNQILKPKLISYTLPVVGQSGTCITDPLLAMDEGYFAYSHLERI
GSCSRGVSKQRIIGVGEVLDRGDEVPSLFMTNVWTPPNPNTVYHCSAVYNNNEFYYVLC
AVSTVGDPILNSTYWSGSLMMTRLAHKPKSNGGGYNQHQLALRSIEKGRYDKVMPYGPSG
IKQGDTLYFPAVGFLVRTEFKYNDSNCPITKCQYSKPENCRLSMGIRPNSHYILRSGLL
LKYNLSDGENPKVVFIEISDQRLSIGSPSKKIYDSLGQPVFYQASFSWDTMIKFGDVLT
VNPLVVNWRNNVISRPGQSQCPRFNTCPEICWEGVYNDAFLIDRINWISAGVFLDSNQTA
ENPVFTVFKDNEILYRAQLASEDTNAQKTITNCFLLKNKIWCISLVEIIYDTGDNVIRPK
LFAVKIPEQCT
🔬 Computational Design Pipeline
                    TARGET SEQUENCE
                          │
                          ▼
                ┌──────────────────┐
                │     ESMFold2     │
                │     Step 1       │
                └────────┬─────────┘
                         │
                         ▼
                 3D Target Structure
                  pLDDT: 0.67
                   pTM: 0.65
                         │
                         ▼
                ┌──────────────────┐
                │     fpocket      │
                │     Step 2       │
                └────────┬─────────┘
                         │
                         ▼
                 Binding Pockets
                  22 pockets
                         │
                         ▼
                ┌──────────────────┐
                │   RFdiffusion    │
                │     Step 3       │
                └────────┬─────────┘
                         │
                         ▼
                8 Peptide Backbones
                         │
                         ▼
                ┌──────────────────┐
                │   ProteinMPNN    │
                │     Step 4       │
                └────────┬─────────┘
                         │
                         ▼
               32 Candidate Sequences
                         │
                         ▼
                ┌──────────────────┐
                │    AlphaFold2    │
                │     Step 5       │
                └────────┬─────────┘
                         │
                         ▼
            pLDDT / pTM / PAE / RMSD
                         │
                         ▼
                ┌──────────────────┐
                │  Candidate       │
                │    Ranking       │
                │     Step 6       │
                └────────┬─────────┘
                         │
                         ▼
                TOP 10 COMPUTATIONAL
                    CANDIDATES

📊 Score Interpretation
| Metric | Meaning | Interpretation |
|---|---|---|
| **pLDDT** | Predicted local structural confidence | Higher is better |
| **pTM** | Predicted confidence in overall topology | Higher is better |
| **PAE** | Predicted alignment error / positional uncertainty | Lower is better |
| **RMSD** | Structural deviation between compared structures | Lower generally indicates greater similarity |

Important interpretation
The ranking in this project is primarily a structural-confidence ranking.
A high pLDDT score should not be interpreted as direct evidence of:
- strong target binding,
- antiviral activity,
- biological efficacy,
- therapeutic potential,
- cellular activity, or
- experimental stability.
Experimental validation and additional computational analyses would be required before making such conclusions.

🛠️ Tools & Resources
| Tool | Purpose | Access |
|---|---|---|
| **ESMFold2** | Protein structure prediction | [biohub.ai](https://biohub.ai/tools/fold) |
| **fpocket** | Binding-pocket detection | [RPBS Web Server](https://mobyle2.rpbs.univ-paris-diderot.fr) |
| **RFdiffusion** | Peptide-backbone generation | Google Colab |
| **ProteinMPNN** | Inverse folding / sequence design | Google Colab |
| **AlphaFold2** | Structure prediction and validation | Google Colab |
| **RCSB PDB** | Structural reference for PDB 2VSM | [RCSB PDB](https://www.rcsb.org/structure/2VSM) |
| **Proteins.Plus** | Complementary pocket analysis | [Proteins.Plus](https://proteins.plus) |


🔭 Future Directions
Future work could include additional computational characterization of the prioritized candidates, such as:
- Detailed peptide–target interface analysis
- Comparison of predicted binding interfaces
- Molecular-dynamics-based structural assessment
- Binding-energy estimation
- Sequence and structural diversity analysis
- Assessment of peptide stability
- Experimental validation of the highest-priority candidates
These analyses would help distinguish candidates that are merely structurally plausible from those that may warrant further investigation.

Open-source resources
- ColabDesign — Sergey Ovchinnikov
- RFdiffusion — Baker Lab
- ESM — Meta AI Research

👩‍💻 Author
Areesha Shahid
BS Bioinformatics
Quaid-i-Azam University, Islamabad



