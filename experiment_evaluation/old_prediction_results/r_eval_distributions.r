library(reshape2)
library(ggplot2)
library(scales)
draft = F
#if (draft) dev.off()
args<-commandArgs(TRUE)

#options(width=180)
csvData <- read.csv(file=args[1],head=TRUE, sep=",", na.strings=c("","NA"), colClasses=c("id"="numeric", "ModeID"="numeric", "MaxInteractionDegree"="numeric", "TotalTime"="numeric", "Time"="numeric", "Interaction"="numeric"))
folders <- c("bugs","cov1","cov1_p1","cov1_p2","dev","dev_p1","extra1","fts","hlr1","req1","session","speed")
cfgs <- c("64k", "c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "cA", "cB", "cC", "cD", "cE", "cF", "cH", "dotlock", "eintr1", "excl", "mmap", "nolock", "oom1", "plock", "wal1")
interactions <- c("base", "0", "1", "2", "3", "4", "5", "6")
csvData$Interaction <- replace(csvData$Interaction, csvData$Interaction==-1, "base")
csvData$Interaction <- factor(csvData$Interaction, levels = interactions)

featurewiseDisabledNoSync <- c(0,1,2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22)
featurewiseDisabledNoSync <- interaction('featurewise', featurewiseDisabledNoSync)
randomDisabledNoSync <- c(2,5,9,10,12,14,15,16,17,20,21,23,24,26,29,30,32,33,34,35,36,37,38,39,45,46)
randomDisabledNoSync <- interaction('random', randomDisabledNoSync)

ignoreTh3configs <- c(15,16,23,24)

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

csvData$FolderNo <- as.numeric(paste(csvData$id %/% 25))
csvData$ConfigNo <- as.numeric(paste(csvData$id %%  25))
csvData$IDMode <- interaction(csvData$Mode, csvData$ModeID)
csvData$Perc <- as.numeric(paste(csvData$Time / csvData$TotalTime))
csvData$FolderMode <- interaction(csvData$Interaction, csvData$Mode)
csvData$ConfigMode <- interaction(csvData$Interaction, csvData$ConfigNo)
csvData$FMode <- with(csvData, paste0(Mode, " in ",folders[csvData$FolderNo + 1]))
csvData$FolderInteractionMode <- interaction(csvData$FMode, csvData$Interaction)

newCsv <- subset(csvData, !ConfigNo %in% ignoreTh3configs & Mode == 'pairwise')
newCsv.m <- melt(newCsv,id.vars='Interaction', measure.vars='Perc')
newCsv.m$Perc <- newCsv$Perc
newCsv.m$Mode <- newCsv$Mode
newCsv.m$Interaction <- newCsv$Interaction
p <- ggplot(newCsv.m) + geom_boxplot(aes(x=Interaction, y=value)) + theme(axis.text.x = element_text(angle=90, vjust=0.5, size=12)) + labs(y="Percentage of total execution time", x="Interaction degree") + scale_y_continuous(labels = percent)
ggsave("distribution_pairwise_lessth3cfgs.pdf")

newCsv <- subset(csvData, !(ConfigMode %in% featurewiseDisabledNoSync) & Mode == 'featurewise')
#newCsv <- csvData[!csvData$ConfigNo %in% c(23, 24)]
newCsv.m <- melt(newCsv,id.vars='Interaction', measure.vars='Perc')
newCsv.m$Perc <- newCsv$Perc
newCsv.m$Mode <- newCsv$Mode
newCsv.m$Interaction <- newCsv$Interaction
p <- ggplot(newCsv.m) + geom_boxplot(aes(x=Interaction, y=value)) + theme(axis.text.x = element_text(angle=90, vjust=0.5, size=12)) + labs(y="Percentage of total execution time", x="Interaction degree") + scale_y_continuous(labels = percent)
ggsave("distribution_featurewise_noNosync.pdf")

csvData.m <- melt(csvData,id.vars='ConfigMode', measure.vars='Perc')
csvData.m$Perc <- csvData$Perc
csvData.m$ConfigMode <- csvData$ConfigMode
csvData.m$ConfigNo <- csvData$ConfigNo
csvData.m$FolderNo <- csvData$FolderNo
csvData.m$Mode <- csvData$Mode
csvData.m$Interaction <- csvData$Interaction
p <- ggplot(csvData.m) + geom_boxplot(aes(x=ConfigMode, y=value)) + theme(axis.text.x = element_text(angle=90, vjust=0.5, size=12)) + labs(y="Percentage of total execution time", x="Interaction degree") + scale_x_discrete(labels=interactions) + scale_y_continuous(labels = percent)
p + facet_wrap( ~ ConfigNo, scales="free_x", ncol=5)
ggsave("distribution_configs.pdf", width=15, height=11)

csvData.m <- melt(csvData,id.vars='FolderMode', measure.vars='Perc')
csvData.m$Perc <- csvData$Perc
csvData.m$FolderMode <- csvData$FolderMode
csvData.m$FolderNo <- csvData$FolderNo
csvData.m$Mode <- csvData$Mode
csvData.m$Interaction <- csvData$Interaction
p <- ggplot(csvData.m) + geom_boxplot(aes(x=FolderMode, y=value)) + theme(axis.text.x = element_text(angle=90, vjust=0.5, size=12)) + scale_x_discrete(labels=interactions) + labs(y="Percentage of total execution time", x="Interaction degree") + scale_y_continuous(labels = percent)
p + facet_wrap( ~ Mode, scales="free_x", ncol=2)
ggsave("distribution_modes.pdf")

csvData.m <- melt(csvData,id.vars='FolderInteractionMode', measure.vars='Perc')
csvData.m$Perc <- csvData$Perc
csvData.m$FolderInteractionMode <- csvData$FolderInteractionMode
csvData.m$FMode <- csvData$FMode
p <- ggplot(csvData.m) + geom_boxplot(aes(x=FolderInteractionMode, y=value)) + theme(axis.text.x = element_text(angle=90, vjust=0.5, size=12)) + labs(y="Percentage of total execution time", x="Interaction degree") + scale_x_discrete(labels=interactions) + scale_y_continuous(labels = percent)
p + facet_wrap( ~ FMode, scales="free_x", ncol=6)
ggsave("distribution_folder_modes.pdf", width=30, height=20)

csvData.m <- melt(csvData,id.vars='Interaction', measure.vars='Perc')
csvData.m$Perc <- csvData$Perc
csvData.m$Interaction <- csvData$Interaction
p <- ggplot(csvData.m) + geom_boxplot(aes(x=Interaction, y=value)) + theme(axis.text.x = element_text(angle=90, vjust=0.5, size=12)) + labs(y="Percentage of total execution time", x="Interaction degree") + scale_y_continuous(labels = percent)
ggsave("distribution.pdf", width=10, height=5)

warnings()
if (!draft) dev.off()
