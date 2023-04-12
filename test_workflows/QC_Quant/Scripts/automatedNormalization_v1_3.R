
automatedNormalization <- function(DATA, DATA.name = deparse(substitute(DATA)),
                                   method = "loess", suffix = method, log = TRUE, id_columns = NULL,
                                   output_path = "", groupwise = FALSE, group = NULL,
                                   lts.quantile = 0.8) {

  require(limma)
  require(beepr)
  require(openxlsx)
  require(vsn)
  
  mess <- ""

  if(method == "loess" | method == "quantile" | method == "median"){

    if(log) {
      DATA <- log2(DATA)
    }

    #### choose normalization function
    fun <- switch(method,
                  "loess" = limma::normalizeBetweenArrays,
                  "quantile" = limma::normalizeBetweenArrays,
                  "median" = limma::normalizeBetweenArrays)

    ### choose arguments for normalization function
    args <- switch(method,
                   "loess" = list(object = DATA, method = "cyclicloess"),
                   "quantile" = list(object = DATA, method = "quantile"),
                   "median" = list(object = DATA, method = "scale"))

    if (!groupwise) {
      DATA_norm <- do.call(fun, args)
      DATA_norm <- as.data.frame(DATA_norm)
    } else {
      DATA_split <- split.default(DATA, group)
      DATA_split_norm <- lapply(DATA_split, limma::normalizeBetweenArrays, method = args$method)
      DATA_norm <- do.call(cbind, DATA_split_norm)
    }

    DATA_norm_2 <- data.frame(id_columns, DATA_norm)
    write.xlsx(x = DATA_norm_2, file = paste0(output_path, DATA.name, "_", suffix, ".xlsx"), keepNA = TRUE, overwrite = TRUE)
    message("Normalized data successfully saved!")
    mess <- paste0(mess, "Normalized data successfully saved! \n")

  }


  ### TODO: Daten müssen vor dieser Normalisierung nicht log-transformiert werden!
  ### TODO: groupwise normalisation?
  if (method == "lts") {

    if (log) {
      stop("LTS normalization does not require log-transformation, please set log = FALSE.")
      mess <- paste0(mess, "LTS normalization does not require log-transformation, please set log = FALSE. \n")
    }

    DATA_norm <- vsn::vsn2(as.matrix(DATA), lts.quantile = lts.quantile)
    DATA_norm <- DATA_norm@hx
    DATA_norm <- as.data.frame(DATA_norm)

    DATA_norm_2 <- cbind(id_columns, DATA_norm)
    write.xlsx(x = DATA_norm_2, file = paste0(output_path, DATA.name, "_", suffix, "_", lts.quantile ,".xlsx"), keepNA = TRUE, overwrite = TRUE)
    message("Normalized data successfully saved!")
    mess <- paste0(mess, "Normalized data successfully saved! \n")
  }

  if (method == "nonorm") { # if method == "nonorm"
    DATA_norm <- DATA
    DATA_norm_2 <- data.frame(id_columns, DATA_norm)

    write.xlsx(x = DATA_norm_2, file = paste0(output_path, DATA.name, "_", suffix, ".xlsx"), keepNA = TRUE)
    message("Normalized data successfully saved!")
    mess <- paste0(mess, "Normalized data successfully saved! \n")
  }

  return(list("data" = DATA_norm, "message" = mess))
}


################################################################################
### Changelog:

### Version 1.0 (2021-07-06):
# added function for normalization of data
# added handling for overwriting existing normalized data

### Version 1.1 (2021-10-18):
# No changes.

### Version 1.3 (2023-03):
# Added LTS normalization
