library(tidyverse)
#Setting project's path:
project_dir <- "//wsl.localhost/Ubuntu/home/areeshahydronix/Capstone_Project"
raw_dir <- file.path(
  project_dir,
  "raw"
)

results_dir <- file.path(
  project_dir,
  "results"
)

figures_dir <- file.path(
  project_dir,
  "figures"
)
#Creating Output folders
dir.create(
  results_dir,
  showWarnings = FALSE,
  recursive = TRUE
)

dir.create(
  figures_dir,
  showWarnings = FALSE,
  recursive = TRUE
)
#import expr csv file:
expression <- read_csv(
  file.path(
    raw_dir,
    "gene_expression.csv"
  )
)
#import meta csv file
metadata <- read_csv(
  file.path(
    raw_dir,
    "sample_metadata.csv"
  )
)
print(expression)
print(metadata)
glimpse(expression)
glimpse(metadata)

#convert expr data from wide to long format using pivot longer:
expression_long <- expression %>%
  
  pivot_longer(
    cols = -gene_id,
    names_to = "sample",
    values_to = "count"
  )
head(
  expression_long
)

#join expr data with metadata:
expression_metadata <- expression_long %>%
  
  left_join(
    metadata,
    by = "sample"
  )
head(
  expression_metadata
)
#check for missing:
sum(
  is.na(
    expression_metadata$condition
  )
)

#Calculate mean and sd for each gene and condition using group by and summarise:
gene_condition_summary <- expression_metadata %>%
  
  group_by(
    gene_id,
    condition
  ) %>%
  
  summarise(
    mean_expression = mean(
      count,
      na.rm = TRUE
    ),
    
    sd_expression = sd(
      count,
      na.rm = TRUE
    ),
    
    n = n(),
    
    .groups = "drop"
  )
print(
  gene_condition_summary
)

#save the file:
write_csv(
  gene_condition_summary,
  
  file.path(
    results_dir,
    "gene_condition_summary.csv"
  )
)

#Calculate log2fold change for treated vs control :
gene_fold_change <- gene_condition_summary %>%
  
  select(
    gene_id,
    condition,
    mean_expression
  ) %>%
  
  pivot_wider(
    names_from = condition,
    values_from = mean_expression
  ) %>%
  
  mutate(
    log2FC =log2( (treated + 1 ) /( control + 1 ) ) ) %>%
  
  arrange( desc(log2FC ) )
print(
  gene_fold_change
)

#Save csv:
write_csv(
  gene_fold_change,
  
  file.path(
    results_dir,
    "gene_log2FC.csv"
  )
)

#Finding and ranking top responders; top biggest changers:
top_responders <- gene_fold_change |>
  
  mutate(
    abs_log2FC = abs(log2FC),
    
    response = case_when(
      log2FC > 0 ~ "Upregulated",
      log2FC < 0 ~ "Downregulated",
      TRUE ~ "No change"
    )
  ) |>
  
  arrange(
    desc(abs_log2FC)
  ) |>
  
  slice_head(
    n = 10
  )
write_csv(
  top_responders,
  
  file.path(
    results_dir,
    "top_responders.csv"
  )
)
print(
  top_responders
)
#using one consistent theme:
project_theme <- theme_minimal(
  base_size = 13
) +
  
  theme(
    plot.title =
      element_text(
        face = "bold"
      ),
    
    axis.title =
      element_text(
        face = "bold"
      )
  )
#defined condition colors
condition_colors <- c(
  "control" = "#1B5E20",
  "treated" = "#CF4173"
)
#figure 1: Boxplot
figure_1 <- ggplot(
  expression_metadata,
  
  aes(
    x = condition,
    y = count,
    fill = condition
  )
) +
  
  geom_boxplot(
    alpha = 0.8,
    outlier.alpha = 0.5
  ) +
  
  scale_fill_manual(
    values =
      condition_colors
  ) +
  
  labs(
    title =
      "Gene Expression by Condition",
    
    x =
      "Condition",
    
    y =
      "Raw Gene Expression Count"
  ) +
  
  project_theme +
  
  theme(
    legend.position =
      "none"
  )
print(figure_1) 
#Interpretation:Gene-expression distributions were broadly similar between the control and 
#treated conditions. The treated samples showed a slightly higher median expression and greater 
#variability, but the substantial overlap between the groups suggests that treatment did not cause 
#a strong global shift in expression across all genes.

# to save the plot using ggsave function:
ggsave(
  filename =
    file.path(
      figures_dir,
      "figure_1_boxplot.png"
    ),
  
  plot =
    figure_1,
  
  width = 8,
  height = 6,
  dpi = 300
)
#figure 2: Histogram
figure_2 <- ggplot(
  gene_fold_change,
  
  aes(
    x = log2FC
  )
) +
  
  geom_histogram(
    bins = 15,
    fill = "#6A4C93",
    color = "white"
  ) +
  
  geom_vline(
    xintercept = 0,
    linetype = "dashed",
    linewidth = 1
  ) +
  
  labs(
    title =
      "Distribution of Gene log2 Fold-Changes",
    
    x =
      "log2 Fold-Change: Treated vs Control",
    
    y =
      "Number of Genes"
  ) +
  
  project_theme
print(figure_2) 
#Interpretation:Most genes had log2 fold-changes near zero, indicating relatively similar 
#expression between treated and control samples. However, several genes showed large positive 
#or negative fold-changes, suggesting that treatment selectively upregulated some genes and 
#downregulated others.

#save histogram plot:
ggsave(
  file.path(
    figures_dir,
    "figure_2_histogram.png"
  ),
  
  figure_2,
  
  width = 8,
  height = 6,
  dpi = 300
)
#figure 3: barplot of top responding genes 
# Bar plot of the top 10 upregulated responder genes

top_10 <- gene_fold_change %>%
  slice_max(
    order_by = log2FC,
    n = 10,
    with_ties = FALSE
  )

# Check the column names
names(top_10)

# Create the bar plot
figure_3 <- ggplot(
  top_10,
  aes(
    x = reorder(gene_id, log2FC),
    y = log2FC
  )
) +
  geom_col(
    fill = "#C65D7B",
    width = 0.7
  ) +
  coord_flip() +
  labs(
    title = "Top 10 Upregulated Genes",
    x = "Gene",
    y = "log2 Fold-Change (Treated vs Control)"
  ) +
  theme_minimal(
    base_size = 14
  ) +
  theme(
    plot.title = element_text(
      face = "bold",
      hjust = 0.5
    ),
    axis.title = element_text(
      face = "bold"
    )
  )
print(figure_3) 
#Interpretation:The bar plot identifies the ten genes with the highest positive log2 fold-changes 
#between treated and control samples. The strongest treatment-associated increase was observed for 
#crp, followed by ompA and rpoB, indicating that these genes showed the largest increases in average 
#expression under the treatment condition. Several other genes, including lacZ, recA, arcA, and acrB, 
#displayed moderate upregulation, whereas fur, soxS, and ftsZ showed only weak positive changes. 
#Overall, the results suggest that the treatment alters the expression of a subset of genes, with 
#the strongest response concentrated in a few genes rather than being uniform across all genes.

#save using ggsave
ggsave(
  file.path(
    figures_dir,
    "figure_3_top_genes_barplot.png"
  ),
  
  figure_3,
  
  width = 9,
  height = 7,
  dpi = 300
)
#figure 4: control vs treated scatter plot:
top_gene_names <- top_10$gene_id

figure_4 <- ggplot(
  gene_fold_change,
  aes(
    x = control,
    y = treated
  )
) +
  geom_point(
    color = "#4F7C80",
    size = 3,
    alpha = 0.8
  ) +
  geom_abline(
    slope = 1,
    intercept = 0,
    linetype = "dashed",
    color = "gray30"
  ) +
  geom_text(
    data = subset(
      gene_fold_change,
      gene_id %in% top_gene_names
    ),
    aes(
      label = gene_id
    ),
    vjust = -0.7,
    size = 3.5,
    color = "#8B3A50"
  ) +
  labs(
    title = "Mean Gene Expression: Control vs Treated",
    x = "Mean Expression in Control",
    y = "Mean Expression in Treated"
  ) +
  theme_minimal(
    base_size = 14
  ) +
  theme(
    plot.title = element_text(
      face = "bold",
      hjust = 0.5
    ),
    axis.title = element_text(
      face = "bold"
    )
  )
print(figure_4) 
#Interpretation:The control-versus-treated scatter plot shows that treatment alters the expression 
#of multiple genes. Several top responder genes, including crp, ompA, rpoB, lacZ, recA, arcA, and 
#arcB, lie above the y=x reference line, indicating higher mean expression in treated samples. 
#In contrast, genes below the reference line have lower expression after treatment. The separation of 
#several genes from the diagonal suggests a substantial treatment-associated transcriptional response.

# Save the scatter plot
ggsave(
  filename = file.path(
    figures_dir,
    "figure_4_control_vs_treated_scatter.png"
  ),
  plot = figure_4,
  width = 9,
  height = 7,
  dpi = 300
)





















































































