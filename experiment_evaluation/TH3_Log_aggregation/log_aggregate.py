import re
import sys
import os


logDirectory="/home/garbe/sqlite/"
diffFN = "DiffErrors.txt"
SerrFN = "ErrOnlyInSim.txt" 
VerrFN = "ErrOnlyInVar.txt"
okFN = "OkInBoth.txt"
sameErrFN = "SameErrors.txt"
sTestFN = "TestOnlyInSim.txt"
vTestFN = "TestOnlyInVar.txt"
timeSimPrefix = "time_simulator"
timeVarPrefix = "time_variant"


def saveListToFile (lst, fileName):
    f = open(fileName,'w')
    for x in lst:
        f.write(str(x) + '\n') # python will convert \n to os.linesep
    f.close()
def saveDictToFile (dct, fileName):
    f = open(fileName,'w')
    for x in dct.keys():
        f.write(x + '->\n') # python will convert \n to os.linesep
        f.write('\t' + dct[x].replace('\n', '\n\t') + '\n') 
    f.close()
    
def fileExistsNonEmpty (filename):
    if os.path.isfile(filename): return os.stat(filename).st_size > 0
    else: return False


def main():
    if (len(sys.argv) != 1) :
        print "Usage: python " + sys.argv[0]
        sys.exit(-1) 
    timesFile = open("times.csv",'w')
    timesFile.write("SsysTime\tSusrTime\tSrealTime\tSmaxMemory\tVsysTime\tVusrTime\tVrealTime\tVmaxMemory\n")
    
    for dirName in os.listdir(logDirectory):
        dirPath = logDirectory+dirName+"/"
        if os.path.isdir(dirPath):
            print dirPath
            if not fileExistsNonEmpty(dirPath + sTestFN) and not fileExistsNonEmpty(dirPath + vTestFN) and not fileExistsNonEmpty(dirPath + SerrFN) and not fileExistsNonEmpty(dirPath + VerrFN) and not fileExistsNonEmpty(dirPath + diffFN):
                # test case checked the same stuff (executed same code?)
                stimeFile = open(dirPath+ [fn for fn in os.listdir(dirPath) if fn.startswith(timeSimPrefix)][0] , 'r')
                vtimeFile = open(dirPath+  [fn for fn in os.listdir(dirPath) if fn.startswith(timeVarPrefix)][0], 'r')
                sTimeLine= stimeFile.readlines()[-1]
                vTimeLine= vtimeFile.readlines()[-1]
                stimeFile.close()
                vtimeFile.close()
                sTimeLine=re.sub(r"TH3execTime:sys:", "", sTimeLine)
                sTimeLine=re.sub(r"usr:", "", sTimeLine)
                sTimeLine=re.sub(r"real:", "", sTimeLine)
                sTimeLine=re.sub(r"mem:", "", sTimeLine)
                sTimeLine=re.sub(r"\n", "", sTimeLine)
                sTimeLine=re.sub(r",", "\t", sTimeLine)
                vTimeLine=re.sub(r"TH3execTime:sys:", "", vTimeLine)
                vTimeLine=re.sub(r"usr:", "", vTimeLine)
                vTimeLine=re.sub(r"real:", "", vTimeLine)
                vTimeLine=re.sub(r"mem:", "", vTimeLine)
                vTimeLine=re.sub(r"\n", "", vTimeLine)
                vTimeLine=re.sub(r",", "\t", vTimeLine)
                timesFile.write(sTimeLine+"\t"+vTimeLine+"\n")
                
    timesFile.close()

# call the main function
main()
