#!usr/bin/env nextflow params.data = "~/Code/nf-cloud/uploads/13/sSHT_proteinGroups_Intensities.xlsx"
nextflow.enable.dsl=2

rscript = '~/Code/nf-cloud/test_workflows/QC_and_normalization/Nextflow_MAIN_QC_script_quant_v1.R'
params.folderpath = "~/Code/nf-cloud/test_workflows/QC_and_normalization/"
params.Data = "~/Code/nf-cloud/uploads/2/sSHT_proteinGroups_Intensities.xlsx" 
params.output = "~/Code/nf-cloud/results/QC_and_normalization/" 
params.folderscript = "~/Code/nf-cloud/test_workflows/QC_and_normalization/Scripts/"
params.intensityColumns = "5:54"
params.logData = true
params.normalization = "nonorm"
params.useGroups = true
params.groupColours = "null"
params.groupvarName = "Group"
params.plotDevice = "png"
params.dpi = 300
params.maxMAPlot = 7000
params.validvalueHeight = 10
params.validvalueWidth  = 15
params.boxplotHeight = 10
params.boxplotWidth  = 15
params.pcaHeight  = 15
params.pcaWidth = 20
params.maHeight = 15
params.maWidth  = 15
params.xlimitsPCA = 0
params.ylimitsPCA = 0
params.sampleFilter = "none"
params.zeroToNA = true
params.logBase = 2
params.resultTXT = "~/Code/nf-cloud/results/QC_and_normalization/MA_message.txt"


process QC_Workflow {
  input:
    val rscript
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
  Rscript ${rscript} ${folderpath} ${data} ${output} ${folderscript} ${columns} ${log_data} ${normalization} ${use_groups} ${group_colours} ${group_varname} ${plot_device}  ${plot_dpi} ${max_MAPlot} ${plot_height_validvalueplot} ${plot_width_validvalueplot } ${plot_height_boxplots } ${plot_width_boxplots} ${plot_height_PCA} ${plot_width_PCA} ${plot_height_MAPlot} ${plot_width_MAPlot} ${plot_xlim_PCA} ${plot_ylim_PCA} ${sample_filter} ${zero_to_NA} ${log_base} ${resultTxt}
  """
}

workflow{
  QC_Workflow(rscript, params.folderpath, params.Data, params.output, params.folderscript, params.intensityColumns, params.logData, params.normalization, params.useGroups, params.groupColours, params.groupvarName, params.plotDevice, params.dpi, params.maxMAPlot, params.validvalueHeight, params.validvalueWidth, params.boxplotHeight, params.boxplotWidth, params.pcaHeight, params.pcaWidth, params.maHeight, params.maWidth, params.xlimitsPCA, params.ylimitsPCA, params.sampleFilter, params.zeroToNA, params.logBase, params.resultTXT)
}



