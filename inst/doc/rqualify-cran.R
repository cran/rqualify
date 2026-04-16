## ----eval = FALSE-------------------------------------------------------------
# library(rqualify)
# 
# # Render the R-validation report, must have TinyTeX and Pandoc installed,
# # otherwise set setup_tinytex and setup_pandoc to TRUE.
# rqualify(path_save    = tempdir(),
#          setup_tinytex = FALSE,
#          setup_pandoc  = FALSE)

## ----codeexec, echo=FALSE, message=FALSE--------------------------------------

# Helper function for running code at the command line
code_exec <- function(code_block, file_prefix, folder_output){
  
  # Set code file name
  file_code <- file.path(folder_output, paste0(file_prefix, ".R"))
  
  # Write code_block to R file
  fileConn <- file(file_code)
  writeLines(code_block, fileConn)
  close(fileConn)
  
  # Set output file name
  file_output <- file.path(folder_output, paste0(file_prefix, "Out.txt"))
  
  # Command to run @ command line
  cmd <- paste(shQuote(file.path(R.home("bin"), "R")),
               "CMD BATCH --vanilla --no-timing", 
               shQuote(file_code), 
               shQuote(file_output))
  
  # Run the command
  run <- try(system(cmd))
  
  # Load results and return
  readLines(file.path(folder_output, paste0(file_prefix, "Out.txt")))
}

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
# Output the R startup banner
results0 <- try(system(paste(shQuote(file.path(R.home("bin"), "R")), "-e", shQuote("q()")), intern = TRUE))

if (class(results0) != "try-error"){
  results0 <- paste(results0, collapse = "\n")
  results0 <- gsub("> q\\(\\)", "", results0)
} else{
  results0 <- "Unable to execute R at the command line"
}

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
# 
# # Copy system tests to IQ-OQ-TestOutput/tests
# r_test_path <- file.path(R.home(), "tests")
# fc          <- file.copy(r_test_path, "IQ-OQ-TestOutput", recursive=TRUE)
# 
# # Set absolute test path
# path_system_tests <- normalizePath("IQ-OQ-TestOutput/tests", winslash="/")
# 
# code_check1 <- sprintf('
# options(echo = FALSE)
# options(useFancyQuotes = FALSE)
# 
# Failure <- tryCatch(tools:::testInstalledBasic(
#                     scope      = "basic",
#                     outDir     = "%s",
#                     testSrcdir = "%s"
#                     ),
#                     error=function(e) TRUE)
# 
# if (Failure){
#   cat("\n\nTest suite result: FAIL\n\n")
#   fc <- file.create("IQ-OQ-TestOutput/CMDFile1Fail", showWarnings = FALSE)
# } else {
#   cat("\n\nTest suite result: PASS\n\n")
# }
# q(status = Failure)
# ',path_system_tests,path_system_tests)
# 
# results1 <- code_exec(code_block    = code_check1,
#                       file_prefix   = "CMDFile1",
#                       folder_output = "IQ-OQ-TestOutput")
# 

## ----oq1read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile1Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq2, eval=FALSE----------------------------------------------------------
# code_check2 <- '
# options(echo = FALSE)
# options(useFancyQuotes = FALSE)
# Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "base", types = "examples", errorsAreFatal = FALSE),
#                     error=function(e) TRUE)
# if (Failure) {
#   cat("\n\nTest suite result: FAIL\n\n")
#   fc <- file.create("IQ-OQ-TestOutput/CMDFile2Fail")
# } else {
#   cat("\n\nTest suite result: PASS\n\n")
# }
# q(status = Failure)
# '
# results2 <- code_exec(code_block    = code_check2,
#                       file_prefix   = "CMDFile2",
#                       folder_output = "IQ-OQ-TestOutput")

## ----oq2read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile2Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq3, eval=FALSE----------------------------------------------------------
# code_check3 <- '
# options(echo = FALSE)
# options(useFancyQuotes = FALSE)
# Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "base", types = "vignettes", errorsAreFatal = FALSE),
#                     error=function(e) TRUE)
# if (Failure) {
#   cat("\n\nTest suite result: FAIL\n\n")
#   fc <- file.create("IQ-OQ-TestOutput/CMDFile3Fail", showWarnings = FALSE)
# } else {
#   cat("\n\nTest suite result: PASS\n\n")
# }
# q(status = Failure)
# '
# results3 <- code_exec(code_block    = code_check3,
#                       file_prefix   = "CMDFile3",
#                       folder_output = "IQ-OQ-TestOutput")

## ----oq3read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile3Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq4, eval=FALSE----------------------------------------------------------
# code_check4 <- '
# options(echo = FALSE)
# options(useFancyQuotes = FALSE)
# Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "recommended", types = "examples", errorsAreFatal = FALSE),
#                     error=function(e) TRUE)
# if (Failure){
#   cat("\n\nTest suite result: FAIL\n\n")
#   fc <- file.create("IQ-OQ-TestOutput/CMDFile4Fail", showWarnings = FALSE)
# } else {
#   cat("\n\nTest suite result: PASS\n\n")
# }
# q(status = Failure)
# '
# results4 <- code_exec(code_block    = code_check4,
#                       file_prefix   = "CMDFile4",
#                       folder_output = "IQ-OQ-TestOutput")

## ----oq4read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile4Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq5, eval=FALSE----------------------------------------------------------
# code_check5 <- '
# options(echo = FALSE)
# options(useFancyQuotes = FALSE)
# Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "recommended", types = "vignettes", errorsAreFatal = FALSE),
#                     error=function(e) TRUE)
# if (Failure){
#   cat("\n\nTest suite result: FAIL\n\n")
#   fc <- file.create("IQ-OQ-TestOutput/CMDFile5Fail", showWarnings = FALSE)
# } else {
#   cat("\n\nTest suite result: PASS\n\n")
# }
# q(status = Failure)
# '
# results5 <- code_exec(code_block    = code_check5,
#                       file_prefix   = "CMDFile5",
#                       folder_output = "IQ-OQ-TestOutput")

## ----oq5read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile5Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq6, eval=FALSE----------------------------------------------------------
# code_check6 <- '
# options(echo = FALSE)
# options(useFancyQuotes = FALSE)
# Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "base", types = "tests", errorsAreFatal = FALSE),
#                     error=function(e) TRUE)
# if (Failure){
#   cat("\n\nTest suite result: FAIL\n\n")
#   fc <- file.create("IQ-OQ-TestOutput/CMDFile6Fail", showWarnings = FALSE)
# } else {
#   cat("\n\nTest suite result: PASS\n\n")
# }
# q(status = Failure)
# '
# results6 <- code_exec(code_block    = code_check6,
#                       file_prefix   = "CMDFile6",
#                       folder_output = "IQ-OQ-TestOutput")

## ----oq6read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile6Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----oq7, eval=FALSE----------------------------------------------------------
# code_check7 <- '
# options(echo = FALSE)
# options(useFancyQuotes = FALSE)
# Failure <- tryCatch(tools:::testInstalledPackages(outDir = "IQ-OQ-TestOutput", scope = "recommended", types = "tests", errorsAreFatal = FALSE),
#                     error=function(e) TRUE)
# if (Failure){
#   cat("\n\nTest suite result: FAIL\n\n")
#   fc <- file.create("IQ-OQ-TestOutput/CMDFile7Fail", showWarnings = FALSE)
# } else {
#   cat("\n\nTest suite result: PASS\n\n")
# }
# q(status = Failure)
# '
# results7 <- code_exec(code_block    = code_check7,
#                       file_prefix   = "CMDFile7",
#                       folder_output = "IQ-OQ-TestOutput")

## ----oq7read, echo=FALSE, results="asis"--------------------------------------
cat(paste0(readLines(system.file("qualify_r/example_success/CMDFile7Out.txt", package="rqualify")), 
           collapse = "\n"))

## ----codecleanup, echo=FALSE, message=FALSE-----------------------------------
unlink(dir_temp)

