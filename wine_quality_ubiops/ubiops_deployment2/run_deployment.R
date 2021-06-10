# This file simulates the platform back-end that initialises the deployment and makes a request. It should not be included
# in a deployment package.

# Deployment_directory points to base folder of the deployment, which should therefore be called 'deployment_package'.
deployment_directory <- file.path("ubiops_deployment2", "deployment_package")

# Import the deployment package
source(file.path(deployment_directory, "deployment.R"))

init(base_directory = deployment_directory, context = list())

input_data <- list(input_data = "data/winequality-red.csv")
request_result <- request(input_data = input_data, base_directory = deployment_directory, context = list())

print(paste("Deployment request result:", request_result))

# make zip
zip(
  zipfile = "ubiops_deployment2/deployment_package.zip",
  files = list.files("ubiops_deployment2/deployment_package/", full.names = "TRUE")
)

# dit werkt niet. niet goed.
