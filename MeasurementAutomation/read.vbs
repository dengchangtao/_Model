'variables to set
Dim sPath, sXlName, sFType, sReadAll, senzorID, startRow, sProfile
'working directory (maybe present dir)
sPath = "C:\_Temp\_MK\"
'name of eXcel to copy data
sXlName = "M1_Pressures.xlsm"
'file types to import to eXcel
sFType = "s30"
'number of loops
startRow = 2
'end of variable define

Dim xlApp, xlBook, xlSht, xlTbl, oxlTbl
Dim fso, folder, files, oReadFile

'MsgBox "Ensure "& sXlName & " - sheet Table is prepared with proper senzorID"

Set fso = CreateObject("Scripting.FileSystemObject")
Set folder = fso.GetFolder(sPath)
Set files = folder.Files

Set xlApp = CreateObject("Excel.Application")
Set xlBook = xlApp.WorkBooks.Open(sPath & sXlName)
'Set xlSht = xlApp.activesheet
Set xlTbl = xlBook.Sheets("Table")

'MsgBox xlTbl.Cells(startRow, 6).Value

For each oFile in files
	'SEWAD S30 & SEWAD S20
	If LCase(fso.GetExtensionName(oFile.name)) = "s30" Or LCase(fso.GetExtensionName(oFile.name)) = "s20" Then
		'MsgBox oFile.name
		If xlTbl.Cells(startRow, 6).Value & "." & fso.GetExtensionName(oFile.name) = oFile.name Then
			Set oReadFile = fso.OpenTextFile(oFile, 1, False)
			senzorID = xlTbl.Cells(startRow, 6).Value
			sProfile = xlTbl.Cells(startRow, 2).Value
			MsgBox oFile.name & "/" & senzorID & " (" & sProfile & ") + pasting original data into input sheet"
			Set oxlTbl = xlBook.Sheets("Import")
			xlApp.Application.Run sXlName & "!" & Pasteorigdata
			Set oxlTbl = xlBook.Sheets(sProfile)
			xlApp.Application.Run sXlName & "!" & PastSpecial
			sReadAll = oReadFile.ReadAll
			
			startRow = startRow + 1
			oReadFile.Close
		End If
	End If
Next

'xlApp.ActiveWorkbook.Save
xlApp.Workbooks.Close
xlApp.Quit

Set fso = Nothing

'always deallocate after use...
 Set xlSht = Nothing
 Set xlBook = Nothing
 Set xlApp = Nothing 
