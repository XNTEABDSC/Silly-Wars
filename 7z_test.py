import py7zr
import os
import re
thisAbsPath=os.path.abspath(".")
thisDirName=os.path.split(thisAbsPath)[1]
thisModName="Silly Wars test"# str.replace(thisDirName," dev.sdd","")
thisModVersion=""
thisModFileName="Silly_Wars_test"
with open("modinfo.lua","r") as filer:
    with open("_modinfo.lua","w") as filew:
        while True:
            linestr=filer.readline()
            if linestr=="":
                break
            matches=re.search("version=['\"](.*?)['\"]",linestr)
            if matches:
                thisModVersion=matches.group(1)
            matches=None
            matches=re.search("(?<=\\W)name=['\"](.*?)['\"]",linestr)
            if matches:
                filew.write(f"\tname='{thisModName}',\n")
                matches=None
            else:
                filew.write(linestr)
def listToDict(list,v=True):
    dc={}
    for i in list:
        dc[i]=v
    return dc

ignoreFileNames=listToDict({
    "modinfo.lua","_modinfo.lua","settings.json","LICENSE","README.md",".gitignore"
})
ignoreFileEnds={".blend",".blend1",".txt",".py",".bat"}
# ignoreDirs={""}

GameDirPath=os.path.split(thisAbsPath)[0]
outputfilename=thisModFileName+"_"+thisModVersion+".sd7"

zip=py7zr.SevenZipFile(os.path.join(GameDirPath,outputfilename),"w")
zip.write("_modinfo.lua","modinfo.lua")
for abspath,dirname,filenames in os.walk(thisAbsPath):
    path=abspath.replace(thisAbsPath,"")
    # print(path)
    if path.startswith("\\."):
        continue
    for filename in filenames:
        if (not ignoreFileNames.get(filename,False)):
            Pass=True
            for i in ignoreFileEnds:
                if filename.endswith(i):
                    Pass=False
                    break
            if Pass:
                zip.write(os.path.join(abspath,filename),os.path.join(path,filename))
zip.close()

