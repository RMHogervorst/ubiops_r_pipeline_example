## create zip
## should be inside one folder with files inside it.
zipname <- "deployment.zip"
if(file.exists(zipname)){
    print('removing old zip')
    file.remove(zipname)
}
print("creating zip")
zip('deployment.zip',files=list.files("deployment_package/",full.names = TRUE))
