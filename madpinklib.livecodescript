--name:  libMadPink
--vers:  2.5.0
--date:  2022-01-29
--full:  MadPink Master Lib

on __Documentation_Template__
   
   /*
   First version is simple
   */
   
   --handler commandOrFunctionName
   --desc Insert description here 
   --param pVal - the current counter value
   --returns - (number/boolean/string)
   --trigger - field/widget/button names
   --effects - field/widget/button names
   
   /*
   Second version is more detailed
   */
   
   --fnord
   
   
   /*  help: commandOrFunctionName
   PARAMETERS:
   pParam (required) parameter description; fixed options
   --"open" first of parameter options
   --"close" second of parameter options
   ----default: "open"
   pParam2 (optional)  parameter description; boolean/numeric/text
   ----default: true
   
   DESCRIPTION: insert_description_here
   
   returns - (number/boolean/string)
   trigger - field/widget/button names
   */
   
   
   --don't panic
end __Documentation_Template__

function getPink pName
   put char 1 to 3 of pName into pName
   switch pName
      case "dee"  -- DeepPink
         return hexToRGB("FF1493")
         break
      case "spi"  -- SpicyPink
         return hexToRGB("FF1CAE")
         break
      case "sho"  -- ShockingPink
         return hexToRGB("FF0FC0")
         break
      case "bri"  -- BrightPink
         return hexToRGB("FF007F")
         break
      case "hol"  -- HollywoodPink
         return hexToRGB("F400A1")
         break
      default
      case "cer"  -- Cerise
         return hexToRGB("DA3287")
         break
   end switch
end getPink

on ___DATAFILES___
end ___DATAFILES___

command mpDataFile pData pPropSet pFileName pSupportFol pSFP pStackName
   /*
   REQUIRED:
   pData - data to save, or command(load, close); 
   --"load" the data from the file is put into "the result"
   --"close" the data file will be closed
   
   OPTIONAL:
   --pPropSet - name of the property set to save/load, default: mpData
   --pFileName - file name for the save file, default: MadPinkApp.mpd
   --pSupportFol - folder and subfolder(s) to store file, default: pink.mad.data/STACKNAME
   --pSFP - special folder path in which to put the above folders, default is based on operating system
   --pStackName - name for the save stack, default is the filename without extension plus "_Data"
   */
   local tPath, tFolder, tKey
   -----
   set itemdel to "."
   
   if pPropSet is empty then
      put "mpData" into pPropSet
   end if
   
   put mpGenerateFilePath(pFileName, pSupportFol, pSFP) into tPath
   
   if pFileName is empty then 
      put "MadPinkApp.mpd" into pFileName
   end if
   
   if pStackName is empty then
      put item 1 to -2 of pFileName & "_Data" into pStackName
   end if
   
   if pData is "close" then
      close stack pStackName
      return "Completed"
   end if
      
   set the defaultFolder to tPath

   put "/" & pFileName after tPath
   
   if pData is "filepath" then 
      return tPath
   end if
   
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

function mpDataFileLoad pPropSet pFileName pSupportFol pSFP pStackName
   mpDataFile, "load", pPropSet, pFileName, pSupportFol, pSFP, pStackName
   return the result
end mpDataFileLoad

function mpDataFilePath pPropSet pFileName pSupportFol pSFP pStackName
   mpDataFile, "filepath", pPropSet, pFileName, pSupportFol, pSFP, pStackName
   return the result
end mpDataFilePath

function mpGenerateFilePath pFileName pSupportFol pSFP
   local tPath, tFolder
   -----
   
   if pFileName is empty then 
      put "MadPinkApp.mpd" into pFileName
   end if
   
   if pSupportFol is empty then 
      put "pink.mad.data/" & item 1 to -2 of pFileName into pSupportFol
      replace space with "_" in pSupportFol
   end if
   
   if pStackName is empty then
      put item 1 to -2 of pFileName & "_Data" into pStackName
   end if
   
   if pData is "close" then
      close stack pStackName
      return "Completed"
   end if
   
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
   
   set itemdel to "/"
   
   repeat for each item tFolder in pSupportFol
      put "/" & tFolder after tPath
      if there is not a directory tPath then 
         create folder tPath
      end if
   end repeat
   
   set the defaultFolder to tPath
   
   put "/" & pFileName after tPath
   
   return tPath
end mpGenerateFilePath 
   
on ___TEXTFILES___
end ___TEXTFILES___

command mpTextFileWrite pText pFileName pSupportFol pSFP
   /*
   REQUIRED:
   pText - data to load
   
   OPTIONAL:
   --pFileName - file name for the save file, default: MadPinkApp.mpd
   --pSupportFol - folder and subfolder(s) to store file, default: pink.mad.data/STACKNAME
   --pSFP - special folder path in which to put the above folders, default is based on operating system
   */
   local tPath
   -----
   
   if pFileName is empty then 
      put "MadPinkApp.txt" into pFileName
   end if
   
   put mpGenerateFilePath(pFileName, pSupportFol, pSFP) into tPath
   
   set the defaultFolder to tPath 
   put "/" & pFileName after tPath
   
   open file tPath for write 
   write pText to file tPath
   close file tPath
   
end mpTextFileWrite

command mpTextFileRead pFileName pSupportFol pSFP
   /*
   REQUIRED:
   OPTIONAL:
   --pFileName - file name for the save file, default: MadPinkApp.txt
   --pSupportFol - folder and subfolder(s) to store file, default: pink.mad.data/STACKNAME
   --pSFP - special folder path in which to put the above folders, default is based on operating system
   */
   local tPath, tText
   -----
   
   if pFileName is empty then 
      put "MadPinkApp.txt" into pFileName
   end if
   
   put _mpGenerateFilePath(pFileName, pSupportFol, pSFP) into tPath
   
   set the defaultFolder to tPath 
   put "/" & pFileName after tPath
   
   open file tPath for read
   read from file tPath until EOF
   put it into tText
   close file tPath
   return tText
end mpTextFileRead

on ___STATS___
end ___STATS___

function freqFromArray pArray pMap pReturn
   local tFreqs, tMapDepth, tValueToCount, tList, tRecord
   
   set itemdel to semicolon
   
   put (the number of items in pMap)into tMapDepth
   put the keys of pArray into tList
   
   repeat for each line x in tList
      put pArray[x] into tRecord
      repeat with y=1 to tMapDepth
         put tRecord[item y of pMap] into tRecord
      end repeat
      if tRecord is empty then 
         next repeat
      else
         repeat for each item z in tRecord
            add 1 to tFreqs[z]
         end repeat
      end if
   end repeat
   
   if pReturn is "array" then
      return tFreqs
   else
      return freqArrayFlatten(tFreqs)
   end if
end freqFromArray 

private function freqArrayFlatten pArray
   local tList, tFreqTable
   put the keys of pArray into tList
   sort tList
   repeat for each line x in tList
      put x & tab & pArray[x] & cr after tFreqTable
   end repeat
   return tFreqTable
end freqArrayFlatten

on ___BASICS___
end ___BASICS___

function doEveryX pVal pX
   --desc Use when you want something to happen at certain intervals, for example provide update everytime the counter pass a multiple of 100
   --param pVal - the current counter value
   --param pX - the base to work on for example '100'
   --returns - boolean
   if (pVal/pX) = trunc(pVal/pX) then
      return true
   else
      return false
   end if
end doEveryX

command showGroup pGroup
   --param pGroup - group to display
   set the vis of group pGroup to true
   set the layer of group pGroup to top
end showGroup

command hideGroup pGroup
   --param pGroup - group to hide
   set the vis of group pGroup to false
end hideGroup

command setTreeData pData pTree
   if pTree is empty then
      put "treeData" into pTree
   end if
   set the arrayData of widget pTree to pData
end setTreeData

function getTreeData pTree
   if pTree is empty then
      put "treeData" into pTree
   end if
   return the arrayData of widget pTree
end getTreeData

function fixVal pValue pDefault pOtherRule
   if pValue is empty then
      return pDefault
   end if
   
   switch pOtherRule
      case "number"
         if pValue is not a number then
            return pDefault
         end if
         break
      case "string"
         if pValue is not text then
            return pDefault
         end if
         break
      case "array"
         if pValue is not an array then
            return pDefault
         end if
         break
   end switch
   
   return pValue
end fixVal

on ___TEXT_AND_NUMBERS___
end ___TEXT_AND_NUMBERS___

command txtFormat pStyle
   --param pStyle - plain, bold, box, italic, underline, strikeout
   if pStyle is "plain" or pStyle is empty then
      set the textStyle of selectedText to plain
   else if the selectedText is not empty then
      set the textStyle[pStyle] of selectedText to not(the textStyle[pStyle] of selectedText)
   end if
end txtFormat

command txtAlign pAlign
   --param pStyle - center, left, right
   set the textAlign of selectedText to pAlign   
end txtAlign 

command txtSize pSize pStep
   local tSetSize
   
   if pStep is empty then
      put 2 into pStep
   end if
   
   put the textSize of selectedText into tSetSize
   
   if pSize is "up" then
      add pStep to tSetSize
   else if pSize is "down" then
      subtract pSize from tSetSize
   end if
   
   set the textSize of selectedText to tSetSize
end txtSize

command txtFont pFont
   if pFont is "Fixed" then
      put "Courier" into pFont
   else if pFont is empty then
      put "Arial" into pFont
   end if
   
   set the textFont of selectedText to pFont
end txtFont

function padZero pNum pDigits
   local tFixer, tUpper
   --param pNum - number to pad
   --param pDigits - number of digits to pad
   put 10 ^ pDigits into tFixer
   subtract 1 from pDigits
   put 10 ^ pDigits into tUpper
   if pNum < tUpper then 
      add tFixer to pNum
      put char 2 to -1 of pNum into pNum
   end if
   return pNum
end padZero

function padText pText pLength pPadWith pPlace
   --DX param pText - Text to pad
   --DX param pLength - number of places to have in total
   --DX param pPad - [space] - item to use for padding
   --DX param pPlace - [end],start - where to pad
   if pPadWith is empty then put space into pPadWith
   subtract length(pText) from pLength
   if pLength < 1 then return pText
   repeat pLength times
      switch pPlace
         case "start"
            put pPadWith before pText
            break
         default
         case "end"
            put pPadWith after pText
            break
      end switch
   end repeat
   return pText
end padText

function enQ pText
   --desc Enquote the text
   --param pText - text to enquote
   --returns the text in quotes
   put quote before pText
   put quote after pText
   return pText
 end enQ
 
function qzQ pText
  return quazQua(pText,"decode")
end qzQ

function qzZ pText
  return quazQua(pText,"encode")
end qzZ

function quazQua pText pDirection pMaintainPlaceholder
   if pMaintainPlaceholder is true then
      replace "qzqzz" with "q1z1q1z1" in pText
      replace "qzqxx" with "q1z1q1x1" in pText
   end if
   switch pDirection
      case "fullencode"
      case "fenc"
         replace quote with "qzqq" in pText
         replace quote & comma & quota with "qzqv" in pText
         replace "'" with "qzqa" in pText
         replace cr with "qzqz"in pText
         replace tab with "qzqt" in pText
         replace colon with "qzqc" in pText
         replace semicolon with "qzqs" in pText
         break
      case "fulldecode"
      case "fdec"
         replace "qzqq" with quote in pText
         replace "qzqz" with cr in pText
         replace "qzqt" with tab in pText
         replace "qzqv" with quote & comma & quota in pText
         replace "qzqa" with "'" in pText
         replace "qzqc" with colon in pText
         replace "qzqs" with semicolon in pText         
         break
      case "encode"
      case "qit"
         replace quote with "qzqq" in pText
         replace cr with "qzqz"in pText
         replace tab with "qzqt" in pText
         break
      case "decode"
      case "unq"
      default
         replace "qzqt" with tab in pText
         replace "qzqz" with cr in pText
         replace "qzqq" with quote in pText
         break
   end switch
   if pMaintainPlaceholder is true then
      replace "q1z1q1z1" with "qzqzz" in pText
      replace "q1z1q1x1" with "qzqxx" in pText
   end if
   
   return pText
end quazQua

function thymeStamp pType pPrefix pTime pOffset
   local tThyme
   --param pPrefix - optional, prefix to use
   --param pType - optional, z=seconds; s=seconds; m=minutes; d=day
   --param pTime - optional, time to use instead of now
   --param pOffset - optional, seconds to offset
   
   if pTime is empty then 
      put the seconds into pTime
   end if
   
   if pPrefix is not empty then 
      put pPrefix into tThyme
   end if
   
   if pType is not empty then
      put char 1 of pType into pType
   else
      put "s" into pType
   end if
   
   if pOffset is true or pOffset is "v" then
      put 1508342097 into pOffset
   end if
   
   if pType is "z" then 
      convert pTime to seconds
      subtract pOffset from pTime
      put pTime after tThyme
      return tThyme
   end if
   
   convert pTime to dateItems
   set itemdel to comma
   put item 1 of pTime after tThyme
   put padZero(item 2 of pTime,2) after tThyme
   put padZero(item 3 of pTime,2) after tThyme
   
   if pType is "d" then 
      return tThyme
   end if
   
   put padZero(item 4 of pTime,2) after tThyme
   put padZero(item 5 of pTime,2) after tThyme
   
   if pType is "m" then 
      return tThyme
   end if
   put padZero(item 6 of pTime,2) after tThyme
   return tThyme
end thymeStamp

on ___SCRIPTS_AND_STACKS___
end ___SCRIPTS_AND_STACKS___

command updateVersionNumber pType pName
   local tProps, tVers
   
   put the customProperties["cRevStandaloneSettings"] of this stack into tProps
   switch pType
      case "major"
         add 1 to tProps["Windows,fileversion1"]
         break
      case "minor"
         add 1 to tProps["Windows,fileversion2"]
         break
      case "sub"
         add 1 to tProps["Windows,fileversion4"]
         break
      case "build"
      default
         add 1 to tProps["Windows,fileversion3"]
         break
   end switch
   
   if pName is empty then
      put tProps["Windows,ProductName"] into pName
   else
      put pName into tProps["Windows,ProductName"]
   end if
   
   put tProps["Windows,fileversion1"] & "." & tProps["Windows,fileversion2"] & "." & tProps["Windows,fileversion3"] into tVers
   if pType is "sub" then
      put "." & tProps["Windows,fileversion4"] into tVers
   end if
   put pName & tVers into tProps["name"]
   put pName && tVers && "For Windows" into tProps["Windows,FileDescription"]
   put pName & tVers into tProps["OSX,name"]
   put pName && tVers into tProps["OSX,longVersion"]
   put tVers into tProps["OSX,shortVersion"]
   
   set the customProperties["cRevStandaloneSettings"] of this stack to tProps
end updateVersionNumber

command incrementVersion pType pName pField pCurrent
   local tVersion, tBuild, tProps
   --param pType - [build], patch, minor, major - item to increment
   --param pName - optional, application name if you want to append version and include it (use "current" to play with whatever is already there)
   --param pField - optional, if you want to fill a field with the number
   --param pCurrent - optional, use if you want to manually start at a certain point (or if cVersion is empty)
   set the itemdel to "."
   put the customProperties["cRevStandaloneSettings"] of this stack into tProps
   if pCurrent is empty then
      put the cVersion of this stack into tVersion
   else
      put pCurrent into tVersion
   end if
   if tVersion is empty then put "0.0.0" into tVersion
   put the cBuild of this stack into tBuild
   if tBuild is empty then put 1 into tBuild
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
         add 1 to tBuild
         break
   end switch
   put tVersion into tProps["ios,bundleversion"]
   put item 1 of tVersion into tProps["Windows,fileversion1"]
   put item 2 of tVersion into tProps["Windows,fileversion2"]
   put item 3 of tVersion into tProps["Windows,fileversion3"]
   put tBuild into tProps["Windows,fileversion4"]
   put tVersion into tProps["ios,bundle version"]
   if pName is "current" then
      put tProps["Windows,ProductName"] into pName
   end if
   if pName is not empty then
      put pName into tProps["Windows,ProductName"]
      put pName & tVers into tProps["name"]
      put pName && tVers && "For Windows" into tProps["Windows,FileDescription"]
      put pName & tVers into tProps["OSX,name"]
      put pName && tVers into tProps["OSX,longVersion"]
      put tVers into tProps["OSX,shortVersion"]
   end if
   set the customProperties["cRevStandaloneSettings"] of this stack to tProps
   set the cVersion of this stack to tVersion
   set the cBuild of this stack to tBuild
   if pField is not empty then put tVersion into field pField
end incrementVersion

function scanScriptForDox pScript
   local tLine, tItem, tDocList
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

on ___AGE_AND_DATES__
end ___AGE_AND_DATES__

--631152000  20
--1262304000 40
--1893456000 60
--2524608000 80

function unixAge pSec
 return calculateAge("seconds",pSec)
end unixAge

function dateItemsToSeconds pDate
  set itemdel to comma
  put item 1 of pDate into tYear
  if tYear >=1970 then
     convert pDate to seconds
  else if tYear >= 1950 then
     add 20 to item 1 of pDate
     convert pDate to seconds
     subtract 631152000 from pDate
  else if tYear >= 1930 then
     add 40 to item 1 of pDate
     convert pDate to seconds
     subtract 1262304000 from pDate
  else if tYear >= 1910 then
     add 60 to item 1 of pDate
     convert pDate to seconds
     subtract 1893456000 from pDate
  else if tYear >= 1890 then
     add 80 to item 1 of pDate
     convert pDate to seconds
     subtract 2524608000 from pDate      
  end if
  if pDate is not a number then return empty
  return pDate
end dateItemsToSeconds

function dateToSeconds pDate
  if pDate ends with "00:00:00" then 
     put char 1 to -10 of pDate into pDate
     set itemdel to tab
     replace "-" with tab in pDate
     put item 2 of pDate & slash & item 3 of pDate & slash & item 1 of pDate into pDate
  end if
  set itemdel to "/"
  put item 3 of pDate into tY
  if tY < 20 then 
     add 2000 to tY
  else if tY < 1900 then
     add 1900 to tY
  end if
  put tY & comma & item 1 of pDate & comma & item 2 of pDate & ",0,0,0,0" into fDate
  put dateItemsToSeconds(fDate) into fDate
  if fDate is not a number then return fDate
  return fDate
end dateToSeconds

function secondsToDateItems pSec
  if pSec is not a number then return empty
  set itemdel to comma
  if pSec >= 0 then
     convert pSec to dateItems
  else if pSec > -631152000 then
     add 631152000 to pSec      
     convert pSec to dateItems
     subtract 20 from item 1 of pSec
  else if pSec > -1262304000 then
     add 1262304000 to pSec      
     convert pSec to dateItems
     subtract 40 from item 1 of pSec
  else if pSec > -1893456000 then
     add 1893456000 to pSec      
     convert pSec to dateItems
     subtract 60 from item 1 of pSec
  else 
     add 2524608000 to pSec      
     convert pSec to dateItems
     subtract 80 from item 1 of pSec      
  end if
  return pSec
end secondsToDateItems

function xYearsAgoInSeconds pYears
  put the short date into tCurrent
  convert tCurrent to dateitems
  set itemdel to comma
  subtract pYears from item 1 of tCurrent            
  return dateItemsToSeconds(tCurrent)
end xYearsAgoInSeconds

function xMonthsAgoInSeconds pMonths
  put the short date into tCurrent
  convert tCurrent to dateitems
  set itemdel to comma
  put trunc(pMonths/12) into tYears
  put pMonths-(tYears*12) into tMonths
  if pMonths >= item 2 of tCurrent then
     add 1 to tYears
     subtract 12 from pMonths                 
  end if
  subtract tYears from item 1 of tCurrent
  subtract pMonths from item 2 of tCurrent
  return dateItemsToSeconds(tCurrent) 
end xMonthsAgoInSeconds


function dateFromSeconds pSec
     return formatDateItemsToDate(pSec,true)
end dateFromSeconds

function formatDateItemsToDate pDate pConvertFirst
  if pConvertFirst is true then put secondsToDateItems(pDate) into pDate
  set itemdel to comma
  put item 2 of pDate & slash into tRez
  put item 3 of pDate & slash after tRez
  put item 1 of pDate after tRez
  return tRez
end formatDateItemsToDate

function ageFromSeconds pSec
  return calculateAge("seconds",pSec)
end ageFromSeconds

function calculateAge pYear pMonth pDay
  replace space with empty in pYear
  replace space with empty in pMonth
  if pYear is empty then return empty
  if pMonth is empty then return empty
  if pYear is "seconds" then
     put secondsToDateItems(pMonth) into tTime
     put item 1 of tTime into pYear
     put item 2 of tTime into pMonth
     put item 3 of tTime into PDay
  end if
  put the long date into tToday
  convert tToday to dateItems  --OK
  set itemdel to comma
  put item 1 of tToday into tYear
  put tYear-pYear into age
  if item 2 of tToday < pMonth then subtract 1 from age
  if item 2 of tToday = pMonth then
     if item 3 of tToday < pDay then subtract 1 from age
  end if
  if age < 0 then add 100 to age
  return age
end calculateAge

function timeSince pStartTime pEndTime pForm
   if pEndTime is empty then put the seconds into pEndTime
   put pEndTime-pStartTime into timeBetween
   put timeBetween/86400 into tDays
   put tDays/30 into tMonths
   put tDays/365.25 into tYears
   switch pForm
      case "years"
         return tYears
         break
      case "months"
         return tMonths
         break
      case "days"
         return tDays
         break
      default
         --if pForm is blank, we do months or years with label
         if tDays < 365 then
            return round(tMonths,1) && "Months"
         else
            return round(tYears,1) && "Years"
         end if
         break
   end switch
end timeSince

function cleanPhone pPhone
   put 0 into tCount
   repeat for each char x in pPhone
      if x is a number then
         put x after newPhone
         add 1 to tCount
      end if
      if tCount = 10 then exit repeat
   end repeat
   return newPhone
end cleanPhone

function reformatPhone pPhone
    put 0 into tCount
    repeat for each char x in pPhone
         if x is not a number then next repeat
         add 1 to tCount
         switch
              case tCount=1
                   put "(" & x into tPhoneNumber
                   break
              case tCount=4
                   put ") "  & x after tPhoneNumber
                   break
              case tCount=7
                   put "-" & x after tPhoneNumber
                   break
              default
                   put x after tPhoneNumber
                   break
         end switch
         if tCount = 10 then exit repeat
    end repeat
    return tPhoneNumber
end reformatPhone

function parseThymeStamp pStamp
   if pStamp is not a number then return empty
   convert pStamp to dateitems   --OK
   set itemdel to comma
   put item 1 of pStamp & tab into tReturn
   put "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec" into theMonths
   put item 2 of pStamp into tMo
   if tMo is not a number then return empty
   put item tMo of theMonths & tab after tReturn
   put item 3 of pStamp after tReturn
   return tReturn
end parseThymeStamp

function monthNumToName pMon
  put "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec" into tMonths
  set itemdel to comma
  if pMon is not a number then return empty
  return item pMon of tMonths
end monthNumToName

function monthNameToNum pMon
  put char 1 to 3 of pMon into pMon
  switch pMon
     case "Jan"
        return 1
        break
     case "Feb"
        return 2
        break
     case "Mar"
        return 3
        break
     case "Apr"
        return 4
        break
     case "May"
        return 5
        break
     case "Jun"
        return 6
        break
     case "Jul"
        return 7
        break
     case "Aug"
        return 8
        break
     case "Sep"
        return 9
        break
     case "Oct"
        return 10
        break
     case "Nov"
        return 11
        break
     case "Dec"
        return 12
        break
  end switch
end monthNameToNum

function newID pType
   wait 1 second
   put the seconds into temp
   subtract 1508342097 from temp
   if pType is empty then put "id_" before temp else put pType before temp
   return temp
end newID



on __AYANS__
end __AYANS__

/* 
-- libAYANS 0.3.14
And Yet Another Notation System

indentation doesn't matter, just for readability
any leading spaces are deleted, to put actual leading spaces in use "~"
the tilde will be the first space
if your first character is a tilde, you are SOL

single key value combos
=  single value on this line inline
_  single value is the next line (underscore)
|  single value spans mutliple lines including line breaks
>  single value spans multiple lines substituting space for line breaks
-  simple array of items
!  complex/nested array
end multiline/array with semicolon & key name

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
   local tEOF, x, tLine, tVar, tCombinedLines, theResult, tEnd, tKey
   --param pText - text to decode to array
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
   local tIndentKey, tIndentValue, tKeyList, tKey, tValue, tAYA, tLine
   if pDepth is empty then put 0 into pDepth
   put indSpace(pDepth) into tIndentKey
   put indSpace(pDepth+1) into tIndentValue
   put the keys of pText into tKeyList
   sort tKeyList
   repeat for each line tKey in tKeyList
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
   local tX, tIndentMe
   if pBase is empty then put 3 into pBase
   if pDepth is 0 then return empty
   put pBase * pDepth into tX
   repeat with x=1 to tX
      put space after tIndentMe
   end repeat
   return tIndentMe
end indSpace

private function parseLine pTextLine
   local tVar, pLine
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
   local tFixed
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
   local tKeys
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

function arrayFlatten pArray pPrefix pSkip pKeep
   local tResult, tKeyList, tKey, tPrefix
   
   put the keys of pArray into tKeyList
   sort tKeyList
   
   set itemdel to comma
   
   repeat with x=1 to the number of lines in tKeyList
      put line x of tKeyList into tKey
      if tKey is among the items of pSkip then
         next repeat
      end if
      if pArray[tKey] is an array then
         put arrayFlatten(pArray[tKey],pPrefix & tKey & colon,pSkip,pKeep) after tResult
      else if pArray[tKey] is not empty and pKeep is empty then
         put pPrefix & tKey & colon & qzZ(pArray[tKey]) & cr after tResult        
      end if
   end repeat
   
   return tResult
end arrayFlatten

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

command arrayToFile pArray pFileName
   if there is a file pFileName then delete file pFileName
   put base64encode(arrayEncode(pArray)) into URL ("file:" & pFileName)
end arrayToFile

command fileToArray pFileName pArray
   local myFile
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

on __Text_Cipher__
end __Text_Cipher__

function mpEncypher pText pKey1 pKey2 pWrap pBuffOuter pBuffInt pBuffIntSize
   /*
   REQUIRED:
   --pText - information to be coded
   --pKey1 - first code key
   --pKey2 - second code key
   
   OPTIONAL:
   --pWrap - number of characters with which to wrap the output
   --pBufferOutside - number of random characters to add to the beginning and the end
   --pBuffInt - interval at which random characters will be added
   --pBufferOutside - number of random characters to add at the interval configured above
   */
   
   local tResult, tBuffCount
   
   put mpCipherKey(pKey1, the number of chars in pText) into pKey1
   put mpCipherKey(pKey2, the number of chars in pText) into pKey2
   
   repeat with x=1 to the number of chars in pText
      put char offset(char x of pText,mpCipherBase()) of mpCipherCode(pKey1, pKey2, x) after tResult
   end repeat
   
   replace cr with "{42!]" in tResult
   
   put tResult into field "base"
   put mpCipherEnBuffer(tResult, max(5,pBuffOuter), max(13,pBuffInt), max(2,pBuffIntSize)) into tResult
   
   if pWrap=0 then
      return tResult
   else
      return mpCipherWrap(tResult,pWrap)
   end if
end mpEncypher

function mpDecypher pEncoded pKey1 pKey2 pBuffOuter pBuffInt pBuffIntSize
   /*
   REQUIRED:
   --pText - information to be decoded
   --pKey1 - first code key
   --pKey2 - second code key
   
   OPTIONAL:
   --pBufferOutside - number of random characters added to the beginning and the end
   --pBuffInt - interval at which random characters were added
   --pBufferOutside - number of random characters added at the interval configured above
   */
   
   local tResult, tUnBuffedEncoded, tBuffCount
   
   replace cr with "" in pEncoded
   replace "{42!]" with cr in pEncoded
   
   put mpCipherDeBuffer(pEncoded, max(5,pBuffOuter), max(13,pBuffInt), max(2,pBuffIntSize)) into pEncoded
   put pEncoded into field "code"
   put mpCipherKey(pKey1, the number of chars in pEncoded) into pKey1
   put mpCipherKey(pKey2, the number of chars in pEncoded) into pKey2
   
   repeat with x=1 to the number of chars in pEncoded
      put char offset(char x of pEncoded,mpCipherCode(pKey1, pKey2, x)) of mpCipherBase() after tResult
   end repeat
   
   return tResult
end mpDecypher

private function mpCipherKey pKey pTextCount
   local tFinalKey
   
   put pKey into tFinalKey
   
   repeat
      put the number of chars in tFinalKey into temp
      if pTextCount > the number of chars in tFinalKey then
         put pKey after tFinalKey
      else
         return tFinalKey
      end if
   end repeat
end mpCipherKey

private function mpCipherBase
   return "a1{b2}c3\d4|e5;f6:g7,h8.i9<j0>k!?l@m#n$o%p^q&r*s(t)u-v_w=x+y[z]" \
         & quote & cr & space 
end mpCipherBase

private function mpCipherDeBuffer pEncoded pOuter pInt pSize
   local tBuffCount, tUnBufferedText, tBuffSize
   
   put max(5,pOuter)+1 into tX
   
   put char max(5,pOuter)+1 to -1 of pEncoded into tUnBufferedText
   put char 1 to -(max(5,pOuter)+1) of tUnBufferedText into tUnBufferedText
   
   put 1 into tBuffCount
   put 1 into tBuffSize
   --   repeat for each char x in pEncoded
   --      if tBuffCount < max(13,pInt) then
   --         add 1 to tBuffCount
   --         put x after tUnBufferedText
   --      else if tBuffSize = max(2,pSize) then
   --         put 1 into tBuffCount
   --         put 1 into tBuffSize
   --      else
   --         add 1 to tBuffSize
   --      end if      
   --   end repeat
   
   return tUnBufferedText
end mpCipherDeBuffer
   
   
   
private function mpCipherEnBuffer pText pOuter pInt pSize
   local tBuffCount, tBufferedText
   repeat with x=1 to pOuter
      put char random(42) of mpCipherBase() after tBufferedText 
   end repeat
   
   
   put pText after tBufferedText
   
   --   repeat for each char y in pText
   --      add 1 to tBuffCount
   --      put y after tBufferedText
   --      if tBuffCount=pInt then
   --         put 0 into tBuffCount
   --         repeat pSize times
   --            put char random(42) of mpCipherBase() after tBufferedText 
   --         end repeat
   --      end if
   --   end repeat
   
   repeat with z=1 to pOuter
      put char random(42) of mpCipherBase() After tBufferedText 
   end repeat
   
   return tBufferedText
end mpCipherEnBuffer
   
   private function mpCipherCode pKey1 pKey2 pCharNumber
   local tCode
   put mpCipherBase() into tBase
   
   if offset(char pCharNumber of pKey1,tBase) > offset(char pCharNumber of pKey2,tBase) then
      put char (offset(char pCharNumber of pKey1,tBase)+1) to 66 of tBase into tCode
      put char (offset(char pCharNumber of pKey2,tBase)+1) to offset(char pCharNumber of pKey1,tBase) of tBase after tCode
      put char 1 to offset(char pCharNumber of pKey2,tBase) of tBase after tCode 
   else
      put char (offset(char pCharNumber of pKey2,tBase)+1) to 66 of tBase into tCode
      put char (offset(char pCharNumber of pKey1,tBase)+1) to offset(char pCharNumber of pKey2,tBase) of tBase after tCode
      put char 1 to offset(char pCharNumber of pKey1,tBase) of tBase after tCode 
   end if   
   
   return tCode
end mpCipherCode

private function mpCipherWrap pText pMaxLength
   local tWrappedText, tLines
   
   if pMaxLength is empty or pMaxLength is not a number then
      put 75 into pMaxLength
   end if
   
   put ceiling((the number of chars in pText)/pMaxLength) into tLines
   
   repeat with x=1 to tLines
      if tWrappedText is not empty then
         put cr after tWrappedText
      end if
      put char 1+((x-1)*pMaxLength) to pMaxLength*(x) of pText after tWrappedText      
   end repeat
   
   return tWrappedText
end mpCipherWrap

on __Password_Gen__
end __Password_Gen__

function mp.RandomPass pLength pCount pSpecial pLow pUp pNum pSpec
   local tPass, tRandy, tRandNum, tPassList, tNum, tUpper, tSpec, tForceNum, tForceSpec, tForceUpper
   local tRandChance
   --param pLength - length of password (default=8)
   --param pCount - number of passwords to return (default=1)
   --param pSpecial - use special chars (default=true)
   --param pLow/pUp/pNum/pSpec - cut off points for random
   if pLength is empty then put 8 into pLength
   if pSpecial is empty then put true into pSpecial
   if pCount is empty then put 1 into pCount
   if pLow is empty then
      put 600 into pLow
   end if
   if pUp is empty then
      put pLow + 350 into pUp
   end if
   if pNum is empty then
      put pUp +250 into pNum
   end if
   put pNum into tRandChance
   
   if pSpecial and pSpec is a number then 
      put pSpec into tRandChance
   else if pSpecial then
      add 100 to tRandChance
   end if
   
   repeat with x=1 to pCount
      put false into tNum
      put false into tUpper
      put false into tSpec
      put empty into tPass
      put random(pLength-1)+1 into tForceSpec
      repeat
         put random(pLength-1)+1 into tForceNum
         if tForceNum is not tForceSpec then exit repeat
      end repeat
      repeat
         put random(pLength-1)+1 into tForceUpper
         if tForceUpper is not tForceSpec and tForceUpper is not tForceNum then exit repeat
      end repeat
      
      if tForceSpec=tForceNum then
         if tForceSpec = pLength then
            subtract 1 from tForceNum
         else 
            add 1 to tForceNum
         end if
      end if
      repeat with z=1 to pLength
         if z=1 then
            put mp.RandomChar("lower") into tRandy
         else if z = tForceNum and tNum is false then
            put mp.RandomChar("number") into tRandy
         else if z = tForceSpec and tSpec is false then
            put mp.RandomChar("special") into tRandy
         else if z = tForceUpper and tUpper is false then
            put mp.RandomChar("upper") into tRandy
         else
            put random(tRandChance) into tRandNum
            if tRandNum <= pLow then
               put mp.RandomChar("lower") into tRandy
            else if tRandNum <= pUp then
               put mp.RandomChar("upper") into tRandy
            else if tRandNum <= pNum then
               put mp.RandomChar("number") into tRandy
            else
               put mp.RandomChar("special") into tRandy
            end if
            
         end if         
         put tRandy["char"] after tPass
         if tRandy["num"] then put true into tNum
         if tRandy["spec"] then put true into tSpec
         if tRandy["upper"] then put true into tUpper
      end repeat
      put tPass after tPassList
      if x<pCount then put cr after tPassList
   end repeat
   
   return tPassList
end mp.RandomPass

private function mp.RandomChar pType
   local tRandy
   local tSpecial = "!@#$%^&*"
   local tNumbers = "23456789"
   local tAlpha = "abcdefghjkmnpqrstuvwxyz"
   put false into tRandy["num"]
   put false into tRandy["upper"]
   put false into tRandy["spec"]
   switch pType
      case "lower"
         put char random(23) of tAlpha into tRandy["char"]
         break
      case "upper"
         put toUpper(char random(23) of tAlpha) into tRandy["char"]
         break
      case "number"
         put char random(8) of tNumbers into tRandy["char"]
         put true into tRandy["num"]
         break
      case "special"
         put char random(8) of tSpecial into tRandy["char"]
         put true into tRandy["spec"]
         break
   end switch
   return tRandy
end mp.RandomChar

function mp.PasswordMaker pName pCause pDate pLength pMaster
   local tStor, tDigest, tPass, tNx
   local tTotal = 0
   local tSpec = false
   local tNum = false
   
   if pDate is empty then
      put the short date into tStor
      convert tStor to dateitems
      set itemdel to comma
      put item 1 of tStor into pDate
      put "-" & item 2 of tStor after pDate
      put "-" & item 3 of tStor after pDate
   end if
   if pLength is empty then put 10 into pLength
   if pCause is empty then put "gmail" into pCause
   if pMaster is empty then put "$ecretM@st#rPas$" into pMaster
   put base64encode(messageDigest(textencode(pName&&pDate&&pMaster), "SHA3-512")) into tDigest
   repeat with x=1 to 80
      put char x of tDigest into tStor
      if tStor is among the chars of "iIlL1" then
         put "!" into tStor
      else if tStor is among the chars "0oO/" then
         put "*" into tStor
      end if
      put tStor after tPass
      put charToNum(char -1 of tPass) into tStor
      if tStor >=48 and tStor <=57 then put true into tNum
      if tStor=33 or tStor=42 or tStor=43 then put true into tSpec
      if (the number of chars of tPass) >= pLength then exit repeat
   end repeat
   put trunc(pLength/3) into tNx
   if tNum is false then
      put charToNum(char tNx of tPass) into tStor
      if tStor=33 or tStor=42 or tStor=43 then 
         add 1 to tNx
         put charToNum(char tNx of tPass) into tStor
      end if
      put char -1 of tStor into tStor
      if tStor = 0 then put 4 into tStor
      if tStor = 1 then put 2 into tStor
      put tStor into char tNx of tPass
   end if
   put trunc(pLength/2) into tNx
   if tSpec is false then
      put charToNum(char tNx of tPass) into tStor
      put char -1 of tStor into tStor
      add 1 to tStor
      put char tStor of "!@#$%^&*?=" into char tNx of tPass
   end if
   
   return tPass
end mp.PasswordMaker

on __Slapdash_Encryption___
end __Slapdash_Encryption___

function mp.Digest pContent pType pMyKey
   local tDigest, tOutput
   --valid pType and number of char in result:  
   ----224(56), 256(64), 384(96) 512(128)
   if pType is empty then
      put "SHA3-256" into pType
   else
      put "SHA3-" before pType
   end if
   put messageDigest(pContent, pType) into tDigest
   if pMyKey is empty then put "42madpink541" into pMyKey
   put base64Encode(tDigest) into tDigest
   put base64encode(pMyKey) after tDigest
   put messageDigest(tDigest, pType) into tDigest
   get binaryDecode("H*", tDigest, tOutput)
   return tOutput
end mp.Digest

function mp.encryptMe pData pKey pIV pText
   local tKeys, eData
   --param pData - the data to emcrypt
   --param pKey - key to decode
   --param pIV - second key used as IV
   --param pText - [false] - if true, convert to text
   put getKeys(pKey,pIV) into tKeys
   encrypt pData using "aes-256-cbc" with key tKeys["key"] and IV tKeys["IV"] at 256 bit
   if pText is true then
      put base64encode(it) into eData
   else
      put it into eData
   end if
   return eData
end mp.encryptMe

function mp.decryptMe pData pKey pIV pText
   local tKeys, tData, eData
   --param pData - the data to decrypt
   --param pKey - key to decode
   --param pIV - second key used as IV
   --param pText - [false] - if true, the source is text
   put getKeys(pKey,pIV) into tKeys
   if pText is true then
      put base64decode(pData) into tData
   else
      put pData into tData
   end if
   decrypt tData using "aes-256-cbc" with key tKeys["key"] and IV tKeys["IV"]  at 256 bit 
   put it into eData
   return eData	
end mp.decryptMe

command chooseDestFolder
   local tDest
   answer folder "Choose where to save the result"
   put it into tDest
   set the destinationFolder of this stack to tDest
end chooseDestFolder

command mp.decryptFile
   local tFilePath, tInput, tFile, tDest, tKey, tIV, tData, tResult
   answer file "Pick a file to decrypt"
   if it is "cancel" then exit to top
   put it into tFilePath
   put decompress(URL ("binfile:" & tFilePath)) into tInput
   set itemdel to "/"
   put item -1 of tFilePath into tFile
   put char 1 to -6 of tFile into tFile
   answer folder "Pick a folder to save to:"
   put it & "/" & tFile into tDest
   put field "username" into tKey
   put the field "passphrase" into tIV
   put decryptMe(tInput,tKey,tIV) into tData
   put tData into URL ("binfile:" & tDest)
   put "Decrypting Done"&cr into tResult
   put tFilePath && "has been decrypted as:" & cr after tResult
   put tDest after tResult
   put tResult into field "result"
end mp.decryptFile

command mp.encryptFile
   local tFileName, tData, tMey, tIV, tKey, tEData, tDestFile, tResult
   answer file "Pick a file to encrypt"
   if it is "cancel" then exit to top else put it into tFileName
   put URL ("binfile:" & tFileName) into tData
   put field "username" into tKey
   put the field "passphrase" into tIV
   put encryptMe(tData,tKey,tIV) into tEData
   put tFileName & ".edat" into tDestFile
   put compress(tEData) into URL ("binfile:" & tDestFile)
   put "Encrypting Done"&cr into tResult
   put tFileName && "is encrypted as:" & cr after tResult
   put tDestFile after tResult
   put tResult into field "result"
end mp.encryptFile

private function getKeys pRawKey pRawIV
   local tKeys
   put makeKey(pRawKey) into tKeys["key"]
   put makeKey(pRawIV) into tKeys["IV"]
   return tKeys
end getKeys

private function makeKey pInput
   local tPhrase, tKey
   put stripChar(pInput) into tPhrase
   put the sha1digest of tPhrase into tPhrase
   get binarydecode("H*",tPhrase,tKey)
   put char 1 to 32 of tKey into tKey
   return tKey
end makeKey

private function stripChar pInput
   local tChar, tLChar, tNum, tCode
   repeat for each char tChar in pInput
      put toLower(tChar) into tLChar
      put charToNum(tLChar) into tNum
      if (tNum >= 97) and (tNum <= 122) then
         put tLChar after tCode
      end if
   end repeat
   return tCode
end stripChar

on __MISC__
end __MISC__

function postToPastebin pAPIkey pPaste pName pFormat pPrivate pExpire pUser
   local tData
   put "api_dev_key=" & pAPIkey into tData
   put "&api_paste_code=" & urlencode(pPaste) after tData
   put "&api_option=paste" after tData
   
   if pName is not empty then put "&api_paste_name=" & pName after tData
   if pFormat is not empty then put "&api_paste_format=" & pFormat after tData
   if pPrivate is not empty then put "&api_paste_private=" & pPrivate after tData
   if pExpire is not empty then put "&api_paste_expire_date=" & pExpire after tData
   if pUser is not empty then put "&api_user_key=" & pUser after tData
   
   set the httpheaders to "Content-Type: application/x-www-form-urlencoded" 
   post tData to "https://pastebin.com/api/api_post.php"
   return the urlresponse
end postToPastebin

on __QUAZQUA_JSON__
end __QUAZQUA_JSON__

function mp.j2a pText
   --assumes it is not an array
   put char 2 to -2 of pText into pText
   local jsonMode
   local myArray
   local myKey
   local myValue
   local tX
   local tCurr
   local mySubArray = 0
   
   repeat for each char tCurr in pText
      switch 
         case tCurr="["and jsonMode="jsonarray"
            put tCurr after myValue
            put "jsonarray" into jsonMode
            put 1 into mySubArray
            breakpoint
         case tCurr="["and jsonMode="jsonarray"
            put tCurr after myValue
            put "jsonarray" into jsonMode
            add 1 to mySubArray
            breakpoint 
         case jsonMode="jsonArray"
            put tCurr after myValue
            breakpoint
         case tCurr="{" and jsonMode=between
            put tCurr after myValue
            put "subarray" into jsonMode
            put 1 into mySubArray
            break
         case tCurr="{" and jsonMode="subarray"
            put tCurr after myValue
            add 1 to mySubArray
            break
         case tCurr="}" and jsonMode="subarray" and mySubArray>1
            put tCurr after myValue
            subtract 1 from mySubArray
            break            
         case tCurr="}" and jsonMode="subarray" and mySubArray=1
            put tCurr after myValue
            subtract 1 from mySubArray
            put mp.j2a(myValue) into myArray[myKey]
            break
         case jsonMode="subarray"
            put tCurr after myValue
            break
         case tCurr=quote and jsonMode=empty
            put "key" into jsonMode
            break
         case tCurr=quote and jsonMode="key"
            put "between" into jsonMode
            break
         case tCurr=quote and jsonMode="between"
            put "value-string" into jsonMode
            break
         case tCurr is a number and jsonMode="between"
            put tCurr into myValue
            put "value-literal" into jsonMode
            break
         case tCurr=comma and jsonMode="value-literal"
         case tCurr=space and jsonMode="value-literal"
         case tCurr=quote and jsonMode="value-string"
            put myValue into myArray[myKey]
            put empty into jsonMode
            put empty into myValue
            put empty into myKey
            break
         case jsonMode="key"
            put tCurr after myKey
            break
         case jsonMode="value-string"
         case jsonMode="value-literal"
            put tCurr after myValue
            break
            
      end switch
      
   end repeat
   return myArray
end mp.j2a

function mp.a2j pArray pPrettify
   local objectCount = 0
   local tBuffer
   if pPrettify then 
      put space into tBuffer
   else if pPrettify is empty or pPrettify is false then
      put empty into tBuffer
   else 
      put pPrettify into tBuffer
   end if
   put the keys of pArray into keyList
   sort keyList
   
   --put mp.numericArray(keyList) into isJsonArray
   
   --THIS IS FOR REGULAR OBJECTS
   put "{" & tBuffer  into finalJSON
   
   repeat for each line tKey in keyList
      if objectCount > 0 then put comma & tBuffer after finalJSON      
      put mp.jsonkey(tKey,tBuffer) after finalJSON
      
      if pArray[tKey] is an array then
         put mp.a2j(pArray[tKey],tBuffer) after finalJSON
      else
         put mp.jsonobject(pArray[tKey],tBuffer) after finalJSON
      end if
      add 1 to objectCount
   end repeat
   
   put tBuffer & "}" after finalJSON
   return finalJSON
end mp.a2j

private function mp.jsonkey pKey pBuffer
   return quote & pKey & quote & pBuffer & colon & pBuffer
end mp.jsonkey

private function mp.jsonobject pVal 
   if pVal is a number or pVal is "null" or pVal is true or pVal is false then
      return pVal
   else if pVal is empty then
      return "null"
   end if
   replace cr with "qzqcr" in pVal
   replace tab with "qzqtab" in pVal
   replace quote with "qzqqt" in pVal
   replace "\" with "qzqbs" in pVal
   replace "/" with "qzqsl" in pVal
   return quote & pVal & quote
end mp.jsonobject

private function mp.numericArray pKeys
   if pKeys is an array then
      put the keys of pKeys into pKeys
   end if
   repeat for each line tKey in pKeys
      if tKey is not a number then return false
   end repeat
   return true
 end mp.numericArray
 
on ___SVG_STUFF___
end ___SVG_STUFF___

function pathFromFile pFileName
  if char -3 to -1 of pFileName is not "SVG" then 
    answer "Not an SVG file"
    exit to top
  end if 
  open file pFileName for read
  read from file pFileName until EOF
  put it into tSVG
  replace tab with space in tSVG
  replace cr with space in tSVG
  replace ">" with cr in tSVG
  replace " d=" & quote with cr & "QZQZ" in tSVG
  replace quote with cr in tSVG --remove trailing formats and fills -jh
  replace "/" with empty in tSVG
  /* SVG acceptable:
  0-1 numbers
  space
  carriage return
  COMMANDS:
  M = moveto
  L = lineto
  H = horizontal lineto
  V = vertical lineto
  C = curveto
  S = smooth curveto
  Q = quadratic Bézier curve
  T = smooth quadratic Bézier curveto
  A = elliptical Arc
  Z = closepath
  */
  repeat for each line tLine in tSVG
    if char 1 to 4 of tLine is not "QZQZ" then next repeat
    put char 5 to -1 of tLine into tLine
    put tLine & cr after tNewPath
  end repeat
  
  repeat until tStop is true
    put char -1 of tNewPath into tChar
    switch tChar
      case space
      case cr
        delete char -1 of tNewPath
        break
      default 
        put true into tStop
        break
    end switch
  end repeat
  
  return tNewPath
end pathFromFile

function svgFromRaw pPath
   replace tab with space in pPath
   replace cr with space in pPath
   replace ">" with cr in pPath
   replace " d=" & quote with cr & "QZQZ" in pPath
   replace quote with cr in pPath --remove trailing formats and fills -jh
   replace "/" with empty in pPath
   
   repeat for each line tLine in pPath
      if char 1 to 4 of tLine is not "QZQZ" then next repeat
      put char 5 to -1 of tLine into tLine
      put tLine & cr after tNewPath
   end repeat
   
   repeat until tStop is true
      put char -1 of tNewPath into tChar
      switch tChar
         case space
         case cr
            delete char -1 of tNewPath
            break
         default 
            put true into tStop
            break
      end switch
   end repeat
   return tNewPath
end svgFromRaw

command makeFullScript
   put field "lcbScript" into tScript
   put field "iconPrefix" into tPrefix
   put field "varName" into tVar
   
   if tScript is empty then
      put "private variable VARNAME as Arrayqzqz qzqzprivate handler initVARNAME()qzqz   put {} into VARNAME" into tScript
      replace "VARNAME" with tVar in tScript
      replace "qzqq" with quote in tScript
      replace "qzqz" with cr in tScript
   else
      delete line -1 of tScripte
   end if
   put cr after tScript
   put the selectedText of field "iconList" after tList
   repeat for each line tLine in tList
      put makeLCBscript(tLine, tPrefix, tVar) after tScript
   end repeat
   put "end handler" after tScript
   put tScript into field "lcbScript"
   set the clipboardData to tScript
end makeFullScript

function makeLCBscript pName pPrefix pVar
  if pPrefix is empty then put "icon_" into pPrefix
  if pVar is empty then put "mIcons" into pVar
  put the pName of stack "svgSettings" into tInfo
  put tChoice into tName
  put tInfo["path"] into tPath
  replace cr with space in tPath
  put pPrefix before pName
  
  put "   put the empty array into VARNAME[qzqqSVGNAMEqzqq]qzqz   put qzqqSVGPATHqzqq into VARNAME[qzqqSVGNAMEqzqq][qzqqsvgqzqq]qzqz" into tItem
  replace "SVGNAME" with pName in tItem
  replace "SVGPATH" with tPath in tItem
  replace "VARNAME" with pVar in tItem
  replace "qzqq" with quote in tItem
  replace "qzqz" with cr in tItem
  return tItem
end makeLCBscript

on ___MEGA_ICONS___
end ___MEGA_ICONS___

function mpIcons
  local tList
  put mpIconList() into tList
  repeat for each key x in tList
    repeat for each key z in tList[x]
      put tList[x][z] into tQ
      set itemdel to comma
      repeat for each item q in tQ
        put 1 into tList[x][z][q]
      end repeat
    end repeat
  end repeat
  return tList
end mpIcons

function mpGetPath pFam pCat pName
   local tCommand
   local tIcons
   put pFam & "_" & pCat into tCommand
   put tCommand() into tIcons
   return tIcons[pName]
end mpGetPath

on ___BORROWED___
end ___BORROWED___

function fetchMTFSizeParameters pTextSize
   -- for a given textSize this returns textHeight and textShift
   switch pTextSize
      case 11
         return 18,-3
         break
      case 12
         return 21,-4
         break
      case 14
         return 24,-4
         break
      case 16
         return 26,-5
         break
   end switch
end fetchMTFSizeParameters

function isEmail pWhat
   local tNotIP, tIsIP
   put matchText(pWhat,"^[A-z0-9_\-\.]+[@][A-z0-9_\-]+([.][A-z0-9_\-]+)+[A-z]$") into tNotIP
   put matchText(pWhat,"^(1*\d{1,2}|2[0-4]\d|25[0-5])\.(1*\d{1,2}|2[0-4]\d|25[0-5])\.(1*\d{1,2}|2[0-4]\d|25[0-5])\.(1*\d{1,2}|2[0-4]\d|25[0-5])(:\d{1,5})*$") into tIsIP
   return (tIsIP or tNotIP)
end isEmail

--setProp clearCursor
--   put false into sDragging
--   set the defaultCursor to 0
--end clearCursor
