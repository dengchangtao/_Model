'--------------------------
'Developped by Jakub Vajda
' end of - 04 - 2016 - - -
'Use for Model Registration
'--------------------------

Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8
Const adOpenDynamic = 2

Dim oFSO
Dim currFolder
REM Dim DBPath
REM Dim AccessApp
Dim FullPath, ModelPath, Model, ScriptName

Dim connStr, objConn

Dim wrkSpc 'As Workspace
Dim dbs 'As DAO.Database
Dim fld 'As DAO.Field
Dim rs, rsX 'As DAO.Recordset
Dim fs, LogFile, SubLogFile, SelFile 'As Object
Dim logStr, LogPath, SubLogPath, msg, SelPath, pathArray
Dim dbsPath, sMode, sModelName, sArgument, sArea, sBuffArea, sBuffSize, sDescription, sDate, sSelection, sScriptName 'As String
Dim dDate, oDate 'As Date
Dim SQL
Dim lev
Dim proceededModel
Dim Selection, RunTime, ModelName, Mode, MDate, Argument, Area, BufferArea, BufferSize, Description, RunScript
Dim SelectionIdx, ModeIdx, ModelNameIdx, ArgumentIdx, AreaIdx, BufferAreaIdx, BufferSizeIdx, DescriptionIdx

Selection = "Selection"
RunTime = "RunTime"
ModelName = "Model"
Mode = "Mode"
MDate = "MDate"
Argument = "Argument"
Area = "Area"
BufferArea = "BufferArea"
BufferSize = "BufferSize"
Description = "Description"
RunScript = "RunScript"

'Construct path to model + model name
FullPath = WScript.Arguments.Item(0)
pathArray = Split(FullPath, "\")
For i = LBound(pathArray) To (UBound(pathArray) - 1)
	If i = 0 Then
		ModelPath = pathArray(i)
	Else
		ModelPath = ModelPath & "\" & pathArray(i)
	End If
Next
Model = pathArray(UBound(pathArray))
'Model = "wd_test_20160421.mdb"
ScriptName = WScript.Arguments.Item(1)

'Set current working directory
Set oFSO = CreateObject("Scripting.FileSystemObject")
currFolder = oFSO.GetParentFolderName(Wscript.ScriptFullName)

'connection string to access database (model)
ConnStr = "Provider=Microsoft.ACE.OLEDB.12.0; Data Source=" & FullPath

LogPath = currFolder & "\Logfile.log"
SubLogPath = currFolder & "\Outputs\Logfile.log"
SelPath = currFolder & "\Outputs\Selection.txt"
UpdateSelPath = ModelPath & "\Selection.txt"

proceededModel = False

'Check ModelRegister Table ------------------
	
If TableExists("ModelRegister", ConnStr) And Left(ScriptName, 1) <> "U" Then
	'Model is registered - check correct columns
	SQL = "CREATE TABLE ModelRegister( " & RunTime & " TIMESTAMP, " & Selection & " INTEGER, " & Mode & " TEXT(50), " & ModelName & " TEXT(255), " & MDate & " TIMESTAMP, " & Argument & " INTEGER, " & Area & " LONGTEXT, " & BufferArea & " LONGTEXT, " & BufferSize & " INTEGER, " & Description & " LONGTEXT, " & RunScript & " TEXT(50))"
	Set objConn = CreateObject("ADODB.Connection")
	Set rs = CreateObject("ADODB.Recordset")
	objConn.Open(ConnStr)
	objConn.Execute "DROP TABLE ModelRegister"
	msg = "Table 'ModelRegister' dropped and created new... " & SQL
	objConn.Execute SQL
	Call WriteLog(msg, "d")
	objConn.Close
	Set rs = Nothing
	Set objConn = Nothing
ElseIf Left(ScriptName, 1) <> "U" Then
	'create table in database
	SQL = "CREATE TABLE ModelRegister( " & RunTime & " TIMESTAMP, " & Selection & " INTEGER, " & Mode & " TEXT(50), " & ModelName & " TEXT(255), " & MDate & " TIMESTAMP, " & Argument & " INTEGER, " & Area & " LONGTEXT, " & BufferArea & " LONGTEXT, " & BufferSize & " INTEGER, " & Description & " LONGTEXT, " & RunScript & " TEXT(50))"
	Set objConn = CreateObject("ADODB.Connection")
	Set rs = CreateObject("ADODB.Recordset")
	objConn.Open(ConnStr)
	msg = "Table 'ModelRegister' re-created... " & SQL
	objConn.Execute SQL
	Call WriteLog(msg, "d")
	objConn.Close
	Set rs = Nothing
	Set objConn = Nothing
End If

If InStr(Model, "_") > 0 And UBound(Split(Model, "_")) > 1 And Left(ScriptName, 1) <> "U" Then
	sDate = Split(Split(Model, "_")(2),".")(0)
	If IsNumeric(sDate) And Len(sDate) > 5 Then
		'Check ModelRegister Table content --------------------
		Set objConn = CreateObject("ADODB.Connection")
		Set rs = CreateObject("ADODB.Recordset")
		objConn.Open(ConnStr)
		rs.CursorType = adOpenDynamic
		rs.Open "ModelRegister", objConn
		Set xl = CreateObject("Excel.Application")
		Set xlBook = xl.Workbooks.Open(currFolder & "\Register.xls")
		Set xlSheet = xlBook.Worksheets("Register")
		xl.Visible = True
		'Process ModerRegister name and variables
		sModelName = Split(Model, "_")(1)
		sMode = Split(Model, "_")(0)
		dDate = DateSerial(Left(sDate, 4), Mid(sDate, 5, 2), Mid(sDate, 7, 2))
		sArea = ""
		sBuffArea = ""
		For i = 1 To xlSheet.UsedRange.Columns.Count
			If xlSheet.Cells(1, i) = Selection Then
				SelectionIdx = i
			ElseIf xlSheet.Cells(1, i) = ModelName Then
				ModelNameIdx = i
			ElseIf xlSheet.Cells(1, i) = Mode Then
				ModeIdx = i
			ElseIf xlSheet.Cells(1, i) = Argument Then
				ArgumentIdx = i
			ElseIf xlSheet.Cells(1, i) = Area Then
				AreaIdx = i
			ElseIf xlSheet.Cells(1, i) = BufferArea Then
				BufferAreaIdx = i
			ElseIf xlSheet.Cells(1, i) = BufferSize Then
				BufferSizeIdx = i	
			ElseIf xlSheet.Cells(1, i) = Description Then
				DescriptionIdx = i
			End If
		Next
		For i = 2 To xlSheet.UsedRange.Rows.Count
			'MsgBox LCase(xlSheet.Cells(i, ModelNameIdx)) & ", " & LCase(sModelName)
			If LCase(xlSheet.Cells(i, ModeIdx)) = LCase(sMode) And LCase(xlSheet.Cells(i, ModelNameIdx)) = LCase(sModelName) Then
				'MsgBox "Connected Row"
				For Each oArea In Split(xlSheet.Cells(i, AreaIdx), ";")
					If LCase(xlSheet.Cells(i, ModeIdx)) = "cs" Then
						sArea = sArea & Chr(34) & "C_POVODI_KANAL" & Chr(34) & " = " & oArea & " OR "
					ElseIf LCase(xlSheet.Cells(i, ModeIdx)) = "wd" Then
						sArea = sArea & Chr(34) & "C_PASMO" & Chr(34) & " = " & oArea & " OR "
					End If
				Next
				For Each oBuffArea In Split(xlSheet.Cells(i, BufferAreaIdx), ";")
					If LCase(xlSheet.Cells(i, ModeIdx)) = "cs" Then
						sBuffArea = sBuffArea & Chr(34) & "C_POVODI_KANAL" & Chr(34) & " = " & oBuffArea & " OR "
					ElseIf LCase(xlSheet.Cells(i, ModeIdx)) = "wd" Then
						sBuffArea = sBuffArea & Chr(34) & "C_PASMO" & Chr(34) & " = " & oBuffArea & " OR "
					End If
				Next
				sArea = Left(sArea, Len(sArea) - 4)
				sBuffArea = Left(sBuffArea, Len(sBuffArea) - 4)
				sBuffSize = xlSheet.Cells(i, BufferSizeIdx)
				sArgument = xlSheet.Cells(i, ArgumentIdx)
				sDescription = xlSheet.Cells(i, DescriptionIdx)
				sSelection = xlSheet.Cells(i, SelectionIdx)
				' Checking content
				If rs.EOF Then
					' zero number of records - fill in right values
					REM msg = "Filling in right values to table 'ModelRegister'"
					REM Call WriteLog(msg, "d")
					REM MsgBox dDate
					SQL = "INSERT INTO ModelRegister (" & RunTime & "," & Selection & "," & Mode & "," & ModelName & "," & MDate & "," & Argument & "," & Area & "," & BufferArea & "," & BufferSize & "," & Description & ", " & RunScript & ") VALUES (Now()," & sSelection & "," & Chr(34) & sMode & Chr(34) & "," & Chr(34) & sModelName & Chr(34) & "," & Chr(34) & dDate & Chr(34) & "," & sArgument & "," & Chr(39) & sArea & Chr(39) & "," & Chr(39) & sBuffArea & Chr(39) & "," & sBuffSize & "," & Chr(34) & sDescription & Chr(34) & ", " & Chr(34) & ScriptName & Chr(34) & ")"
					objConn.Execute SQL
					msg = "Model (" & Model & ") succesfully registered ..." & SQL
					Call WriteLog(msg, "o")
					proceededModel = True
				Else
					'rs.MoveFirst
					rs.MoveLast
					If rs.RecordCount < 2 Then
						If rs.Fields(ModelName).Value <> sModelName Then
							MsgBox("diff in Model name (rs:" & rs.Fields(ModelName).Value & "/xls:" & sModelName & ")")
						End If
						If rs.Fields(Mode).Value <> sMode Then
							MsgBox("diff in Mode (rs:" & rs.Fields(Mode).Value & "/xls:" & sMode & ")")
						End If
						If rs.Fields(MDate).Value <> dDate Then
							MsgBox("diff in Model date (rs:" & rs.Fields(MDate).Value & "/xls:" & dDate & ")")
						End If
						SQL = "UPDATE ModelRegister (" & RunTime & "," & Selection & "," & Mode & "," & ModelName & "," & MDate & "," & Argument & "," & Area & "," & BufferArea & "," & BufferSize & "," & Description & ") VALUES (Now()," & sSelection & "," & Chr(34) & sMode & Chr(34) & "," & Chr(34) & sModelName & Chr(34) & "," & dDate & "," & sArgument & "," & Chr(39) & sArea & Chr(39) & "," & Chr(39) & sBufferArea & Chr(39) & "," & sBufferSize & "," & Chr(34) & sDescription & Chr(34) & ")"
						REM rs.Edit
						REM rs.Fields(RunTime).Value = Now()
						REM rs.Fields(Area).Value = sArea
						REM rs.Fields(BufferArea).Value = sBuffArea
						REM rs.Update
						msg = "Model (" & Model & ") succesfully registered ..."
						Call WriteLog(msg, "o")
					Else
						' more than one record - please check ModelRegister table
						msg = "More than one record - please check ModelRegister table in model (" & Model & ")"
						Call WriteLog(msg, "w")
					End If
				End If
			Else
				'MsgBox "Not connected Row"
			End If
		Next
		xlBook.Close
		rs.Close
		objConn.Close
		Set rs = Nothing
		Set objConn = Nothing
		If Not proceededModel Then
			msg = "Model (" & Model & ") was not proceeded, name not found or mode do not match ..."
			Call WriteLog(msg, "w")
		End If
	Else
		msg = "Model (" & Model & ") creation date (last part of model name) is not a date, not a valid model name ..."
		Call WriteLog(msg, "w")
	End If
ElseIf Left(ScriptName, 1) = "U" Then
	'Check ModelRegister Table content --------------------
	Set objConn = CreateObject("ADODB.Connection")
	Set rs = CreateObject("ADODB.Recordset")
	objConn.Open(ConnStr)
	rs.CursorType = adOpenDynamic
	rs.Open "ModelRegister", objConn
	
	sMode = rs.Fields(Mode).Value
	sModelName = rs.Fields(ModelName).Value
	sArgument = rs.Fields(Argument).Value
	sSelection = rs.Fields(Selection).Value
	sScriptName = rs.Fields(RunScript).Value
	sModelDate = rs.Fields(MDate).Value
	
	Set xl = CreateObject("Excel.Application")
	Set xlBook = xl.Workbooks.Open(currFolder & "\Register.xls")
	Set xlSheet = xlBook.Worksheets("Register")
	xl.Visible = True
	
	For i = 1 To xlSheet.UsedRange.Columns.Count
		If xlSheet.Cells(1, i) = Selection Then
			SelectionIdx = i
		ElseIf xlSheet.Cells(1, i) = ModelName Then
			ModelNameIdx = i
		ElseIf xlSheet.Cells(1, i) = Mode Then
			ModeIdx = i
		ElseIf xlSheet.Cells(1, i) = Argument Then
			ArgumentIdx = i
		ElseIf xlSheet.Cells(1, i) = Area Then
			AreaIdx = i
		ElseIf xlSheet.Cells(1, i) = BufferArea Then
			BufferAreaIdx = i
		ElseIf xlSheet.Cells(1, i) = BufferSize Then
			BufferSizeIdx = i
		ElseIf xlSheet.Cells(1, i) = Description Then
			DescriptionIdx = i
		End If
	Next
	For i = 2 To xlSheet.UsedRange.Rows.Count
		If LCase(xlSheet.Cells(i, ModeIdx)) = LCase(sMode) And LCase(xlSheet.Cells(i, ModelNameIdx)) = LCase(sModelName) Then
			sArgument = xlSheet.Cells(i, ArgumentIdx)
			sSelection = xlSheet.Cells(i, SelectionIdx)
			sBufferSize = xlSheet.Cells(i, BufferSizeIdx)
		End If
	Next
	
	xlBook.Close
	Model = sModelName & "_" & Year(sModelDate) & Right("0" & Month(sModelDate),2) & Right("0" & Day(sModelDate),2)
	'MsgBox Model
	
	If sScriptName <> ScriptName Then
		SQL = "UPDATE ModelRegister SET ModelRegister.Selection = " & sSelection & ", ModelRegister.Argument = " & sArgument & ", ModelRegister.BufferSize = " & sBufferSize & ", ModelRegister.RunScript = " & Chr(34) & ScriptName & Chr(34) & ";"
		objConn.Execute SQL
		msg = "ModelRegister table was updated " & SQL
	Else
		msg = "By information from model register model was already updated (RunScript field in ModelRegister table)" 
		'MsgBox ">" & sScriptName & "-" & ScriptName & "<"
		Call WriteLog(msg, "w")
	End If
	
	rs.Close
	objConn.Close
	Set rs = Nothing
	Set objConn = Nothing
Else
	msg = "Bad model name supplied, not matching structure MODE_MODELNAME_DATE.mdb (" & Model & ")"
	Call WriteLog(msg, "w")
End If

'MsgBox sSelection & Left(ScriptName, 1)

'Creating selection for batch file - if selected: yes
If sSelection = 1 and Left(ScriptName, 1) = "C" Then
	REM Wscript.Quit sSelection
	REM SetEnvironmentVariable "Selected", sSelection
	Set SelFile = oFSO.OpenTextFile(SelPath, ForWriting, True)
	SelFile.Write(sSelection)
	SelFile.Close
	msg = "Selected for Comparision model: " & sModelName
	Call WriteLog(msg, "r")
ElseIf sSelection = 1 and Left(ScriptName, 1) = "R" Then
	msg = "Selected for Registration model: " & sModelName
	Call WriteLog(msg, "r")
ElseIf sSelection = 1 and Left(ScriptName, 1) = "U" Then
	Set SelFile = oFSO.OpenTextFile(UpdateSelPath, ForWriting, True)
	SelFile.Write(sSelection)
	SelFile.Close
	msg = "Selected for Update model: " & sModelName
	Call WriteLog(msg, "r")
Else
	'MsgBox sSelection & ScriptName
End If

Function WriteLog(msg, lev)
	If  lev = "o" Then
		logStr = timeStamp() & " ; " & Split(Model, ".")(0) & " ; VBS ; " & Split(WScript.ScriptName, ".")(0) & " ; OK ; 2 ; " & msg & vbNewLine
	ElseIf lev = "i" Then
		logStr = timeStamp() & " ; " & Split(Model, ".")(0) & " ; VBS ; " & Split(WScript.ScriptName, ".")(0) & " ; INFO ; 2 ; " & msg & vbNewLine
	ElseIf lev = "r" Then
		logStr = timeStamp() & " ; " & Split(Model, ".")(0) & " ; VBS ; " & Split(WScript.ScriptName, ".")(0) & " ; REGISTER ; 2 ; " & msg & vbNewLine
	ElseIf lev = "w" Then 
		logStr = timeStamp() & " ; " & Split(Model, ".")(0) & " ; VBS ; " & Split(WScript.ScriptName, ".")(0) & " ; WARNING ; 2 ; " & msg & vbNewLine
	Else 
		logStr = timeStamp() & " ; " & Split(Model, ".")(0) & " ; VBS ; " & Split(WScript.ScriptName, ".")(0) & " ; DEBUG ; 2 ; " & msg & vbNewLine
	End If
	If oFSO.FileExists(LogPath) And oFSO.FileExists(SubLogPath) Then
		REM oDate = Right(String(2, "0") & Day(Now), 2) & "." & Right(String(2, "0") & Month(Now), 2) & "." & Year(Now) & " " & DatePart("h",Time()) & ":" & DatePart("m",Time()) & ":" & DatePart("s",Time())
		Set LogFile = oFSO.OpenTextFile(LogPath, ForAppending, True)
		Set SubLogFile = oFSO.OpenTextFile(SubLogPath, ForAppending, True)
		LogFile.Write(logStr)
		SubLogFile.Write(logStr)
		LogFile.Close
		SubLogFile.Close
	ElseIf oFSO.FileExists(LogPath) Then
		Set LogFile = oFSO.OpenTextFile(LogPath, ForAppending, True)
		LogFile.Write(logStr)
		LogFile.Close
	ElseIf oFSO.FileExists(SubLogPath) Then
		Set SubLogFile = oFSO.OpenTextFile(SubLogPath, ForAppending, True)
		SubLogFile.Write(logStr)
		SubLogFile.Close
	Else
		MsgBox ("Did not find log file : cirtical error..")
	End If
End Function

Function timeStamp()
    Dim t 
    t = Now
    timeStamp = Right("0" & Day(t),2)  & "." & _
	Right("0" & Month(t),2)  & "." & _
	Year(t) & " " & _
	Right("0" & Hour(t),2) & ":" & _
	Right("0" & Minute(t),2) & ":" & _
    Right("0" & Second(t),2)
End Function

Function TableExists(TabletoFind, ConnStr)
    TableExists = False
    Set adoxConn = CreateObject("ADOX.Catalog")
    Set objConn = CreateObject("ADODB.Connection")
	
    objConn.Open(ConnStr)
    adoxConn.ActiveConnection = objConn
    IsThere = False
    For Each Table in adoxConn.Tables
        If LCase(Table.Name) = LCase(TabletoFind) Then
            IsThere = True
            Exit For
        End If
    Next
    objConn.Close
    Set objConn = Nothing
    Set adoxConn = Nothing
    If IsThere Then TableExists = True
End Function