## ----eval = FALSE-------------------------------------------------------------
# library(rqualify)
# 
# # Render the R-validation report, must have TinyTeX and Pandoc installed,
# # otherwise set setup_tinytex and setup_pandoc to TRUE.
# rqualify(path_save    = tempdir(),
#          setup_tinytex = FALSE,
#          setup_pandoc  = FALSE)

## ----codeexec, echo=FALSE, message=FALSE--------------------------------------

code_exec <- rqualify:::validation_output

# Define tempdir()
dir_temp <- file.path(tempdir(), "IQ-OQ-TestOutput")
dir.create(dir_temp, showWarnings = FALSE)
dir_temp <- normalizePath(dir_temp, winslash="/")


## ----titlepage, message=FALSE-------------------------------------------------
# Get R installation facts
RVersionInfo <- R.Version()
Version      <- RVersionInfo$version.string
Arch         <- gsub("_", " ", RVersionInfo$arch)
Platform     <- gsub("_", " ", RVersionInfo$platform)

## ----rhome--------------------------------------------------------------------
r_home <- paste0(R.home(), sep="\n")

## ----echo=FALSE, results="asis"-----------------------------------------------
cat(paste0(r_home, collapse = "\n"))

## ----rbanner------------------------------------------------------------------
iq_run <- rqualify:::run_validation_suite("iq", dir_temp)
results0 <- paste(iq_run$output, collapse = "\n")

## ----echo=FALSE, results="asis"-----------------------------------------------
cat(results0)

## ----rsysinfo-----------------------------------------------------------------
# Run Sys.info() at the command line
results_sysinfo <- code_exec(code_block    = "Sys.info()",
                             file_prefix   = "sysinfo",
                             folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble and arrow)
results_sysinfo_clean <- results_sysinfo[-(1:(which(results_sysinfo == "> Sys.info()")))]

if(any(results_sysinfo_clean == "> ")){
  results_sysinfo_clean <- results_sysinfo_clean[-which(results_sysinfo_clean == "> ")]
}

## ----echo=FALSE, results="asis"-----------------------------------------------
cat(paste0(results_sysinfo_clean, collapse = "\n"))

## ----rplatform----------------------------------------------------------------
# Run .Platform at the command line
results_platform <- code_exec(code_block    = ".Platform",
                              file_prefix   = "platform",
                              folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble)
results_platform_clean <- results_platform[-(1:(which(results_platform == "> .Platform")))]

if(any(results_platform_clean == "> ")){
  results_platform_clean <- results_platform_clean[-which(results_platform_clean == "> ")]
}

## ----echo=FALSE, results="asis"-----------------------------------------------
cat(paste0(results_platform_clean, collapse = "\n"))

## ----rversion-----------------------------------------------------------------
# Run R.version at the command line
results_rversion <- code_exec(code_block    = "R.version",
                              file_prefix   = "rversion",
                              folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble)
results_rversion_clean <- results_rversion[-(1:(which(results_rversion == "> R.version")))]

if(any(results_rversion_clean == "> ")){
  results_rversion_clean <- results_rversion_clean[-which(results_rversion_clean == "> ")]
}

## ----echo=FALSE, results="asis"-----------------------------------------------
cat(paste0(results_rversion_clean, collapse = "\n"))

## ----rmachine-----------------------------------------------------------------
# Run .Machine at the command line
results_machine <- code_exec(code_block    = ".Machine",
                             file_prefix   = "machine",
                             folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble)
results_machine_clean <- results_machine[-(1:(which(results_machine == "> .Machine")))]

if(any(results_machine_clean == "> ")){
  results_machine_clean <- results_machine_clean[-which(results_machine_clean == "> ")]
}

## ----echo=FALSE, results="asis"-----------------------------------------------
cat(paste0(results_machine_clean, collapse = "\n"))

## ----rsession-----------------------------------------------------------------
# Run sessionInfo() at the command line
results_sessioninfo <- code_exec(code_block   = "sessionInfo()",
                                 file_prefix  = "sessioninfo",
                                 folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble)
results_sessioninfo_clean <- results_sessioninfo[-(1:(which(results_sessioninfo == "> sessionInfo()")))]

if(any(results_sessioninfo_clean == "> ")){
  results_sessioninfo_clean <- results_sessioninfo_clean[-which(results_sessioninfo_clean == "> ")]
}

## ----echo=FALSE, results="asis"-----------------------------------------------
cat(paste0(results_sessioninfo_clean, collapse = "\n"))

## ----lib_path-----------------------------------------------------------------
results_libpath <- code_exec(code_block   = ".libPaths()",
                             file_prefix  = "libpaths",
                             folder_output = dir_temp)

# Clean-up the results (remove the unnecessary preamble)
results_libpath_clean <- results_libpath[-(1:(which(results_libpath == "> .libPaths()")))]

if(any(results_libpath_clean == "> ")){
  results_libpath_clean <- results_libpath_clean[-which(results_libpath_clean == "> ")]
}

## ----echo=FALSE, results="asis"-----------------------------------------------
cat(paste0(results_libpath_clean, collapse = "\n"))

## ----pandoc_ver---------------------------------------------------------------
if(pandoc::pandoc_available()){
  results_pandoc_ver <- code_exec(code_block   = "rmarkdown::pandoc_version()",
                                  file_prefix  = "pandoc_ver",
                                  folder_output = dir_temp)
  
  # Clean-up the results (remove the unnecessary preamble)
  results_pandoc_ver_clean <- results_pandoc_ver[-(1:(which(results_pandoc_ver == "> rmarkdown::pandoc_version()")))]
  
  if(any(results_pandoc_ver_clean == "> ")){
    results_pandoc_ver_clean <- results_pandoc_ver_clean[-which(results_pandoc_ver_clean == "> ")]
  }
} else{
  results_pandoc_ver_clean <- "Pandoc not available"
}

## ----echo=FALSE, results="asis"-----------------------------------------------
cat(paste0(results_pandoc_ver_clean, collapse = "\n"))

## ----tinytex_ver--------------------------------------------------------------
if(tinytex::is_tinytex()){
  results_tinytex_ver <- code_exec(code_block   = "tinytex::tlmgr_version()",
                                   file_prefix  = "tinytex_ver",
                                   folder_output = dir_temp)
  
  # Clean-up the results (remove the unnecessary preamble)
  results_tinytex_ver_clean <- results_tinytex_ver[-(1:(which(results_tinytex_ver == "> tinytex::tlmgr_version()")))]
  
  if(any(results_tinytex_ver_clean == "> ")){
    results_tinytex_ver_clean <- results_tinytex_ver_clean[-which(results_tinytex_ver_clean == "> ")]
  }
} else{
  results_tinytex_ver_clean <- "TinyTeX not available"
}

## ----echo=FALSE, results="asis"-----------------------------------------------
cat(paste0(results_tinytex_ver_clean, collapse = "\n"))

## ----oq1, eval=FALSE----------------------------------------------------------
# results1 <- rqualify:::run_validation_suite("basic", "IQ-OQ-TestOutput")

## ----oq1read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile1Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq2, eval=FALSE----------------------------------------------------------
# results2 <- rqualify:::run_validation_suite("base_examples", "IQ-OQ-TestOutput")

## ----oq2read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile2Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq3, eval=FALSE----------------------------------------------------------
# results3 <- rqualify:::run_validation_suite("base_vignettes", "IQ-OQ-TestOutput")

## ----oq3read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile3Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq4, eval=FALSE----------------------------------------------------------
# results4 <- rqualify:::run_validation_suite("recommended_examples", "IQ-OQ-TestOutput")

## ----oq4read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile4Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq5, eval=FALSE----------------------------------------------------------
# results5 <- rqualify:::run_validation_suite("recommended_vignettes", "IQ-OQ-TestOutput")

## ----oq5read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile5Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq6, eval=FALSE----------------------------------------------------------
# results6 <- rqualify:::run_validation_suite("base_tests", "IQ-OQ-TestOutput")

## ----oq6read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile6Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq7, eval=FALSE----------------------------------------------------------
# results7 <- rqualify:::run_validation_suite("recommended_tests", "IQ-OQ-TestOutput")

## ----oq7read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile7Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----codecleanup, echo=FALSE, message=FALSE-----------------------------------
unlink(dir_temp)

