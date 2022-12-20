#!usr/bin/env nextflow
nextflow.enable.dsl=2

rscript = '/nf-cloud/test_workflows/QC_and_normalization/Nextflow_MAIN_QC_script_quant_v1.R'
params.folderpath = "/nf-cloud/test_workflows/QC_and_normalization/"
params.data = "/nf-cloud/sSHT_proteinGroups_Intensities.xlsx" ### check
params.output = "/nf-cloud/test_workflows/QC_and_normalization/" ### check
params.folderscript = "/nf-cloud/test_workflows/QC_and_normalization/Scripts"
params.columns = "5:54"
params.logdata = true
params.normalization = "nonorm"
params.usegroups = true
params.groupcolours = "null"
params.groupvarname = "Group"
params.plotdevice = "pdf"
params.plotdpi = 300
params.maxMAPlot = 7000
params.plotheightvalidvalueplot = 10
params.plotwidthvalidvalueplot  = 15
params.plotheightboxplots = 10
params.plotwidthboxplots  = 15
params.plotheightPCA = 15
params.plotwidthPCA  = 20
params.plotheightMAPlot = 15
params.plotwidthMAPlot  = 15
params.plotxlimPCA = 0
params.plotylimPCA = 0
params.samplefilter = "none"
params.zerotoNA = true
params.logbase = 2
params.resultTXT = "/nf-cloud/test_workflows/QC_and_normalization/MA_message.txt"


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
    val resultTxt


  script:
  /*If you using MacOS replace Rscript with RScript- for Linux use Rscript*/
  """
  RScript ${rscript} ${folderpath} ${data} ${output} ${folderscript} ${columns} ${log_data} ${normalization} ${use_groups} ${group_colours} ${group_varname} ${plot_device}  ${plot_dpi} ${max_MAPlot} ${plot_height_validvalueplot} ${plot_width_validvalueplot } ${plot_height_boxplots } ${plot_width_boxplots} ${plot_height_PCA} ${plot_width_PCA} ${plot_height_MAPlot} ${plot_width_MAPlot} ${plot_xlim_PCA} ${plot_ylim_PCA} ${sample_filter} ${zero_to_NA} ${log_base} ${resultTxt}
  """
}

workflow{
  QC_Workflow(rscript, params.folderpath, params.data, params.output, params.folderscript, params.columns, params.logdata, params.normalization, params.usegroups, params.groupcolours, params.groupvarname, params.plotdevice, params.plotdpi, params.maxMAPlot, params.plotheightvalidvalueplot, params.plotwidthvalidvalueplot, params.plotheightboxplots, params.plotwidthboxplots, params.plotheightPCA, params.plotwidthPCA, params.plotheightMAPlot, params.plotwidthMAPlot, params.plotxlimPCA, params.plotylimPCA, params.samplefilter, params.zerotoNA, params.logbase, params.resultTXT)
}



