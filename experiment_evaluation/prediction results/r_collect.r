library(data.table)

args = commandArgs(trailingOnly=TRUE)

multmerge = function(mypath){
    filenames=list.files(path=mypath, full.names=TRUE)
#    datalist = lapply(filenames, function(x){read.csv(file=x,header=TRUE)})
#    Reduce(function(x,y) {rbind.data.frame(x,y)}, datalist)
    rbindlist(lapply(filenames,fread), idcol=NULL)
}

meanDiv <- function(x) {
    mean(x) / 100.0
}

results <- multmerge('results')

resultsMean <- aggregate(. ~ id + InputMode + PredictMode, FUN = meanDiv, data = results)

write.csv(resultsMean, file='results_mean.csv', row.names=FALSE)

times <- multmerge('times')

timesMean <- aggregate(. ~ ID + CfgID + Mode, FUN = mean, data = times)

write.csv(timesMean, file='times_mean.csv', row.names=FALSE)
