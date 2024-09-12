import zipfile
import os
import re
thisAbsPath=os.path.abspath(".")
thisDirName=os.path.split(thisAbsPath)[1]
thisModName="Silly Wars"# str.replace(thisDirName," dev.sdd","")
thisModVersion=""
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



GameDirPath=os.path.split(thisAbsPath)[0]
outputfilename=thisModName+" "+thisModVersion+".sdz"

zip=zipfile.ZipFile(os.path.join(GameDirPath,outputfilename),"w")
zip.write("_modinfo.lua","modinfo.lua")
for abspath,dirname,filenames in os.walk(thisAbsPath):
    path=abspath.replace(thisAbsPath,"")
    for filename in filenames:
        if filename!="modinfo.lua" and filename!="_modinfo.lua" and filename!="settings.json" and (not filename.endswith(".blend")) and (not filename.endswith(".blend1")):
            zip.write(os.path.join(abspath,filename),os.path.join(path,filename))
zip.close()

