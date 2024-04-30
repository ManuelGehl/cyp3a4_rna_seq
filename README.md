# cyp3a4_rna_seq

## Summary

The RNA-seq analysis yielded several key findings that highlight the impact of rifampin on gene expression in human hepatocytes. Through differential expression analysis, a total of 133 genes were identified as significantly upregulated or downregulated in response to rifampin treatment. Among these genes, notable upregulation was observed in the CYP450 family, with CYP3A4 and CYP3A43 demonstrating significant increases in expression. This aligns with the established role of rifampin in inducing drug metabolism pathways.

Gene set enrichment analysis revealed enrichment in terms related to CYP450 enzymes and xenobiotic metabolism, indicating that rifampin activates pathways involved in the metabolism and detoxification of various substances. This observation supports the known function of rifampin in drug metabolism and suggests broader implications for its effects on liver function.

## Introduction

Drug efficacy can vary widely between patients due to differences in individual genotypes. Many drugs are metabolized in the liver and intestine by enzymes that contribute significantly to the observed differences in drug response between individuals. Understanding these differences is critical to optimizing drug efficacy and minimizing adverse effects.

An important class of drug-metabolizing enzymes is the cytochrome P450 (CYP450) family, of which CYP3A4 is particularly important. CYP3A4 is responsible for metabolizing approximately 50% of all prescription drugs, yet its expression can vary widely (5-20 fold) among individuals. Despite this variability, only a few SNPs in the CYP3A4 gene have been identified that could potentially explain the differential expression. This suggests that other factors, such as distal regulatory elements such as enhancers, may play an important role in driving this variability.

In this second part of the project, RNA-seq analysis was used to investigate the effects of rifampin, a well-known antibiotic, on human hepatocytes. Rifampin is commonly used to treat bacterial infections, including tuberculosis, and is known to have potent effects on hepatic metabolism, particularly through the induction of cytochrome P450 (CYP450) enzymes.

## Quality control, trimming & read mapping

Four human hepatocyte samples were used, two treated with DMSO and two treated with rifampin to study the effects of rifampin on gene expression (**Tab. 1**). The `SRAtoolkit` was used to download the corresponding FASTQ files and `FASTQC` was used for quality control. The process was organized as a pipeline in the bash script `download_fastqc_pipe.sh`.

The initial quality check revealed medium quality reads with high adapter content at the 3' ends and prominent poly A tails. To improve quality and mapping rates, Illumina universal adapters and poly-A tails were trimmed using `Cutadapt`. Reads with a quality score below 20 were removed and reads shorter than 50 bases were filtered out (`trimming_pipe.sh`).

This trimming process increased mapping rates by approximately 5% across all samples, although mapping rates still varied between 65% and 80%. 

**Table 1: Overview of the datasets used.**

| Experiment Number | Description |
| ----------------- | ----------- |
| SRR1721275        | Rifampin    |
| SRR1721276        | Rifampin    |
| SRR1721277        | DMSO        |
| SRR1721278        | DMSO        |

## Exploratory data analysis

During the exploratory data analysis, the quantified gene expression data was filtered to exclude genes with fewer than 10 total counts across all samples. This filtering reduced the dataset from 62,749 original genes to 23,845 retained for further analysis. To perform differential expression analysis, the transcript counts were summarized at the gene level using tximeta, creating a `DESeq` dataset. A variance-stabilized version of the dataset was then generated, providing a foundation for clustering and other analyses.

Principal component analysis (PCA) of the 500 most variant genes revealed that the samples clustered based on treatment, indicating that rifampin and DMSO treatments affected gene expression in distinct ways (**Fig. 1**). However, there was also considerable variance within the clusters, particularly between the rifampin samples and even more so between the DMSO samples. This variance between samples suggests that while treatment has a significant impact on gene expression, other factors may also be contributing to the observed patterns. Despite this variance, the PCA results indicate that rifampin treatment induced notable changes in gene expression, suggesting it has a strong impact on the transcriptome.

<br></br>
<img src="figures/pca_500_genes.png" alt="Fig 1" width="500">

**Figure 1: PCA of 500 most variant genes.**
<br></br>


## Differential expression analysis

For differential expression analysis, `DESeq2` was used to identify genes with significant changes in expression. Using an adjusted p-value threshold of 0.1, 128 genes were identified as upregulated (0.54%) and 61 genes as downregulated (0.26%). No outliers were detected, while 5,086 genes (21%) had low counts. Notably, the majority of genes are upregulated in response to rifampin treatment, a trend that has also been corroborated by ChIP-seq analysis (see [part 1](https://github.com/ManuelGehl/cyp3a4_chip_seq) of this project).

Quality checks such as MA plots and exploratory data analysis (EDA) plots indicated that the data were well distributed, although a large proportion of genes still had low counts (**Fig. 2**). The distribution of p-values reflected this, suggesting that many genes were expressed at low levels.

<br></br>
<img src="figures/diagnostic_plots.png" alt="Fig 2" width="500">

**Figure 2: MA plot (top-left), distribution of p-values (top-right) and EDA plots with raw counts (bottom-left) and normalized counts (bottom-right).**
<br></br>

The dataset was then filtered to remove entries with NA in the adjusted p-values, adjusted p-values greater than 0.1, or absolute log2 fold changes less than 1. This resulted in a list of 133 differentially expressed genes that closely matched the 157 genes identified by the authors of the original study. Interestingly, 11 of the 133 differentially expressed genes were from the CYP450 family, the same number as identified in the original study, of which CYP3A4, CYP3A43, CYP2C8, CYP2B6 and CYP3A5 were also found overexpressed in their qPCR results.

<br></br>
<img src=figures/volcano_plot.png width=500)>

**Figure 3: Volcano plot of detected genes.**
<br></br>

Using these 133 differentially expressed genes, a PCA plot was constructed using variance-stabilized transformed (VST) counts. This plot showed that the treated samples clustered together, and the explainable variance between groups decreased significantly from an initial 24% to approximately 4%. This indicated a strong effect of treatment, with much of the remaining variance explained by differences in gene expression induced by rifampin or DMSO treatment.

In the analysis of gene expression changes due to rifampin treatment, several patterns emerged among the most significantly upregulated and downregulated genes (**Fig. 4**). Among the upregulated genes, UDP-glucuronosyltransferase (UGT) UGT2A2 stood out. This enzyme is crucial for phase II biotransformation reactions, where lipophilic substrates are conjugated with glucuronic acid, increasing the water solubility of metabolites, facilitating their excretion through urine or bile. CYP3A4, another highly upregulated gene, is instrumental in metabolizing a wide range of drugs and xenobiotics. Conversely, among the most significantly downregulated genes, there was a notable presence of transcription factors from the zinc finger protein class, including GLI1 and ZNF43. Additionally, the analysis revealed a considerable presence of non-coding RNAs on both sides of the regulation spectrum. This obersation fits to the known role of microRNAs (miRNAs) in regulating genes involved in drug metabolism and the known effect of rifampin on the expression of hepatic miRNAs (Ramamoorthy et al., 2013).

<br></br>
<img src=figures/heatmap.png width=500)>

**Figure 4: Heatmap of the 10 most upregulated and 10 most downregulated genes.**
<br></br>

## Gene set enrichment analysis

Overrepresentation analysis and gene set enrichment analysis (GSEA) were performed using `clusterProfiler` on the differentially expressed genes, focusing on Gene Ontology (GO) and KEGG terms (**Fig. 5**). To provide context for these analyses, the background gene set consisted of all genes detected with at least 10 counts in all four samples. The results showed significant enrichment for terms related to CYP450 enzymes, e.g. steroid metabolism, estrogen metabolism. In addition, terms related to xenobiotic metabolism were also significantly enriched, further emphasizing the relationship between the observed gene expression changes and the cellular response to external compounds. Consistent with the original publication, these enriched terms suggest that rifampin treatment stimulates biological pathways associated with drug metabolism and detoxification, consistent with typical drug response mechanisms. 

<br></br>
<img src=figures/go_gsea.png width=500)>

**Figure 5: Dot plot of GSEA results using GO terms.**
<br></br>

## Comparison with ChIP-seq data 

To identify common genes between the differentially expressed genes and those associated with the rifampin-induced regions (RIRs) identified in [part 1](https://github.com/ManuelGehl/cyp3a4_chip_seq) of the project, these two sets of genes were intersected, and nine genes were found to overlap (**Tab. 2**). Two notable genes within this overlapping set were CYP3A4 and CYP3A43. This finding provides strong evidence that the previously identified RIRs are indeed involved in the upregulation of these enzymes, supporting the idea that these regions play a significant role in the rifampin-induced response.

**Table 2: Overlap of genes associated with rifamin-induced regions and genes differentially expressed.**

| symbol | log2FoldChange | padj          | entrez |
|--------|----------------|--------------|-------|
| ADH1B  | -1.188821      | 3.907979e-07  | 125   |
| FAM72B | -4.297136      | 2.263574e-02  | 653820|
| CYP3A43| 2.451520       | 5.622709e-02  | 64816 |
| NFASC  | 2.122251       | 6.098068e-03  | 23114 |
| GPX2   | 1.077245       | 2.344745e-03  | 2877  |
| MBL2   | 1.331496       | 1.133486e-03  | 4153  |
| RNU2-1 | 1.545826       | 1.036942e-03  | 6066  |
| ALAS1  | 2.050727       | 3.210751e-26  | 211   |
| CYP3A4 | 9.018185       | 2.516574e-244 | 1576  |

## References

Smith, R.P. et al. (2014) ‘Genome-Wide Discovery of Drug-Dependent Human Liver Regulatory Elements’, PLoS Genetics, 10(10), p. e1004648. Available at: https://doi.org/10.1371/journal.pgen.1004648.

Ramamoorthy, A. et al. (2013) ‘Regulation of MicroRNA Expression by Rifampin in Human Hepatocytes’, Drug Metabolism and Disposition, 41(10), pp. 1763–1768. Available at: https://doi.org/10.1124/dmd.113.052886.

