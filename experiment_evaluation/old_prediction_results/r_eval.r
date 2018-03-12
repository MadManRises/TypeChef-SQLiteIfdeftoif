library(reshape2)
library(ggplot2)
library(scales)
draft = F
#if (draft) dev.off()
args<-commandArgs(TRUE)

#options(width=180)
csvData <- read.csv(file=args[1],head=TRUE, sep=",", na.strings=c("","NA"), colClasses=c("id"="numeric", "PercentageError"="numeric", "PercentageErrorInclVariance"="numeric", "VariancePercentage"="numeric", "MPTimePrediction"="numeric", "MPTimeResult"="numeric", "MPSharedFeatureDeviation"="numeric", "MPSharedFeatureDeviationInclVariance"="numeric"))
folders <- c("bugs","cov1","cov1_p1","cov1_p2","dev","dev_p1","extra1","fts","hlr1","req1","session","speed")
#solarize colors
solarizeColors <- c(
    rgb(133, 153,   0, maxColorValue = 255),  #{sol_green}  
    rgb( 38, 139, 210, maxColorValue = 255),  #{sol_blue}   
    rgb(181, 137,   0, maxColorValue = 255),  #{sol_yellow} 
    rgb(108, 113, 196, maxColorValue = 255),  #{sol_violet} 
    rgb(203,  75,  22, maxColorValue = 255),  #{sol_orange} 
    rgb(211,  54, 130, maxColorValue = 255),  #{sol_magenta}
    rgb(255, 255, 255, maxColorValue = 255),  #{white}
    rgb(220,  50,  47, maxColorValue = 255),  #{sol_red}    
    rgb( 42, 161, 152, maxColorValue = 255)  #{sol_cyan}  
    
)

csvData$Folder <- paste(csvData$id %/% 25, csvData$InputMode)
csvData$FolderNo <- csvData$id %/% 25
csvData$Mode <- with(csvData, paste0(InputMode, " predicts ",PredictMode))  # interaction(csvData$InputMode, csvData$PredictMode)
csvData$FolderMode <- interaction(csvData$Mode, csvData$FolderNo)

#remove test scenario 100 from the graphs
csvData <- subset(csvData, !(id == 100))

allyesPredictsFeaturewise <- csvData[ which(csvData$InputMode=='allyes' & csvData$PredictMode=='featurewise'), ]

fun_mean <- function(x){
  return(data.frame(y=mean(x),label=mean(x,na.rm=T)))}

csvData.m <- melt(csvData,id.vars='FolderMode', measure.vars='PercentageError')
csvData.m$Mode <- csvData$Mode
csvData.m$InputMode <- csvData$InputMode
p <- ggplot(csvData.m) + geom_boxplot(aes(x=FolderMode, y=value),position = position_dodge(1)) + labs(x="Test Folder Name", y="Percent Error") + theme(axis.text.x = element_text(angle=315, vjust=0.5, size=8)) + scale_x_discrete(labels=folders[unique(csvData$FolderNo) + 1]) + scale_y_continuous(labels = percent) + expand_limits(y=c(0, 1.62)) # + scale_x_discrete(label=abbreviate) # label=function(x) strtrim(x, 12) or label=abbreviate
p + facet_wrap( ~ Mode, scales="free_x", ncol=3)
ggsave("folder_results.pdf", width=7, height=10)

#csvData.m <- melt(csvData,id.vars='FolderMode', measure.vars='PercentageError')
#csvData.m$Mode <- csvData$Mode
#csvData.m$InputMode <- csvData$InputMode
p <- ggplot(csvData) + geom_boxplot(aes(x=factor(0), y=PercentageError),position = position_dodge(1)) + labs(y="Percent Error") + scale_y_continuous(labels = percent) + expand_limits(y=c(0, 1.62)) + coord_flip() + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())# + scale_x_discrete(label=abbreviate) # label=function(x) strtrim(x, 12) or label=abbreviate
#p + facet_wrap( ~ Mode, scales="free_x", ncol=3)
print(paste0("Mean percent error: ",mean(csvData$PercentageError)))
ggsave("prediction_results.pdf", width=6, height=2)

p <- ggplot(csvData) + geom_boxplot(aes(x=factor(0), y=PercentageErrorInclVariance),position = position_dodge(1)) + labs(y="Percent Error") + scale_y_continuous(labels = percent) + expand_limits(y=c(0, 1.62)) + coord_flip() + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())# + scale_x_discrete(label=abbreviate) # label=function(x) strtrim(x, 12) or label=abbreviate
#p + facet_wrap( ~ Mode, scales="free_x", ncol=3)
print(paste0("Mean percent error incl deviation: ",mean(csvData$PercentageErrorInclVariance)))
ggsave("prediction_results_deviation.pdf", width=6, height=2)

csvData.m <- melt(csvData,id.vars='FolderMode', measure.vars='PercentageErrorInclVariance')
csvData.m$Mode <- csvData$Mode
csvData.m$InputMode <- csvData$InputMode
p <- ggplot(csvData.m) + geom_boxplot(aes(x=FolderMode, y=value),position = position_dodge(1)) + labs(x="Test Folder Name", y="Percent Error including Variance") + theme(axis.text.x = element_text(angle=315, vjust=0.5, size=8)) + scale_x_discrete(labels=folders[unique(csvData$FolderNo) + 1])  + scale_y_continuous(labels = percent) + expand_limits(y=c(0, 1.62))# + scale_x_discrete(label=abbreviate) # label=function(x) strtrim(x, 12) or label=abbreviate
p + facet_wrap( ~ Mode, scales="free_x", ncol=3)
ggsave("folder_results_variance.pdf", width=7, height=10)

csvData.m <- melt(csvData,id.vars='Mode', measure.vars='PercentageError')
csvData.m$Mode <- csvData$Mode
csvData.m$InputMode <- csvData$InputMode
p <- ggplot(csvData.m) + geom_boxplot(aes(x=factor(""),y=value),position = position_dodge(1), width = 0.5) + labs(x="", y="Percent Error") + scale_y_continuous(labels = percent) + expand_limits(y=c(0, 1.62)) #+ theme(axis.text.x = element_text(angle=90, vjust=0.5, size=12)) + scale_x_discrete(labels=unique(csvData$FolderNo)) # + scale_x_discrete(label=abbreviate) # label=function(x) strtrim(x, 12) or label=abbreviate
p + facet_wrap( ~ Mode, scales="free_x", ncol=3)
ggsave("predictmode_results.pdf", width=6.3, height=10)

csvData.m <- melt(csvData,id.vars='Mode', measure.vars='PercentageErrorInclVariance')
csvData.m$Mode <- csvData$Mode
csvData.m$InputMode <- csvData$InputMode
p <- ggplot(csvData.m) + geom_boxplot(aes(x=factor(""),y=value),position = position_dodge(1), width = 0.5) + labs(x="", y="Percent Error including Variance") + scale_y_continuous(labels = percent) + expand_limits(y=c(0, 1.62)) #+ theme(axis.text.x = element_text(angle=90, vjust=0.5, size=12)) + scale_x_discrete(labels=unique(csvData$FolderNo)) # + scale_x_discrete(label=abbreviate) # label=function(x) strtrim(x, 12) or label=abbreviate
p + facet_wrap( ~ Mode, scales="free_x", ncol=3)
ggsave("predictmode_results_variance.pdf", width=6.3, height=10)

warnings()
if (!draft) dev.off()
