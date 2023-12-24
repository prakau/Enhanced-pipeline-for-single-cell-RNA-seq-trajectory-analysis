# Load necessary libraries
library(Monocle)
library(Seurat)
library(dplyr)
library(ggplot2)
library(plotly)
library(ggbio)
library(ComplexHeatmap)

# Load and preprocess data
seurat_object <- Read10X(data.dir = "path_to_your_data/")
seurat_object <- CreateSeuratObject(counts = seurat_object, project = "SingleCellRNASeq")
seurat_object <- NormalizeData(seurat_object)
seurat_object <- FindVariableFeatures(seurat_object)

# Principal Component Analysis
seurat_object <- RunPCA(seurat_object, features = VariableFeatures(object = seurat_object))

# Find clusters
seurat_object <- FindNeighbors(seurat_object, dims = 1:10)
seurat_object <- FindClusters(seurat_object, resolution = 0.5)

# Run UMAP for visualization
seurat_object <- RunUMAP(seurat_object, dims = 1:10)

# Trajectory Inference using Monocle
cds <- as.cell_data_set(seurat_object)
cds <- reduce_dimension(cds)
cds <- order_cells(cds)

# Differential Expression Analysis
cluster_markers <- FindAllMarkers(seurat_object, only.pos = TRUE, min.pct = 0.25, logfc.threshold = 0.25)

# Interactive UMAP Visualization
umap_plot <- DimPlot(seurat_object, reduction = "umap", group.by = "seurat_clusters") + NoLegend()
umap_plotly <- ggplotly(umap_plot)

# Advanced Trajectory Plot with ggbio
trajectory_plot <- autoplot(cds, color_by = "Pseudotime")

# Heatmap for Differential Expression
top_markers <- cluster_markers %>% group_by(cluster) %>% top_n(n = 10, wt = avg_logFC)
Heatmap(matrix = GetAssayData(seurat_object, slot = "data")[as.character(top_markers$gene), ], 
        name = "expression", 
        cluster_rows = TRUE, 
        show_row_names = TRUE, 
        show_column_names = FALSE)

# Save interactive plots and results
htmlwidgets::saveWidget(umap_plotly, "UMAP_plot_interactive.html")
ggsave(trajectory_plot, filename = "Trajectory_plot.pdf")
write.csv(cluster_markers, file = "Differential_Expression_Results.csv")
