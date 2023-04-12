#!usr/bin/env nextflow
nextflow.enable.dsl=2

rscript = '~/Code/nf-cloud/test_workflows/QC_Quant/MAIN_QC_nextflow.R'
params.folderpath = "~/Code/nf-cloud/test_workflows/QC_Quant/"
params.data = "data/testdata/QC/sSHT_proteinGroups_Intensities.xlsx"
params.output = "~/results/QC_sSHT_proteinGroups_Intensities/"
params.folderscript = "~/Code/nf-cloud/test_workflows/QC_Quant/Scripts/"

params.intensity_columns = "5:54"
params.log_data = true
params.normalization = "nonorm"
params.use_groups = true
params.group_colours = "null"
params.groupvar_name = "Group"
params.plot_device = "pdf"
params.plot_dpi = 300
params.maxPlots_MAPlot = 7000
params.plot_height_validvalueplot = 10
params.plot_width_validvalueplot  = 15
params.plot_height_boxplots = 10
params.plot_width_boxplots  = 15
params.plot_height_PCA = 15
params.plot_width_PCA  = 20
params.plot_height_MAPlot = 15
params.plot_width_MAPlot  = 15
params.plot_xlim_PCA = 0
params.plot_ylim_PCA = 0
params.sample_filter = "none"
params.zero_to_NA = true
params.log_base = 2


process QC_Workflow {
  input:
    path rscript
    val folderpath
    val data
    val output
    val folderscript
    val columns
    val log_data
    val normalization
    val use_groups
    val group_colours
    val group_varname
    val plot_device
    val plot_dpi
    val max_MAPlot
    val plot_height_validvalueplot
    val plot_width_validvalueplot  
    val plot_height_boxplots 
    val plot_width_boxplots 
    val plot_height_PCA 
    val plot_width_PCA  
    val plot_height_MAPlot
    val plot_width_MAPlot
    val plot_xlim_PCA
    val plot_ylim_PCA
    val sample_filter
    val zero_to_NA
    val log_base


  script:
  /*If you using MacOS replace Rscript with RScript- for Linux use Rscript*/
  """
  RScript ${rscript} ${folderpath} ${data} ${output} ${folderscript} ${columns} ${log_data} ${normalization} ${use_groups} ${group_colours} ${group_varname} ${plot_device}  ${plot_dpi} ${max_MAPlot} ${plot_height_validvalueplot} ${plot_width_validvalueplot } ${plot_height_boxplots } ${plot_width_boxplots} ${plot_height_PCA} ${plot_width_PCA} ${plot_height_MAPlot} ${plot_width_MAPlot} ${plot_xlim_PCA} ${plot_ylim_PCA} ${sample_filter} ${zero_to_NA} ${log_base} 
  """
}

workflow{
  QC_Workflow(rscript, params.path, params.data_path, params.output_path, params.RScript_path, params.intensity_columns, params.log_data, params.normalization, params.use_groups, params.group_colours, params.groupvar_name, params.plot_device, params.plot_dpi, params.maxPlots_MAPlot, params.plot_height_validvalueplot, params.plot_width_validvalueplot, params.plot_height_boxplots, params.plot_width_boxplots, params.plot_height_PCA, params.plot_width_PCA, params.plot_height_MAPlot, params.plot_width_MAPlot, params.plot_xlim_PCA, params.plot_ylim_PCA, params.sample_filter, params.zero_to_NA, params.log_base)
}

