
data = read.csv("deployment_package/winequality-red.csv")
data$.pred= mean(data$quality)
data$quality <- NULL
write.csv(data, "testpredictions.csv")


source('deployment_package/deployment.R')
init(base_directory = "deployment_package")
request(input_data = list(predictions='testpredictions.csv'),base_directory = ".")
