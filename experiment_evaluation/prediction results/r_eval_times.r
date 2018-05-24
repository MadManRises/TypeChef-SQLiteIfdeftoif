library(reshape2)
library(ggplot2)
library(scales)
draft = F
#if (draft) dev.off()
args<-commandArgs(TRUE)

#options(width=180)
csvData <- read.csv(file=args[1],head=TRUE, sep=",", na.strings=c("","NA"), colClasses=c("ID"="numeric", "CfgID"="numeric", "Measurements"="numeric", "Time"="numeric", "Overhead"="numeric", "SimTime"="numeric", "VarTime"="numeric"))

csvData$source <- rep('improved',nrow(csvData))

oldData <- read.csv(file=args[2],head=TRUE, sep=",", na.strings=c("","NA"), colClasses=c("ID"="numeric", "CfgID"="numeric", "Measurements"="numeric", "Time"="numeric", "Overhead"="numeric", "SimTime"="numeric", "VarTime"="numeric"))

oldData$source <- rep('baseline',nrow(oldData))

csvData <- rbind(csvData, oldData)

csvData$STime = csvData$Time / 1000
csvData$OverheadPercent = csvData$Overhead / csvData$Time
csvData$VarPercent = abs(csvData$VarTime - csvData$Time) / csvData$VarTime
csvData$SimPercent = abs(csvData$SimTime - csvData$Time) / csvData$SimTime
csvData$SimVarPercent = abs(csvData$SimTime - csvData$VarTime) / csvData$VarTime
csvData$MissingOverhead = csvData$Time - csvData$SimTime
csvData$MissingOverheadPerMeasurement = csvData$MissingOverhead / csvData$Measurements

csvData$Th3ConfigNo <- as.numeric(paste(csvData$ID %%  25))

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
options(scipen=6)

fun_mean <- function(x){
  return(data.frame(y=mean(x),label=mean(x,na.rm=T)))}

csvData.m <- melt(csvData, measure.vars='MissingOverheadPerMeasurement')
csvData.m$MissingOverheadPerMeasurement <- csvData$MissingOverheadPerMeasurement
p <- ggplot(csvData.m,aes(x=source,MissingOverheadPerMeasurement)) + geom_boxplot() + theme(axis.title.y=element_blank()) + labs(y="", x="") + coord_flip()
ggsave("timesf_missing_overhead_per_measurement.pdf",width=6, height=2)

csvData.m <- melt(csvData, measure.vars='Measurements')
csvData.m$Measurements <- csvData$Measurements
p <- ggplot(csvData.m,aes(x=source,Measurements)) + geom_boxplot() + theme(axis.title.y=element_blank()) + labs(y="Total number of\nmeasurements", x="Interaction degree") + coord_flip()# + scale_y_continuous(formatter='log10')
p + stat_summary(fun.y=mean, colour="darkred", geom="point", shape=18, size=3,show_guide = FALSE)
print(paste0("Mean for number of measurements: ",mean(csvData$Measurements)))
ggsave("timesf_measurements.pdf",width=6, height=2)

csvData.m <- melt(csvData, measure.vars='Time')
csvData.m$Time <- csvData$Time
p <- ggplot(csvData.m,aes(x=source,Time)) + geom_boxplot() + theme(axis.title.y=element_blank()) + labs(y="Run time (ms)", x="Interaction degree") + coord_flip()# + scale_y_continuous(formatter='log10')
print(paste0("Mean for measured time: ", mean(csvData$Time)))
ggsave("timesf_time.pdf",width=6, height=2)

csvData.m <- melt(csvData, measure.vars='OverheadPercent')
csvData.m$OverheadPercent <- csvData$OverheadPercent
p <- ggplot(csvData.m,aes(x=source,OverheadPercent)) + geom_boxplot() + theme(axis.title.y=element_blank()) + labs(y="Proportion of overhead to remaining execution time", x="Interaction degree") + coord_flip() + scale_y_continuous(labels = percent)# + scale_y_continuous(formatter='log10')
ggsave("timesf_overhead.pdf",width=6, height=2)

csvData.m <- melt(csvData, measure.vars='SimPercent')
csvData.m$SimPercent <- csvData$SimPercent
p <- ggplot(csvData.m,aes(x=source,SimPercent)) + geom_boxplot() + theme(axis.title.y=element_blank()) + labs(y="Percent error\nin run times", x="Interaction degree") + coord_flip() + scale_y_continuous(labels = percent) #+ ggtitle("Performance measurement vs simulator")
ggsave("timesf_sim.pdf",width=6, height=2)

csvData.m <- melt(csvData, measure.vars='VarPercent')
csvData.m$VarPercent <- csvData$VarPercent
p <- ggplot(csvData.m,aes(x=source,VarPercent)) + geom_boxplot() + theme(axis.title.y=element_blank()) + labs(y="Percent error\nin run times", x="Interaction degree") + coord_flip() + scale_y_continuous(labels = percent) #+ ggtitle("Performance measurement vs variant")# + scale_y_continuous(formatter='log10')
ggsave("timesf_var.pdf",width=6, height=2)

csvData.m <- melt(csvData, measure.vars='VarPercent')
csvData.m$VarPercent <- csvData$VarPercent
csvData.m$Th3ConfigNo <- csvData$Th3ConfigNo
p <- ggplot(csvData.m,aes(x=source,VarPercent)) + geom_boxplot() + theme(axis.title.x=element_blank()) + labs(y="Percent error\nin run times", x="Interaction degree") + scale_y_continuous(labels = percent) #+ ggtitle("Performance measurement vs variant")# + scale_y_continuous(formatter='log10')
p + facet_wrap( ~ Th3ConfigNo, scales="free_x", ncol=13)
ggsave("times_var_cfg.pdf",width=15, height=12)

csvData.m <- melt(csvData, measure.vars='VarPercent')
csvData.m$VarPercent <- csvData$VarPercent
csvData.m$Mode <- csvData$Mode
p <- ggplot(csvData.m,aes(x=source,VarPercent)) + geom_boxplot() + theme(axis.title.x=element_blank()) + labs(y="Percent error\nin run times", x="Interaction degree") + scale_y_continuous(labels = percent) #+ ggtitle("Performance measurement vs variant")# + scale_y_continuous(formatter='log10')
p + facet_wrap( ~ Mode, scales="free_x", ncol=2)
ggsave("times_var_mode.pdf",width=5, height=8)

csvData.m <- melt(csvData, measure.vars='SimVarPercent')
csvData.m$SimVarPercent <- csvData$SimVarPercent
p <- ggplot(csvData.m,aes(x=source,SimVarPercent)) + geom_boxplot() + theme(axis.title.y=element_blank()) + labs(y="Percent error\nin run times", x="Interaction degree") + coord_flip() + scale_y_continuous(labels = percent)#+ ggtitle("Simulator vs variant")# + scale_y_continuous(formatter='log10')
ggsave("timesf_simvsvar.pdf",width=6, height=2)

warnings()
if (!draft) dev.off()
