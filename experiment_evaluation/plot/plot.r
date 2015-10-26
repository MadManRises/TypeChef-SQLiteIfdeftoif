draft = F
#if (draft) dev.off()


options(width=180)
csvData <- read.csv(file=paste("ft_exclusive_09_10_15.csv",sep=""),head=TRUE, sep=",", na.strings=c("","NA"))

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

# boxplots

#print (csvData)

pdf(file=paste("plot_Boxplots",".pdf",sep=""), width=7, height=5, onefile=TRUE, paper="special") 

boxplot(csvData$TimeDiff~csvData$TestDir, 
	col=c(solarizeColors[1],solarizeColors[4],solarizeColors[9], solarizeColors[5]),
	ylab="Difference simulator time - variant time in percent", 
	xlab="TH3 test directories")

warnings()
if (!draft) dev.off()
