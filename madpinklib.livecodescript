-- MadPinkLib  1.5.133

function getPinks pName
   replace space with empty in pName
   switch pName
      case "deeppink"
      case "deep"
         return hexToRGB("FF1493")
         break
      case "spicypink"
      case "spicy"
         return hexToRGB("FF1CAE")
         break
      case "shockingpink"
      case "shocking"
      case "shock"
         return hexToRGB("FF0FC0")
         break
      case "brightpink"
      case "bright"
      case "brite"
         return hexToRGB("FF007F")
         break
      case "hollywoodpink"
      case "hollywood"
         return hexToRGB("F400A1")
         break
      case "cerise"
         return hexToRGB("DA3287")
         break
   end switch
end getPinks

on ___DataFiles___
end ___DataFiles___

command mpDataFile pData pPropSet pFileName pSupportFol pSFP pStackName
   /*
   REQUIRED:
   pData - data to save, or command(load, close, folder, filepath); 
   if "load" the data is put into "the result"
   OPTIONAL:
   pPropSet - name of the property set to save/load
   pFileName - file name for the save file
   pSupportFol - folder and subfolder(s) to store file
   pSFP - special folder path in which to put the above folders
   pStackName - name for the save stack
   */
   
   local tPath, tFolder, tKey
   -----
   if pPropSet is empty then put "mpData" into pPropSet
   if pFileName is empty then put "MadPinkApp.mpd" into pFileName
   if pSupportFol is empty then put "MadPink/TestData" into pSupportFol
   set itemdel to "."
   if pStackName is empty then put item 1 to -2 of pFileName & "_Data" into pStackName
   -----
   if pData is "close" then
      close stack pStackName
      return "Completed"
   end if
   -----
   if pSFP is not empty then
      put specialFolderPath(pSFP) into tPath
   else if pSFP is "usepath" then
      put empty into tPath
   else if the platform is "MacOS" or the platform is "Win32" then
      put specialFolderPath("support") into tPath
   else if the platform is "iphone" or the platform is "android" then
      put specialFolderPath("documents") into tPath
   else
      put specialFolderPath("home") into tPath
   end if
   -----
   set itemdel to "/"
   repeat for each item tFolder in pSupportFol
      put "/" & tFolder after tPath
      if there is not a directory tPath then create folder tPath
   end repeat
   set the defaultFolder to tPath
   if pData is "folder" then return tPath
   put "/" & pFileName after tPath
   if pData is "filepath" then return tPath
   
   if pStackName is not among the lines of the openStacks then 
      if there is no file tPath then
         create invisible stack pStackName
         set the destroyStack of stack pStackName to true
         save stack pStackName as tPath
      else
         open invisible stack tPath
      end if
   end if
   
   if pData is "load" then
      return the customProperties[pPropSet] of stack pStackName
   else
      set the customProperties[pPropSet] of stack pStackName to pData
      save stack pStackName as tPath
      break
   end if  
end mpDataFile

on ___FilesToData___
end ___FilesToData___

function mpDataFromFiles pPath
   if there is not a folder pPath then return empty
   
   put files(pPath) into tFileList
   repeat for each line tFile in tFileList
      if tFile is ".." then next repeat
      put "binfile:" & pPath & "/" & tFile into tFileName
      put (compress(url tFileName)) into tData[tFile]
   end repeat
   
   put folders(pPath) into tBaseList
   repeat for each line tF in tBaseList
      if tF is ".." then next repeat
      put pPath & "/" & tF into tNewPath
      put dataFromFiles(tNewPath) into tData[tF]
   end repeat
   
   return tData
end mpDataFromFiles

command mpSaveFilesFromData pData pFolder pPath
   if there is not a folder pPath then
      create folder pPath
   end if
   if pFolder is not empty then
      put pPath & "/" & pFolder into tNewF
      if there is not a folder tNewF then 
         create folder tNewF
      end if
   else
      put pPath into tNewF
   end if
   
   put the keys of pData into tDList
   repeat for each line tX in tDlist
      if pData[tX] is an array then
         mpSaveFilesFromData pData[tX],tX,tNewF
      else
         put tNewF & "/" & tX into tFileName
         put "binfile:" before tFileName
         put (decompress(pData[tX])) into url tFileName
      end if
   end repeat
end mpSaveFilesFromData


on ___BASICS___
end ___BASICS___

function enQ pText
   --DX desc Enquote the text
   --DX param pText - text to enquote
   --DX returns the text in quotes
   put quote before pText
   put quote after pText
   return x
end enQ

function quazQ pText
   --DX param pText - text to quaqua quote
   replace quote with "qzQ" in pText
   return pText
end quazQ

function deQz pText
   --DX param pText - text to deQuazquafy
   replace "qzQ" with quote in pText
   return pText
end deQz

command showGroup pGroup
   --DX param pGroup - group to display
   set the vis of group pGroup to true
   set the layer of group pGroup to top
end showGroup

command hideGroup pGroup
   --DX param pGroup - group to hide
   set the vis of group pGroup to false
end hideGroup

function thymeStamp pType pPrefix pTime
   local tThyme
   --DX param pPrefix - optional, prefix to use
   --DX param pType - optional, z=seconds; s=seconds; m=minutes; d=day
   --DX param pTime - optional, time to use instead of now
   if pTime is empty then put the seconds into pTime
   if pType is "z" then 
      convert pTime to seconds
      if pPrefix is not empty then put pPrefix before pTime
      return pTime
   end if
   convert pTime to dateItems
   if pPrefix is not empty then put pPrefix into tThyme
   set itemdel to comma
   put item 1 of pTime after tThyme
   if item 2 of pTime < 10 then put 0 after tThyme
   put item 2 of pTime after tThyme
   if item 3 of pTime < 10 then put 0 after tThyme
   put item 3 of pTime after tThyme
   if pType is "d" then return tThyme
   if item 4 of pTime < 10 then put 0 after tThyme
   put item 4 of pTime after tThyme
   if item 5 of pTime < 10 then put 0 after tThyme
   put item 5 of pTime after tThyme
   if pType is "m" then return tThyme
   if item 6 of pTime < 10 then put 0 after tThyme
   put item 6 of pTime after tThyme
   return tThyme
end thymeStamp

command incrementVersion pType pField
   --DX param pType - [build], patch, minor, major - item to increment
   --DX param pField - optional, if you want to fill a field with the number
   set the itemdel to "."
   put the cVersion of this stack into tVersion
   if tVersion is empty then put "0.0.0" into tVersion
   put the cBuild of this stack into tBuild
   if cBuild is empty then put 0 into tBuild
   add 1 to tBuild
   switch pType
      case "patch"
         add 1 to item 3 of tVersion
         break
      case "minor"
         add 1 to item 2 of tVersion
         break
      case "major"
         add 1 to item 1 of tVersion
         break
      case "build"
      default
   end switch
   set the cRevStandaloneSettings["ios,bundle version"] of this stack to tVersion
   set the cVersion of this stack to tVersion
   set the cBuild of this stack to tBuild
   if pField is not empty then put tVersion into field pField
end incrementVersion

function scanScriptForDox pScript
   set itemdel to space
   repeat for each line tLine in pScript
      repeat
         if char 1 of tLine is space then put char 2 to -1 of tLine into tLine else exit repeat
      end repeat
      if item 1 of tLine is "command" or item 1 of tLine is "function" then
         
      else if char 1 to 4 of tLine is not "--DX" then 
         next repeat
      else
         put item 2 to -1 of tLine into tLine
      end if
      put item 1 of tLine into tItem
      put char 1 to 4 of tItem into tItem
      switch tItem
         case "comm"
         case "func"
            put cr before tLine
            break
         case "desc"
            put item 2 to -1 of tLine into tLine
            put space & space before tLine
            -- put "--" before tLine
            break
         case "para"
         case "exam"
         case "retu"
            put space & space & space & space before tLine
            break
         case "z"
            put space & space & space & space & space before tLine
            break
      end switch
      put tLine & cr after tDocList
   end repeat
   return char 2 to -1 of tDocList 
end scanScriptForDox


on __AYANS__
end __AYANS__

/* 
-- libAYANS 0.3.14
And Yet Another Simple Notation System

indentation doesn't matter, just for readability
any leading spaces are deleted, to put actual leading spaces in use "~"

single key value combos
   =  value inline
   ==  single value is the next line
   |  single value spans mutliple lines including line breaks
   >  single value spans multiple lines substituting space for line breaks
   -  simple array of items
   !  complex/nested array


=pival; 3.1415
_thekey;
   this is the value
=somekey; this is also the value
>newkey;
   this is also
   the value
   ;newkey
|poem;
   There is in the lab said the dean
   Quite a remarkable machine
   ~  Where Oedpius Rex
   ~  Could have learned about sex
   Without any help from the Queen
   ;poem
-grocerylist;
   eggs
   bacon
   coffee
   ;grocerylist
!thearray;
   =abc; 123
   =def; reststop
   =coffee; needed
   ;thearray

*/


function aya2array pText
     --DX param pText - text to decode to array
     put removeLeadSpaces(pText) into pText
     set itemdel to space
     put the number of lines in pText into tEOF
     put 0 into x
     repeat while x <= tEOF
          add 1 to x
          put parseLine(line x of pText) into tLine
          put tLine["var"] into tVar
          if tVar is empty then next repeat
          put empty into tCombinedLines
          
          switch tLine["type"]
               case "="
                    put tLine["value"] into theResult[tVar]
                    next repeat
                    break
               case "_"
                    add 1 to x
                    put xSpc(line x of pText) into theResult[tVar]
                    next repeat
                    break
               default
                    add 1 to x
                    put findRange(tEOF,tLine["indicator"],x,pText) into tEnd
                    put xSpc(line x to tEnd of pText) into tCombinedLines
                    put tEnd+1 into x    
          end switch
          
          switch tLine["type"]
               case "|"   ---multiple lines with line breaks
                    put tCombinedLines into theResult[tVar]
                    break
               case ">"   ---multiple lines with spaces
                    put tCombinedLines into theResult[tVar]
                    replace cr with space in theResult[tVar]
                    break
               case "-"   ---unordered array
                    put 1 into tKey
                    repeat for each line tLineVal in tCombinedLines
                         put line tKey of tCombinedLines into theResult[tVar][tKey]
                         add 1 to tKey
                    end repeat
                    break
               case "!"   ---complex array         
                    put aya2array(tCombinedLines) into theResult[tVar]
                    break
          end switch
     end repeat
     return theResult
end aya2array

function array2aya pText pDepth
     --DX param pText - array to convert to AYA
     --DX param pDepth - [0] - number for extra indent space
     if pDepth is empty then put 0 into pDepth
     put indSpace(pDepth) into tIndentKey
     put indSpace(pDepth+1) into tIndentValue
     repeat for each key tKey in pText
          put pText[tKey] into tValue
          switch
               case tValue is an array
                    if numArray(tValue) then 
                         put tIndentKey & "-" & tKey & ";" & cr after tAYA
                         repeat for each key tSubKey in tValue
                              put tIndentValue & tValue[tSubKey] & cr after tAYA
                         end repeat
                         put tIndentValue &";" & tKey  & cr after tAYA
                    else
                         put tIndentKey & "!" & tKey & ";" & cr after tAYA
                         put array2aya(tValue,pDepth+1)  after tAYA
                         put tIndentValue &";" & tKey  & cr after tAYA
                    end if
                    break
               case tValue is empty
                    put "=" & tIndentKey & tKey && "= null" & cr after tAYA
                    break
               case the number of lines in tValue > 1
                    repeat with x=1 to the number of lines in tValue
                         put iSpc(line x of tValue) into tLine
                         put tIndentValue & tLine into line x of tValue
                    end repeat
                    put tIndentKey &"|" & tKey & ";" & cr after tAYA
                    put tValue & cr after tAYA
                    put tIndentValue &";" & tKey  & cr after tAYA
                    break
               default
                    put tIndentKey & "=" & tKey & ";" && iSpc(tValue) &cr after tAYA
                    break
          end switch
     end repeat
     return tAYA
end array2aya

private function indSpace pDepth pBase
     if pBase is empty then put 3 into pBase
     if pDepth is 0 then return empty
     put pBase * pDepth into tX
     repeat with x=1 to tX
          put space after tIndentMe
     end repeat
     return tIndentMe
end indSpace

private function parseLine pTextLine
     set itemdel to space
     put item 1 of pTextLine into tVar
     put char 1 of tVar into pLine["type"]
     put char -1 of tVar into pLine["end"]
     switch pLine["end"]
          case ";"
          case ":"
               put char 2 to -2 of tVar into pLine["var"]
               break
          default
               put char 2 to -1 of tVar into pLine["var"]
               break
     end switch
     put ";" & pLine["var"] into pLine["indicator"]
     put xSpc(item 2 to -1 of pTextLine) into pLine["value"]
     return pLine
end parseLine

private function removeLeadSpaces pText
     repeat for each line tLine in pText
          if tLine is empty then next repeat
          repeat until char 1 of tLine is not space
               put char 2 to -1 of tLine into tLine 
          end repeat   
          put tLine & cr after tFixed
     end repeat
     return tFixed
end removeLeadSpaces

private function numArray pArray
   put the keys of pArray into tKeys
   filter tKeys without "[0-9]*"
   if the number of lines in tKeys > 0 then return false
   else return true
end numArray

private function findRange pEOF pIndicator pX pText
     repeat until pX is pEOF
          add 1 to pX
          if line pX of pText is pIndicator then return pX-1
     end repeat
     return pEOF 
end findRange

private function xSpc pCheckText
     repeat with z=1 to the number of lines in pCheckText
          if char 1 of line z of pCheckText is "~" then put space into char 1 of line z of pCheckText
     end repeat
     return pCheckText
end xSpc

private function iSpc pCheckText
     repeat with z=1 to the number of lines in pCheckText
          if char 1 of line z of pCheckText is space then put "~" into char 1 of line z of pCheckText
     end repeat
     return pCheckText
end iSpc


on ___ArrayStuff___
end ___ArrayStuff___

function displayArrayData pArray, pIndent
    # create the variable that loops through the keys in the array
    local tKey
    if pArray is an array then
        # print information to indicate that we are entering a new nested level of the array
        get "Array" & return
        # print full stops that allow the reader to track the depth of an element
        put "." after pIndent
        # create the indentation
        put tab after pIndent
        repeat for each key tKey in pArray
            # call displayArrayData with a nested array
            put format("%s[%s] => %s\n", pIndent, tKey, displayArrayData (pArray[tKey], pIndent)) after it
        end repeat
        delete the last char of it
        return it
    else
        return pArray
    end if 
end displayArrayData

command arrayToFile pArray,pFileName
     if there is a file pFileName then delete file pFileName
     put base64encode(arrayEncode(pArray)) into URL ("file:" & pFileName)
end arrayToFile

command fileToArray pFileName, pArray
     put url ("file:" & pFileName) into myFile
     put arrayDecode(base64decode(myFile)) into pArray
end fileToArray


function RenameKeyArray pArray, pCurrentKey, pNewKey
     local tElementValue
     put pArray[pCurrentKey] into tElementValue
     delete variable pArray[pCurrentKey]
     put tElementValue into pArray[pNewKey]
     return pArray
end RenameKeyArray

