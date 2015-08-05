import re
import sys
import os

def parseTH3Log( logFileName ):
    resultsDict = dict()
    with open(logFileName) as f:
        taskName = ""
        taskResult=""
        for line in f:
            if line.rstrip() == "Begin MISUSE testing." or line.rstrip() == "End MISUSE testing." :
                continue 
                # the misuse statements come from  specific TH3 tests:
                #cov1/main14.test, cov1/main23.test, and cov1/util02.test
                # they interfere with the normal begin/end tags
            if line.startswith("Begin ") :
                #rstrip() removes ALL whitespaces on the right side, including '\n'
                taskName = line.rstrip()[len("Begin "):] # line without "Begin "
                taskResult=""
            elif line.startswith("End ") :
                if not line[len("End "):].startswith(taskName) : 
                    print "Error while parsing task \"" + taskName + "\". Mismatching Begin/End tags."
                else :
                    if (resultsDict.has_key(taskName)) :
                        print "Error: Duplicate task entry \"" + taskName + "\""
                    else : 
                        resultsDict[taskName] = taskResult.rstrip()
            else :
                taskResult= taskResult + line
            #print line
    return resultsDict
def saveListToFile (lst, fileName):
    f = open(fileName,'w')
    for x in lst:
        f.write(str(x) + '\n') # python will convert \n to os.linesep
    f.close()
def saveDictToFile (dct, fileName):
    f = open(fileName,'w')
    for x in dct.keys():
        f.write(x + '->\n') # python will convert \n to os.linesep
        item=dct[x]
        if isinstance(item, string):
            f.write('\t' + dct[x].replace('\n', '\n\t') + '\n') 
        else: # assume that item is a tuple of strings
            f.write('\tsimulatorResult:\n') 
            f.write('\t\t' + item[1].replace('\n', '\n\t') + '\n') 
            f.write('\tvariantResult:\n') 
            f.write('\t\t' + item[1].replace('\n', '\n\t') + '\n') 
    f.close()

def main():
    if (len(sys.argv) != 4) :
        print "Usage: python " + sys.argv[0] + " <Simulator Log> <Variant Log> <output directory>"
        sys.exit(-1) 
    
    simulatorResults = parseTH3Log(sys.argv[1])
    variantResults = parseTH3Log(sys.argv[2])
    
    
    keySet = set(simulatorResults.keys()).union(set(variantResults.keys()))
    onlyInSim = dict() # test present only in simulator log
    onlyInVar = dict() # test present only in variant log
    okInBoth = set()   # empty result in both logs
    sameErrors = dict()# same non-empty result in both logs
    errInSim = dict()  # error in simulator, ok in variant
    errInVar = dict()  # error in variant, ok in simulator
    diffErrors = dict()# different errors
    for key in keySet:
        if (not simulatorResults.has_key(key)):
            onlyInVar[key] = variantResults[key]
        elif (not variantResults.has_key(key)):
            onlyInSim[key] = simulatorResults[key]
        else:
            simResult = simulatorResults[key]
            varResult = variantResults[key]
            if (simResult == varResult):
                if (len(simResult) == 0):
                    okInBoth.add(key)
                else:
                    sameErrors[key] = simResult
            elif (len(simResult)==0) :
                errInVar[key] = varResult
            elif (len(varResult)==0) :
                errInSim[key] = simResult
            else:
                diffErrors[key] = (simResult, varResult)
                
    print "Test only in simLog: " + str(len(onlyInSim))
    print "Test only in varLog: " + str(len(onlyInVar))
    print "bothOK:              " + str(len(okInBoth))
    print "sameErrors:          " + str(len(sameErrors))
    print "differentErrors:     " + str(len(diffErrors))
    print "ErrorOnlyInSim:      " + str(len(errInSim))
    print "ErrorOnlyInVar:      " + str(len(errInVar))
    print "                     ------"
    print "Total tests:         " + str(len(keySet))
    
    outDir = sys.argv[3]
    if not os.path.exists(outDir):
        os.makedirs(outDir)
    
    saveDictToFile(onlyInSim, outDir + "/TestOnlyInSim.txt")
    saveDictToFile(onlyInVar, outDir + "/TestOnlyInVar.txt")
    saveListToFile(okInBoth, outDir + "/OkInBoth.txt")
    saveDictToFile(sameErrors, outDir + "/SameErrors.txt")
    saveDictToFile(diffErrors, outDir + "/DiffErrors.txt")
    saveDictToFile(errInSim, outDir + "/ErrOnlyInSim.txt")
    saveDictToFile(errInVar, outDir + "/ErrOnlyInVar.txt")
    

# call the main function
main()
