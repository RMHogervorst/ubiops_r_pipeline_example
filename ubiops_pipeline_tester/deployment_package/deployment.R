# This file (containing the deployment code) is required to be called 'deployment.R' and should contain an 'init'
# and 'request' method.

#' @title Init
#' @description Initialisation method for the deployment.
#'     It can for example be used for loading modules that have to be kept in memory or setting up connections.
#' @param base_directory (str) absolute path to the directory where the deployment.R file is located
#' @param context (named list) details of the deployment that might be useful in your code
init <- function(base_directory, context) {
    print("Initialising pipeline tester")
    # read in the file
    print("loading wines")
    wines_path <- file.path(base_directory, 'winequality-red.csv')
    wines <<- read.csv(wines_path)
}

#' @title Request
#' @description Method for deployment requests, called separately for each individual request.
#' @param input_data (str or named list) request input data
#'     - In case of structured input: a named list, with as keys the input fields as defined upon deployment creation
#'     - In case of plain input: a string
#' @param base_directory (str) absolute path to the directory where the deployment.R file is located
#' @param context (named list) details of the deployment that might be useful in your code
#' @return output data (str or named list) request result
#'     - In case of structured output: a named list, with as keys the output fields as defined upon deployment creation
#'     - In case of plain output: a string
request <- function(input_data, base_directory, context) {
    warnings_log <- c()
    set.seed(12345)
    result = wines[sample(1:nrow(wines), size = floor(nrow(wines)*.25)),]
    fileloc = file.path(input_data[["predictions"]])
    print(paste0("reading in predictionfile: ", fileloc))
    predictions = read.csv(fileloc)
    if(nrow(predictions)==0){
        warnings_log <- c(warnings_log, "no input file")
    }
    if(!".pred" %in% colnames(predictions)) stop("predictions needs a .pred column",call. = FALSE)

    if ( nrow(result) != nrow(predictions)){
        warnings_log <- c(warnings_log, paste0("predictions contains ", nrow(predictions) , ' rows, not 399 as expected'))
    }
    # merge results
    if("quality" %in% colnames(predictions)){
        predictions <- predictions[-(which(colnames(result)=='quality'))]
        warnings_log <- c(warnings_log, "predictions contained a quality column, possible wrong dataset")
    }
    joined = merge(result, predictions, by= c("fixed.acidity", "volatile.acidity",     "citric.acid",          "residual.sugar",
                                      "chlorides",            "free.sulfur.dioxide",  "total.sulfur.dioxide", "density",
                                     "pH",                   "sulphates",            "alcohol"), all.x=TRUE, all.y=FALSE)
    print(paste("joined dataset has", nrow(joined), 'rows'))
    print("calculating metrics using .pred & quality")
    joined$residuals <- joined$.pred - joined$quality
    if(sum(joined$residuals)==0){warnings_log <- c(warnings_log, "exact match .pred and quality scores")}
    # calculate rmse, rsq, mae?
    scores = list(
        rmse = sqrt(mean(joined$residuals^2)),
        rsq = 1 -(var(joined$quality)  / sum(joined$residuals^2)  ),
        mae = mean(abs(joined$residuals))
    )

    list(
        warnings = warnings_log,
        scores = scores
    )
}
