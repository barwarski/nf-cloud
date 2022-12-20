################################################################################
#### R Script 

#source("C:/Users/schorkka/UNI/R_scripts/QC_workflow/QC_and_normalization/package_installation_v1_1.R")

###
#RScript '/Users/awienbarwari/Desktop/SHK/stat_workflows/QC_and_normalization/Nextflow_MAIN_QC_script_quant_v1.R' "/Users/awienbarwari/Desktop/SHK/" "data/testdata/QC/sSHT_proteinGroups_Intensities.xlsx" "data/results/QC_sSHT_proteinGroups_Intensities/" "stat_workflows/QC_and_normalization/" 5:54 #TRUE "nonorm" TRUE NULL "Group" "pdf" 300 2
###
################################################################################
### Basic settings:
args <- commandArgs(TRUE)
### set path to working directory (all other paths can be defined relatively to this)
path <- as.character(args[1])
setwd(path)
### set path to data file (relativ to the working directory specified above)
data_path <- as.character(args[2])
### set output_path were all created graphics are saved (relativ to the working directory specified above)
output_path <- as.character(args[3])
### set RScripts path were the necessary RScripts are located (e.g. for PCA and MA plots)
### (relativ to the working directory specified above)
RScript_path <- as.character(args[4])

# path <- "/Users/awienbarwari/Desktop/SHK/"
# data_path <- "/Users/awienbarwari/Desktop/SHK/data/testdata/QC/sSHT_proteinGroups_Intensities.xlsx"
# output_path <- "data/results/QC_sSHT_proteinGroups_Intensities/"
# RScript_path <- "stat_workflows/QC_and_normalization/"

### check if output path exists
if(!dir.exists(output_path)){
  dir.create(output_path)
}
#if (!dir.exists(paste0(path, output_path))){
#  dir.create(paste0(path, output_path))
#}
###

### Specify which columns contain the peptide or protein intensities.
### All other columns will be deleted before generating the plots.
### e.g. 3:29 indicates all columns from 3 to 29. Columns 1 and 2 will be removed.
intensity_columns = eval(parse(text=args[5]))

### log_data: TRUE, if data should be log-transformed. FALSE if not (e.g. if data is already on log-level)
log_data = as.logical(args[6])

### choose normalization: "nonorm" = without normalization, "median" = Median normalization,
###                       "loess" = LOESS normalization, "quantile" = Quantile normalization
normalization = as.character(args[7])

### set use_groups to FALSE, if you have no groups in the data
use_groups = as.logical(args[8])

################################################################################
### Advanced settings:

### Here you can set colours for the different experimental groups, which are used
### for the graphics. This has to be in form of a vector with colour names
### or hexadecimal codes, one colour for each group (groups will be sorted alphabetically)
### Example:
### group_colours <- c("red", "green", "blue")
### named colours in R can be found here: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
### If you leave this as NULL, the default ggplot2 colours will be used.
group_colours <- as.character(args[9])

### Name of the group variable that will show up as the legend title in the Plots
### (e.g. "Treatment", "Group", "Condition", ...)
groupvar_name = as.character(args[10])

### Here you can define the plot device that will be used to save the graphics
### possible values are "pdf" (default), "png", "svg", "tiff"
### Please note that the histograms and MA-Plots will always be saved as
### pdf because multiple pages are needed.
plot_device = as.character(args[11])

### Resolution (in dots per inch) for the plots. This only does have an effect for
### png or tiff.
plot_dpi = as.integer(args[12])

### Maximal Number of plotted MA-Plots
maxPlots_MAPlot = as.integer(args[13])

### Here you can adjust the heights and widths for the different plot types in cm,
### e.g. if you have many samples and the plots are too small.
plot_height_validvalueplot = as.integer(args[14])
plot_width_validvalueplot  = as.integer(args[15])
plot_height_boxplots = as.integer(args[16])
plot_width_boxplots  = as.integer(args[17])
plot_height_PCA = as.integer(args[18])
plot_width_PCA  = as.integer(args[19])
plot_height_MAPlot = as.integer(args[20])
plot_width_MAPlot  = as.integer(args[21])


### Adjust x and y axis limits for the PCA plots and Histograms, e.g. plot_xlim_PCA = c(-5, 5).
### The default value NULL will calculate appropriate limits from the data.
plot_xlim_PCA <- as.integer(args[22])
plot_ylim_PCA <- as.integer(args[23])
if(plot_xlim_PCA == 0){plot_xlim_PCA <- NULL}
if(plot_ylim_PCA == 0){plot_ylim_PCA <- NULL}

### Here you can specify samples that should be used for plotting by giving a vector
### of column names, e.g.
### sample_filter <- c("control_1", "control_3", "patient_2")
### If you leave this as NULL, all samples will be plotted.
### This will currently be used for the boxplots and Valid values plots ONLY!
sample_filter <- as.character(args[24])#eval(parse(text=args[24]))
if(sample_filter == "x"){sample_filter <- NULL}

### Set symbols, that should be recognized as a missing value (do not include "0", this will be treated by zero_to_NA)
na_strings = c("NA", "NaN", "Filtered","#NV")
### TRUE, if 0 should be treated as a missing value. FALSE, if 0 should be left as a 0 (does not work in combination with log_data = TRUE).
zero_to_NA = as.logical(args[25])

### Base of the logarithm used
log_base = as.integer(args[26])

### txt file where maplot message will be written
fileConn = file(as.character(args[27]))

### Suffix to add to the file names (usually the normalization type, but can be changed, e.g. to "LFQ")
suffix <- normalization

################################################################################
################################################################################
################################################################################
#### start of QC Script!
#### only change if you know what you are doing! ;-)

################################################################################
### loading required R packages
library(openxlsx)   ### for reading and writing xlsx files
library(limma)      ### e.g. for normalization
#library(tidyverse)  ### tidyverse functionalities + ggplot2
library(scales)     ### for colours
library(matrixStats)### e.g. for rowVars used in PCA plot function
library(cowplot)
#library(affy)       ### for MA-Plots
#library(ggplus)     ### used in histogram function
library(beepr)      ### for sound after completion of MA-Plots

setwd(path)

source(paste0(RScript_path, "PCA_plot_v1_3.R"))
source(paste0(RScript_path, "MA_Plots_v1_3_nextflow.R"))
source(paste0(RScript_path, "ValidValue_Plot_v1_3.R"))
source(paste0(RScript_path, "Boxplot_v1_3.R"))
source(paste0(RScript_path, "Histograms_v1_3.R"))
source(paste0(RScript_path, "automatedNormalization_v1_3.R"))


################################################################################
#### read in data file

output_path <- paste0(path, output_path)

print(171)

D <- read.xlsx(data_path, na.strings = na_strings)

id <- D[, -intensity_columns]
D <- D[, intensity_columns]

if (use_groups) {
  group <- factor(limma::strsplit2(colnames(D), "_")[,1])
} else {
  group <- NULL
}

if(zero_to_NA) {
  D[D == 0] <- NA
}

if(log_data) {
  D <- log(D, base = log_base)
}

nr_groups <- length(levels(group))

### set group colours if not previously specified
if ((group_colours=="null") & nr_groups >= 1) group_colours <- scales::hue_pal()(nr_groups)


### normalize data:
D <- automatedNormalization(DATA = D, method = normalization, log = FALSE,
                             id_columns = id, output_path = output_path)

### convert data to long format
D_long <- pivot_longer(data = D, cols = 1:ncol(D))
if (use_groups) {
  D_long$group <- factor(strsplit2(D_long$name, "_")[,1])
} else {
  D_long$group <- NA
}

################################################################################
#### Valid values plots

ValidValuePlot(X = D_long, groupvar_name = groupvar_name, sample_filter = sample_filter,
               plot_device = plot_device, group_colours = group_colours,
               plot_height = plot_height_validvalueplot, plot_width = plot_width_validvalueplot,
               plot_dpi = plot_dpi, suffix = suffix, output_path = output_path)


################################################################################
#### Boxplots and Violin Plots

Boxplots(X = D_long, groupvar_name = groupvar_name, sample_filter = sample_filter,
         plot_device = plot_device, group_colours = group_colours,
         plot_height = plot_height_boxplots, plot_width = plot_width_boxplots,
         plot_dpi = plot_dpi, log_data = FALSE, log_base = log_base,
         suffix = suffix, method = "boxplot")

Boxplots(X = D_long, groupvar_name = groupvar_name, sample_filter = sample_filter,
         plot_device = plot_device, group_colours = group_colours,
         plot_height = plot_height_boxplots, plot_width = plot_width_boxplots,
         plot_dpi = plot_dpi, log_data = FALSE, log_base = log_base,
         suffix = suffix, method = "violinplot")


################################################################################
#### PCA plots

PCA_Plot(X = D, id = id, groupvar1 = group, groupvar2 = NULL, groupvar1_name = groupvar_name, groupvar2_name = NULL,
         plot_device = plot_device, group_colours = group_colours,
         plot_height = plot_height_PCA, plot_width = plot_width_PCA,
         log_data = FALSE, log_base = log_base,  scale. = TRUE,
         impute = FALSE, impute_method = "mean", propNA = 0,
         point.size = 4, base_size = 20,
         returnPCA = FALSE, title = NULL,
         output_path = output_path, suffix = suffix,
         ylim = plot_ylim_PCA, xlim = plot_xlim_PCA, PCx = 1, PCy = 2)

PCA_Plot(X = D, id = id, groupvar1 = group, groupvar2 = NULL, groupvar1_name = groupvar_name, groupvar2_name = NULL,
         plot_device = plot_device, group_colours = group_colours,
         plot_height = plot_height_PCA, plot_width = plot_width_PCA,
         log_data = FALSE, log_base = log_base,  scale. = TRUE,
         impute = FALSE, impute_method = "mean", propNA = 0,
         point.size = 4, base_size = 20,
         returnPCA = FALSE, title = NULL,
         output_path = output_path, suffix = paste0(suffix, "_labelled"),
         ylim = plot_ylim_PCA, xlim = plot_xlim_PCA, label = TRUE, PCx = 1, PCy = 2,
         label_size = 4)


PCA_Plot(X = D, id = id, groupvar1 = group, groupvar2 = NULL,
         groupvar1_name = groupvar_name, groupvar2_name = NULL,
         plot_device = plot_device, group_colours = group_colours,
         plot_height = plot_height_PCA, plot_width = plot_width_PCA,
         log_data = FALSE, log_base = log_base,  scale. = TRUE,
         impute = TRUE, impute_method = "mean", propNA = 0.5,
         point.size = 4, base_size = 20,
         returnPCA = FALSE, title = NULL,
         output_path = output_path, suffix = paste0(suffix, "_imputed_labelled"),
         ylim = plot_ylim_PCA, xlim = plot_xlim_PCA, label = TRUE, PCx = 1, PCy = 2,
         label_size = 4)

################################################################################
### MA-Plots

mess <- MAPlots(X = D, log = FALSE, alpha = FALSE, maxPlots = maxPlots_MAPlot,
        plot_height = plot_height_MAPlot, plot_width = plot_width_MAPlot,
        output_path = output_path, suffix = suffix)

writeLines(mess, fileConn)
close(fileConn)

################################################################################
################################################################################
################################################################################
#### End of QC Script ##########################################################
