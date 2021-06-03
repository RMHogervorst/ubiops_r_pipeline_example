# This file (containing the deployment code) is required to be called 'deployment.R' and should contain an 'init'
# and 'request' method.

#' @title Init
#' @description Initialisation method for the deployment.
#'     It can for example be used for loading modules that have to be kept in memory or setting up connections.
#' @param base_directory (str) absolute path to the directory where the deployment.R file is located
#' @param context (named list) details of the deployment that might be useful in your code
init <- function(base_directory, context) {
    print("Initialising My tester")
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
    # if seed is provided set that
    set.seed(12345)
    result = wines[sample(1:nrow(wines), size = floor(nrow(wines)*.25)),]
    outputfile = file.path(base_directory, "predictions.csv")
    write.csv(result[,-12],outputfile)
    # In this example, the input field "input" in multiplied by a random number and returned in output field "output"
    list( output = outputfile)
}
