library(openxlsx)
library(ComplexHeatmap)

D <- read.xlsx("testdata/ANOVA/Daten_Svitlana_proteins_LOESS_logtransformed.xlsx")

id <- D[, 1, drop = FALSE]

Heatmap_with_groups(D = D[,-1], id = id,
                    protein_names_col = NULL,
                    na_method = "na.omit", 
                    filtermissings = 2,
                    groups = NULL, 
                    group_colours = NULL, 
                    column_split = NULL, 
                    cluster_column_slices = FALSE,
                    cluster_rows = TRUE, 
                    cluster_columns = TRUE,
                    dist_method = "pearson", 
                    clust_method = "complete",
                    symmetric_legend = TRUE, 
                    scale_data = TRUE,
                    output_path = paste0(getwd(), "//"), 
                    suffix = NULL,
                    legend_name = "Legend", 
                    title = "Heatmap",
                    legend_colours = c("blue", "white", "red"),
                    #plot_height = 10, plot_width = 10, plot_dpi = 300
                    )

Heatmap_with_groups <- function(D, id, protein_names_col = NULL,
                           na_method = "na.omit", filtermissings = 2,
                           groups = NULL, group_colours = NULL,
                           column_split = NULL, cluster_column_slices = FALSE,
                           cluster_rows = TRUE, cluster_columns = TRUE,
                           dist_method = "pearson", clust_method = "complete",
                           symmetric_legend = TRUE, scale_data = TRUE,
                           output_path = paste0(getwd(), "//"), suffix = NULL,
                           legend_name = "Legend", title = "Heatmap",
                           legend_colours = c("blue", "white", "red"),
                           plot_height = 20, plot_width = 20, plot_dpi = 300,
                           log_data = TRUE, log_base = 2,
                           colour_scale_max = NULL,
                           ...){

  data.asmatrix <- as.matrix(D)

  if(log_data){
    data.asmatrix <- log(data.asmatrix, log_base)
  }

  if (scale_data) {
  ### calculation of z-scores
  data.asmatrix_scaled <- t(scale(t(data.asmatrix)))
  data.asmatrix <- data.asmatrix_scaled
  }

  ### remove rows with only missing values
  ind  <- rowSums(!is.na(data.asmatrix)) >= filtermissings
  data.asmatrix <- data.asmatrix[ind,]
  id <- id[ind,, drop = FALSE]

  ### imputation or filter out rows with missing values
  if(na_method == "impute"){
    data.asmatrix[is.na(data.asmatrix)] <- 0
  }
  if(na_method == "na.omit") {
    data.asmatrix_tmp <- data.asmatrix
    rownames(data.asmatrix_tmp) <- 1:nrow(data.asmatrix_tmp)
    data.asmatrix_tmp <- na.omit(data.asmatrix)
    ind <- as.numeric(rownames(data.asmatrix_tmp))

    id <- id[ind,, drop = FALSE]
    #print(str(id))

    ### if there are no rows remaining after na.omit, keep them and impute by 0
    if(nrow(data.asmatrix_tmp) == 0){
      print("All rows contain at least one missing value. Switched to imputation instead.")
      data.asmatrix[is.na(data.asmatrix)] <- 0
    } else {
      data.asmatrix <- data.asmatrix_tmp
    }
  }
  if (na_method == "keep") {
    data.asmatrix <- data.asmatrix
  }

  if (!is.null(colour_scale_max)) {
    data.asmatrix[data.asmatrix < -colour_scale_max] <- -colour_scale_max
    data.asmatrix[data.asmatrix > colour_scale_max] <- colour_scale_max
  }

  if (symmetric_legend) {
  minmax <- max(abs(c(min(data.asmatrix, na.rm = TRUE), max(data.asmatrix, na.rm = TRUE))))
  legend_colours <- circlize::colorRamp2(c(-minmax, 0, minmax), legend_colours)
  }

  if (!is.null(protein_names_col)) {
    row_labels <- id[, protein_names_col]
  } else {
    row_labels <- rep("", nrow(data.asmatrix))
  }

  ## to annotation for groups
  if (!is.null(groups)) {
    top_annotation = HeatmapAnnotation(df = groups, col = group_colours)
  } else {
    top_annotation = NULL
  }

  if (!is.null(column_split)) {
    column_split = groups[, column_split]
  }


  ht <- Heatmap(data.asmatrix,
                column_title = title , name = legend_name,
                cluster_rows = cluster_rows,
                clustering_distance_rows = dist_method, clustering_method_rows = clust_method,
                cluster_columns = cluster_columns,
                clustering_distance_columns = dist_method, clustering_method_columns = clust_method,
                cluster_column_slices = cluster_column_slices,
                top_annotation = top_annotation,
                column_split = column_split,
                row_labels = row_labels,
                col = legend_colours,
                heatmap_legend_param = list(direction = "vertical"))

  png(paste0(output_path,"Heatmap", suffix, ".png"),width=plot_width,height=plot_height, units = "cm", res = plot_dpi)
  draw(ht, annotation_legend_side = "right", heatmap_legend_side = "right", merge_legend = TRUE)
  dev.off()
  return(ht)
}
