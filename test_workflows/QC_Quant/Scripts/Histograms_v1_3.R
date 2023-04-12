
### X: Data in long format

Histograms <- function(X, plot_height = 25, plot_width = 38, suffix="nonorm",
                       plot_dpi = 2, group_colours = NULL, groupvar_name = "Group",
                       numcol = 1, numrow = 1, ylimit= NULL, xlimit=NULL,
                       num_bins = NULL, ...){

  X_orig <- X
  X <- X[!is.na(X$value),]

  require(ggplot2)
  require(ggpubr)
  require(ggplus)

  use_groups <- !all(is.na(X$group))

  state_levels <- length(levels(factor(X$name)))

  if((numcol*numrow)> state_levels){
    while ((numcol*numrow)> state_levels) {
      numcol <- ifelse(numcol==1,1,numcol-1)
      numrow <- ifelse(numrow==1,1,numrow-1)
    }
  }

  pdf(paste0(output_path, "histograms.pdf"),
      height = plot_height/2.54, width = plot_width/2.54, pointsize = plot_dpi) # height and width in inches
  
      if (is.null(num_bins)) { ## if not given, apply Sturges rule
        ## TODO: think again about using Sturges rule, as it may underestimate the
        ## number of bins for large number of proteins or peptides
        n <- nrow(X_orig)/length(unique(X_orig$name))
        num_bins <- ceiling(log2(n)) + 1
        #print(num_bins)
      }
    
      if (use_groups) {
        if (is.null(group_colours)) {
          nr_groups <- length(levels(X$group))
          group_colours <- hue_pal()(nr_groups)
        }
        histoplot<- ggplot(X,aes(x=value, fill = group)) + geom_histogram(bins = num_bins) +
          labs(fill = groupvar_name)+ scale_fill_manual(values = group_colours, drop = FALSE)
      } else {
        histoplot<- ggplot(X,aes(x=value)) + geom_histogram(bins = num_bins)
      }
    
    
      histo <- histoplot + theme_bw(base_size = 20)
    
      if (!is.null(ylimit)){
        histo <- histo + ylim(ylimit)
      }
      if (!is.null(xlimit)){
        histo <- histo + xlim(xlimit)
      }
    
      if (numcol*numrow == state_levels) {
        histo <- histo + facet_wrap(facets = vars(name),
                                    ncol = numcol,
                                    nrow = numrow, scales = "fixed")
       } else {
         histo <- facet_multiple(plot = histo,
                                 facets = 'name', # name choosen as the "splitter"
                                 ncol = numcol,
                                 nrow = numrow, scales = "fixed")
       }
      print(histo)
  
  dev.off()
}

################################################################################
### Changelog:

### Version 1.0 (2021-07-06):
# added function for histograms

### Version 1.1 (2021-10-18):
# solved empty pdf-file problem
# added ylimit and xlimit as options/arguments

### Version 1.2 (2021-03-15):
# add arguments numbins for manual adjustment of bin numbers
# correct Sturges rule (ceiling instead of round)
# make script work if no groups are defined
