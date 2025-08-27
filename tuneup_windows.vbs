' =====================================================
'  Tune-Up com Menu (Aplicar / Reverter / Reparos / Avancado)
'  Autor: Enoque Sousa - 2025-08-27
'  Requer: Admin. Log: C:\TuneUp_Log.txt  Backup: C:\TuneUp_Backup.ini
' =====================================================

Option Explicit
Dim sh, fso, logPath, bakPath, logFile
Set sh  = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

logPath = "C:\TuneUp_Log.txt"
bakPath = "C:\TuneUp_Backup.ini"

' ---------- Auto-elevacao ----------
If Not IsAdmin() Then
  CreateObject("Shell.Application").ShellExecute WScript.FullName, """" & WScript.ScriptFullName & """", "", "runas", 1
  WScript.Quit
End If

' ---------- Abrir log ----------
On Error Resume Next
Set logFile = fso.OpenTextFile(logPath, 8, True, 0)
On Error GoTo 0
If logFile Is Nothing Then
  MsgBox "Nao foi possivel abrir/criar o log em " & logPath, vbExclamation, "Tune-Up"
  WScript.Quit 1
End If

Call LogLine(String(60, "="))
Call LogLine("INICIO: " & Now)

' ---------- Loop do menu principal ----------
Dim choice
Do
  choice = InputBox(MenuText(), "Tune-Up | Principal", "")
  If choice = "" Then Exit Do

  If Not IsNumeric(choice) Then
    MsgBox "Escolha invalida.", vbExclamation
  Else
    Select Case CInt(choice)
      ' --- Info ---
      Case 1: ShowInfo

      ' --- Aplicar otimizacoes ---
      Case 2: EnsureSnapshot: CleanTemp sh.ExpandEnvironmentStrings("%TEMP%"): CleanTemp "C:\Windows\Temp": MsgBox "Temporarios limpos."
      Case 3: EnsureSnapshot: DisableAppraiser: MsgBox "Compatibility Appraiser desabilitado."
      Case 4: EnsureSnapshot: StopDisableService "wuauserv": MsgBox "Windows Update desabilitado."
      Case 5: EnsureSnapshot: StopDisableService "WSearch": MsgBox "Windows Search desabilitado."
      Case 6: EnsureSnapshot: StopDisableService "SysMain": MsgBox "SysMain/Superfetch desabilitado."
      Case 7: EnsureSnapshot: SetHighPerformancePlan: MsgBox "Plano de Energia: Alto Desempenho/Ultimate aplicado."
      Case 8: EnsureSnapshot: OptimizeVisualEffects: MsgBox "Efeitos Visuais ajustados para melhor desempenho."
      Case 9: EnsureSnapshot: PrepareCleanMgrSageRun: RunHidden "cleanmgr.exe /sagerun:1", True: MsgBox "Limpeza profunda executada."
      Case 10: EnsureSnapshot: RunHidden "defrag C: /O", True: MsgBox "Otimizacao/Desfragmentacao executada."
      Case 98:
        EnsureSnapshot
        CleanTemp sh.ExpandEnvironmentStrings("%TEMP%"): CleanTemp "C:\Windows\Temp"
        DisableAppraiser
        StopDisableService "wuauserv"
        StopDisableService "WSearch"
        StopDisableService "SysMain"
        SetHighPerformancePlan
        OptimizeVisualEffects
        PrepareCleanMgrSageRun: RunHidden "cleanmgr.exe /sagerun:1", True
        RunHidden "defrag C: /O", True
        MsgBox "Todos os ajustes aplicados."

      ' --- Reverter otimizacoes ---
      Case 203: ReEnableAppraiser: MsgBox "Compatibility Appraiser reativado."
      Case 204: RevertService "wuauserv": MsgBox "Windows Update revertido ao estado anterior."
      Case 205: RevertService "WSearch": MsgBox "Windows Search revertido ao estado anterior."
      Case 206: RevertService "SysMain": MsgBox "SysMain revertido ao estado anterior."
      Case 207: RestorePowerPlan: MsgBox "Plano de energia anterior restaurado."
      Case 208: RestoreVisualEffects: MsgBox "Efeitos Visuais anteriores restaurados."
      Case 99:  RestoreAll

      ' --- Submenus ---
      Case 300: ShowRepairMenu
      Case 400: ShowAdvancedMenu

      Case 0: Exit Do
      Case Else: MsgBox "Opcao nao reconhecida.", vbExclamation
    End Select
  End If
Loop

Call LogLine("FIM: " & Now)
logFile.Close

' ================= MENU PRINCIPAL =================
Function MenuText()
  MenuText = _
  "Selecione uma opcao:" & vbCrLf & vbCrLf & _
  " INFORMACOES" & vbCrLf & _
  "  1) Mostrar informacoes do sistema" & vbCrLf & vbCrLf & _
  " APLICAR (nao reversiveis: 2, 9, 10)" & vbCrLf & _
  "  2) Limpar temporarios" & vbCrLf & _
  "  3) Desabilitar Compatibility Appraiser" & vbCrLf & _
  "  4) Desabilitar Windows Update (wuauserv)" & vbCrLf & _
  "  5) Desabilitar Windows Search (WSearch)" & vbCrLf & _
  "  6) Desabilitar SysMain/Superfetch" & vbCrLf & _
  "  7) Ativar plano Alto Desempenho" & vbCrLf & _
  "  8) Otimizar Efeitos Visuais (melhor desempenho)" & vbCrLf & _
  "  9) Limpeza profunda de disco (Cleanmgr)" & vbCrLf & _
  " 10) Otimizar/Desfragmentar C:" & vbCrLf & _
  " 98) Aplicar TUDO" & vbCrLf & vbCrLf & _
  " REVERTER (onde aplicavel)" & vbCrLf & _
  "203) Reativar Compatibility Appraiser" & vbCrLf & _
  "204) Reverter Windows Update (wuauserv)" & vbCrLf & _
  "205) Reverter Windows Search (WSearch)" & vbCrLf & _
  "206) Reverter SysMain" & vbCrLf & _
  "207) Restaurar plano de energia anterior" & vbCrLf & _
  "208) Restaurar Efeitos Visuais anteriores" & vbCrLf & _
  " 99) Reverter TUDO possivel" & vbCrLf & vbCrLf & _
  " SUBMENUS" & vbCrLf & _
  "300) Reparos do Windows" & vbCrLf & _
  "400) Avancado (DISM com fonte local, Store, BITS, BSOD, etc.)" & vbCrLf & vbCrLf & _
  "  0) Sair"
End Function

' ================= SUBMENU: REPAROS =================
Sub ShowRepairMenu()
  Dim c
  Do
    c = InputBox( _
      "REPAROS DO WINDOWS" & vbCrLf & _
      "301) DISM /CheckHealth" & vbCrLf & _
      "302) DISM /ScanHealth" & vbCrLf & _
      "303) DISM /RestoreHealth" & vbCrLf & _
      "304) SFC /scannow" & vbCrLf & _
      "305) Limpeza de componentes (DISM /StartComponentCleanup /ResetBase)" & vbCrLf & _
      "306) Reset do Windows Update" & vbCrLf & _
      "307) Re-registrar DLLs do Windows Update" & vbCrLf & _
      "308) Reset de rede (Winsock/IP + flush DNS)" & vbCrLf & _
      "309) CHKDSK C: /scan (online)" & vbCrLf & _
      "310) CHKDSK C: /F /R (agenda no proximo boot)" & vbCrLf & _
      "398) Aplicar TODOS os reparos" & vbCrLf & _
      "  0) Voltar", "Tune-Up | Reparos", "")
    If c = "" Or c = "0" Then Exit Do
    If Not IsNumeric(c) Then
      MsgBox "Opcao invalida.", vbExclamation
    Else
      Select Case CInt(c)
        Case 301: RunDISM "/CheckHealth"
        Case 302: RunDISM "/ScanHealth"
        Case 303: RunDISM "/RestoreHealth"
        Case 304: RunSFC
        Case 305: StartComponentCleanup
        Case 306: ResetWindowsUpdate
        Case 307: ReregisterUpdateDLLs
        Case 308: ResetNetworkStack
        Case 309: CHKDSKScan
        Case 310: CHKDSKFixSchedule
        Case 398: RunAllRepairs
        Case Else: MsgBox "Opcao nao reconhecida.", vbExclamation
      End Select
    End If
  Loop
End Sub

' ================= SUBMENU: AVANCADO =================
Sub ShowAdvancedMenu()
  Dim c
  Do
    c = InputBox( _
      "AVANCADO" & vbCrLf & _
      "401) DISM /RestoreHealth com FONTE LOCAL (install.wim/esd + Index)" & vbCrLf & _
      "402) Restaurar Microsoft Store" & vbCrLf & _
      "403) Listar fila BITS (downloads pendentes)" & vbCrLf & _
      "404) Limpar fila BITS" & vbCrLf & _
      "405) Relatorio rapido de BSOD (ultimos 5) -> grava no log e abre" & vbCrLf & _
      "406) Abrir pasta de Minidumps" & vbCrLf & _
      "407) Reiniciar agora" & vbCrLf & _
      "  0) Voltar", "Tune-Up | Avancado", "")
    If c = "" Or c = "0" Then Exit Do
    If Not IsNumeric(c) Then
      MsgBox "Opcao invalida.", vbExclamation
    Else
      Select Case CInt(c)
        Case 401: RunDISMWithSource
        Case 402: RestoreMicrosoftStore
        Case 403: BITSList
        Case 404: BITSClear
        Case 405: QuickBSODReport
        Case 406: sh.Run "explorer.exe " & Chr(34) & sh.ExpandEnvironmentStrings("%SystemRoot%\Minidump") & Chr(34), 1, False
        Case 407: sh.Run "shutdown /r /t 0", 0, False
        Case Else: MsgBox "Opcao nao reconhecida.", vbExclamation
      End Select
    End If
  Loop
End Sub

' =============== INFO BASICA ===============
Sub ShowInfo()
  Dim osCaption, osVersion, ramGB, cpuModel, diskKind
  osCaption = GetWmiProp("Win32_OperatingSystem", "Caption")
  osVersion = GetWmiProp("Win32_OperatingSystem", "Version")
  ramGB    = FormatNumber(CDbl(GetWmiProp("Win32_ComputerSystem","TotalPhysicalMemory"))/1024/1024/1024, 2)
  cpuModel = GetWmiProp("Win32_Processor", "Name")
  diskKind = DetectDiskKind()
  Call LogLine("SO: " & osCaption & " (" & osVersion & ")")
  Call LogLine("RAM: " & ramGB & " GB")
  Call LogLine("CPU: " & cpuModel)
  Call LogLine("Disco (principal): " & diskKind)
  MsgBox "SO: " & osCaption & " (" & osVersion & ")" & vbCrLf & _
         "CPU: " & cpuModel & vbCrLf & _
         "RAM: " & ramGB & " GB" & vbCrLf & _
         "Disco: " & diskKind, vbInformation, "Informacoes"
End Sub

' =============== SNAPSHOT / BACKUP (mesmo do seu) ===============
Sub EnsureSnapshot()
  If Not fso.FileExists(bakPath) Then SnapshotState
End Sub

Sub SnapshotState()
  Call LogLine("Criando snapshot em " & bakPath)
  SnapshotService "wuauserv"
  SnapshotService "WSearch"
  SnapshotService "SysMain"
  SnapshotTask "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
  SnapshotTask "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
  SnapshotTask "\Microsoft\Windows\Application Experience\StartupAppTask"
  WriteKV "Power.ActiveGUID", GetActivePowerPlanGUID()
  SnapshotReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\VisualFXSetting"
  SnapshotReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\VisualFXSetting"
  SnapshotReg "HKCU\Control Panel\Desktop\WindowMetrics\MinAnimate"
  SnapshotReg "HKCU\Software\Microsoft\Windows\DWM\EnableAeroPeek"
End Sub

Sub SnapshotService(n)
  Dim svc, col, itm
  Set svc = GetObject("winmgmts:\\.\root\cimv2")
  Set col = svc.ExecQuery("SELECT * FROM Win32_Service WHERE Name='" & n & "'")
  For Each itm In col
    WriteKV "Svc." & n & ".StartMode", SafeStr(itm.StartMode)
    WriteKV "Svc." & n & ".State",     SafeStr(itm.State)
  Next
End Sub

Sub SnapshotTask(taskPath)
  Dim exists, enabled
  exists = TaskExists(taskPath)
  WriteKV "Task." & taskPath & ".Exists", exists
  If exists = "1" Then WriteKV "Task." & taskPath & ".Enabled", TaskEnabled(taskPath)
End Sub

Sub SnapshotReg(regPath)
  On Error Resume Next
  Dim val : val = sh.RegRead(regPath)
  If Err.Number <> 0 Then Err.Clear: WriteKV "Reg." & regPath, "__MISSING__" Else WriteKV "Reg." & regPath, CStr(val)
  On Error GoTo 0
End Sub

Function GetActivePowerPlanGUID()
  Dim tmp, out, g
  tmp = sh.ExpandEnvironmentStrings("%TEMP%") & "\pp.txt"
  RunHidden "cmd /c powercfg -GETACTIVESCHEME > """ & tmp & """", True
  If fso.FileExists(tmp) Then
    out = ReadAll(tmp): g = ExtractBetween(out, "(", ")")
    GetActivePowerPlanGUID = g
    On Error Resume Next: fso.DeleteFile tmp, True: On Error GoTo 0
  Else
    GetActivePowerPlanGUID = ""
  End If
End Function

' =============== ACOES (APLICAR/REVERTER) – iguais a sua versao ===============
Sub DisableAppraiser()
  DisableTask "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
  DisableTask "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
  DisableTask "\Microsoft\Windows\Application Experience\StartupAppTask"
End Sub

Sub StopDisableService(svcName)
  On Error Resume Next
  Dim svc, obj
  Set svc = GetObject("winmgmts:\\.\root\cimv2")
  For Each obj In svc.ExecQuery("SELECT * FROM Win32_Service WHERE Name='" & svcName & "'")
    If LCase(obj.State) = "running" Then obj.StopService
    obj.ChangeStartMode "Disabled"
  Next
  RunHidden "sc stop " & svcName, False
  RunHidden "sc config " & svcName & " start= disabled", False
  On Error GoTo 0
End Sub

Sub SetHighPerformancePlan()
  On Error Resume Next
  RunHidden "powercfg -SETACTIVE e9a42b02-d5df-448d-aa00-03f14749eb61", False
  RunHidden "powercfg -SETACTIVE SCHEME_MIN", False
  On Error GoTo 0
End Sub

Sub OptimizeVisualEffects()
  On Error Resume Next
  sh.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\VisualFXSetting", 2, "REG_DWORD"
  sh.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\VisualFXSetting", 2, "REG_DWORD"
  sh.RegWrite "HKCU\Control Panel\Desktop\WindowMetrics\MinAnimate", "0", "REG_SZ"
  sh.RegWrite "HKCU\Software\Microsoft\Windows\DWM\EnableAeroPeek", 0, "REG_DWORD"
  RunHidden "rundll32.exe user32.dll,UpdatePerUserSystemParameters", False
  On Error GoTo 0
End Sub

Sub CleanTemp(path)
  On Error Resume Next
  If Not fso.FolderExists(path) Then Exit Sub
  Dim folder, f, subf
  Set folder = fso.GetFolder(path)
  For Each f In folder.Files: f.Attributes = 0: f.Delete True: Next
  For Each subf In folder.SubFolders: subf.Attributes = 0: subf.Delete True: Next
  On Error GoTo 0
End Sub

Sub PrepareCleanMgrSageRun()
  Dim baseKey, cleaners, i
  baseKey = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\"
  cleaners = Array( _
    "Active Setup Temp Folders","Delivery Optimization Files","D3D Shader Cache", _
    "Device Driver Packages","Diagnostic Data Viewer database files","Downloaded Program Files", _
    "Internet Cache Files","Language Pack","Old ChkDsk Files","RetailDemo Offline Content", _
    "Service Pack Cleanup","Setup Log Files","System error memory dump files", _
    "System error minidump files","Temporary Files","Temporary Setup Files","Thumbnail Cache", _
    "Update Cleanup","User file versions","Windows Defender", _
    "Windows Error Reporting Archive Files","Windows Error Reporting Queue Files", _
    "Windows Error Reporting System Archive Files","Windows Error Reporting System Queue Files", _
    "Windows ESD installation files","Windows Upgrade Log Files" )
  For i = 0 To UBound(cleaners)
    On Error Resume Next
    sh.RegWrite baseKey & cleaners(i) & "\StateFlags0001", 2, "REG_DWORD"
    On Error GoTo 0
  Next
End Sub

Sub DisableTask(taskPath)
  On Error Resume Next
  RunHidden "schtasks /Change /TN """ & taskPath & """ /DISABLE", False
  RunHidden "schtasks /End /TN """ & taskPath & """", False
  On Error GoTo 0
End Sub

Sub ReEnableAppraiser()
  EnableTask "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
  EnableTask "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
  EnableTask "\Microsoft\Windows\Application Experience\StartupAppTask"
End Sub

Sub EnableTask(taskPath)
  On Error Resume Next
  If TaskExists(taskPath) = "1" Then RunHidden "schtasks /Change /TN """ & taskPath & """ /ENABLE", False
  On Error GoTo 0
End Sub

Sub RevertService(svcName)
  Dim startMode, statePrev
  startMode = ReadKV("Svc." & svcName & ".StartMode")
  statePrev = ReadKV("Svc." & svcName & ".State")
  If startMode = "" Then startMode = "Manual"
  On Error Resume Next
  RunHidden "sc config " & svcName & " start= " & LCase(startMode), False
  Dim svc, obj
  Set svc = GetObject("winmgmts:\\.\root\cimv2")
  For Each obj In svc.ExecQuery("SELECT * FROM Win32_Service WHERE Name='" & svcName & "'")
    obj.ChangeStartMode startMode
    If LCase(statePrev) = "running" Then obj.StartService
  Next
  On Error GoTo 0
End Sub

Sub RestorePowerPlan()
  Dim guid : guid = ReadKV("Power.ActiveGUID")
  If guid <> "" Then RunHidden "powercfg -SETACTIVE " & guid, False Else MsgBox "GUID do plano anterior nao encontrado.", vbExclamation
End Sub

Sub RestoreVisualEffects()
  RestoreReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\VisualFXSetting"
  RestoreReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\VisualFXSetting"
  RestoreReg "HKCU\Control Panel\Desktop\WindowMetrics\MinAnimate"
  RestoreReg "HKCU\Software\Microsoft\Windows\DWM\EnableAeroPeek"
  RunHidden "rundll32.exe user32.dll,UpdatePerUserSystemParameters", False
End Sub

Sub RestoreReg(regPath)
  Dim v : v = ReadKV("Reg." & regPath)
  On Error Resume Next
  If v = "__MISSING__" Then
    sh.RegDelete regPath
  ElseIf v <> "" Then
    If IsNumeric(v) Then
      If InStr(regPath, "DWM") > 0 Or InStr(regPath, "VisualFXSetting") > 0 Then
        sh.RegWrite regPath, CLng(v), "REG_DWORD"
      Else
        sh.RegWrite regPath, v, "REG_SZ"
      End If
    Else
      sh.RegWrite regPath, v, "REG_SZ"
    End If
  End If
  On Error GoTo 0
End Sub

Sub RestoreAll()
  If Not fso.FileExists(bakPath) Then MsgBox "Snapshot nao encontrado.", vbExclamation: Exit Sub
  ReEnableAppraiser
  RevertService "wuauserv"
  RevertService "WSearch"
  RevertService "SysMain"
  RestorePowerPlan
  RestoreVisualEffects
  MsgBox "Reversao completa (onde aplicavel) concluida."
End Sub

' =============== REPAROS ===============
Sub RunDISM(args)
  EnsureSnapshot
  RunHidden "DISM /Online /Cleanup-Image " & args, True
  MsgBox "DISM " & args & " concluido. Veja o log.", vbInformation
End Sub

Sub RunSFC()
  EnsureSnapshot
  RunHidden "sfc /scannow", True
  MsgBox "SFC concluido. Reinicio pode ser necessario.", vbInformation
End Sub

Sub StartComponentCleanup()
  EnsureSnapshot
  RunHidden "DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase", True
  MsgBox "Limpeza de componentes concluida.", vbInformation
End Sub

Sub ResetWindowsUpdate()
  EnsureSnapshot
  RunHidden "net stop wuauserv", True
  RunHidden "net stop bits", True
  RunHidden "net stop cryptsvc", True
  Dim ts : ts = Replace(Replace(Replace(Now, ":", ""), "/", "-"), " ", "_")
  On Error Resume Next
  If fso.FolderExists("C:\Windows\SoftwareDistribution") Then _
    fso.MoveFolder "C:\Windows\SoftwareDistribution", "C:\Windows\SoftwareDistribution.bak_" & ts
  If fso.FolderExists("C:\Windows\System32\catroot2") Then _
    fso.MoveFolder "C:\Windows\System32\catroot2", "C:\Windows\System32\catroot2.bak_" & ts
  On Error GoTo 0
  RunHidden "net start cryptsvc", True
  RunHidden "net start bits", True
  RunHidden "net start wuauserv", True
  MsgBox "Windows Update resetado.", vbInformation
End Sub

Sub ReregisterUpdateDLLs()
  EnsureSnapshot
  Dim dlls, i
  dlls = Array("atl.dll","urlmon.dll","mshtml.dll","shdocvw.dll","browseui.dll","jscript.dll","vbscript.dll", _
               "scrrun.dll","msxml.dll","msxml3.dll","msxml6.dll","actxprxy.dll","softpub.dll","wintrust.dll", _
               "dssenh.dll","rsaenh.dll","gpkcsp.dll","sccbase.dll","slbcsp.dll","cryptdlg.dll","oleaut32.dll", _
               "ole32.dll","shell32.dll","wuapi.dll","wuaueng.dll","wuaueng1.dll","wucltui.dll","wups.dll", _
               "wups2.dll","wuweb.dll","qmgr.dll","qmgrprxy.dll","wucltux.dll","muweb.dll","wuwebv.dll")
  For i = 0 To UBound(dlls)
    RunHidden "regsvr32 /s " & dlls(i), True
  Next
  MsgBox "DLLs do Windows Update re-registradas.", vbInformation
End Sub

Sub ResetNetworkStack()
  EnsureSnapshot
  RunHidden "netsh winsock reset", True
  RunHidden "netsh int ip reset", True
  RunHidden "ipconfig /flushdns", True
  MsgBox "Pilha de rede resetada. Recomenda-se reiniciar.", vbInformation
End Sub

Sub CHKDSKScan()
  EnsureSnapshot
  RunHidden "chkdsk C: /scan", True
  MsgBox "CHKDSK /scan concluido (online).", vbInformation
End Sub

Sub CHKDSKFixSchedule()
  EnsureSnapshot
  RunHidden "cmd /c echo Y| chkdsk C: /F /R", True
  If MsgBox("Correcao profunda agendada para o proximo boot." & vbCrLf & _
            "Deseja reiniciar AGORA?", vbQuestion + vbYesNo, "CHKDSK agendado") = vbYes Then
    sh.Run "shutdown /r /t 0", 0, False
  Else
    MsgBox "Reinicie quando possivel para executar o CHKDSK.", vbInformation
  End If
End Sub

Sub RunAllRepairs()
  RunDISM "/CheckHealth"
  RunDISM "/ScanHealth"
  RunDISM "/RestoreHealth"
  StartComponentCleanup
  RunSFC
  ResetWindowsUpdate
  ReregisterUpdateDLLs
  ResetNetworkStack
  CHKDSKScan
  MsgBox "Todos os reparos executados. Se necessario, agende CHKDSK /F /R (submenu Reparos - 310).", vbInformation
End Sub

' =============== AVANCADO ===============
Sub RunDISMWithSource()
  EnsureSnapshot
  Dim src, idx, ext, arg
  src = InputBox("Caminho para install.wim ou install.esd (ex.: D:\sources\install.wim)", "DISM com Fonte Local", "")
  If src = "" Then Exit Sub
  idx = InputBox("INDEX da imagem (ex.: 1 ou 6)", "DISM com Fonte Local", "1")
  If idx = "" Then Exit Sub
  ext = LCase(Right(src, 3))
  If ext = "wim" Then
    arg = "/RestoreHealth /Source:wim:" & Chr(34) & src & Chr(34) & ":" & idx & " /LimitAccess"
  ElseIf ext = "esd" Then
    arg = "/RestoreHealth /Source:esd:" & Chr(34) & src & Chr(34) & ":" & idx & " /LimitAccess"
  Else
    MsgBox "Extensao nao reconhecida. Use .wim ou .esd", vbExclamation: Exit Sub
  End If
  RunHidden "DISM /Online /Cleanup-Image " & arg, True
  MsgBox "DISM com fonte local concluido.", vbInformation
End Sub

Sub RestoreMicrosoftStore()
  EnsureSnapshot
  RunHidden "powershell -NoProfile -ExecutionPolicy Bypass -Command ""Get-AppxPackage -AllUsers *WindowsStore* | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register ($_.InstallLocation + '\AppxManifest.xml')}""", True
  MsgBox "Microsoft Store re-registrada.", vbInformation
End Sub

Sub BITSList()
  EnsureSnapshot
  Dim tmp : tmp = sh.ExpandEnvironmentStrings("%TEMP%") & "\bits_list.txt"
  RunHidden "powershell -NoProfile -ExecutionPolicy Bypass -Command ""Get-BitsTransfer -AllUsers | Format-List * | Out-File -Encoding UTF8 '" & tmp & "'""", True
  Call LogLine("BITS List salvo em " & tmp)
  sh.Run "notepad.exe " & Chr(34) & tmp & Chr(34), 1, False
End Sub

Sub BITSClear()
  EnsureSnapshot
  RunHidden "powershell -NoProfile -ExecutionPolicy Bypass -Command ""Get-BitsTransfer -AllUsers | Remove-BitsTransfer -Confirm:$false""", True
  MsgBox "Fila BITS limpa.", vbInformation
End Sub

Sub QuickBSODReport()
  EnsureSnapshot
  Dim tmp : tmp = sh.ExpandEnvironmentStrings("%TEMP%") & "\bsod_report.txt"
  RunHidden "powershell -NoProfile -ExecutionPolicy Bypass -Command ""Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-WER-SystemErrorReporting'; Id=1001} -MaxEvents 5 | Format-List TimeCreated,Message | Out-File -Encoding UTF8 '" & tmp & "'""", True
  Call LogLine("BSOD report salvo em " & tmp)
  sh.Run "notepad.exe " & Chr(34) & tmp & Chr(34), 1, False
End Sub

' =============== HELPERS DIVERSOS ===============
Function IsAdmin()
  On Error Resume Next
  Dim testKey : testKey = "HKLM\SOFTWARE\TuneUpAdminTest\"
  sh.RegWrite testKey, ""
  If Err.Number = 0 Then
    sh.RegDelete testKey
    IsAdmin = True
  Else
    IsAdmin = False
    Err.Clear
  End If
  On Error GoTo 0
End Function

Sub LogLine(t)
  On Error Resume Next
  logFile.WriteLine t
  On Error GoTo 0
End Sub

Function GetWmiProp(className, propName)
  On Error Resume Next
  Dim svc, col, itm
  Set svc = GetObject("winmgmts:\\.\root\cimv2")
  Set col = svc.ExecQuery("SELECT " & propName & " FROM " & className)
  For Each itm In col
    GetWmiProp = itm.Properties_.Item(propName).Value
    Exit For
  Next
  If IsNull(GetWmiProp) Or GetWmiProp = "" Then GetWmiProp = "N/D"
  On Error GoTo 0
End Function

Function DetectDiskKind()
  On Error Resume Next
  Dim svc, dd, kind, rotation, model, media
  kind = "Desconhecido"
  Set svc = GetObject("winmgmts:\\.\root\cimv2")
  For Each dd In svc.ExecQuery("SELECT Model, MediaType, RotationRate, InterfaceType FROM Win32_DiskDrive")
    model = LCase(Trim(NullToEmpty(dd.Model)))
    media = LCase(Trim(NullToEmpty(dd.MediaType)))
    rotation = ""
    On Error Resume Next: rotation = dd.RotationRate: On Error GoTo 0
    If InStr(model, "nvme") > 0 Or InStr(media, "nvme") > 0 Then
      kind = "NVMe (SSD)": Exit For
    ElseIf IsNumeric(rotation) Then
      If CLng(rotation) > 0 Then kind = "HDD (" & rotation & " RPM)" Else kind = "SSD"
    ElseIf InStr(media, "solid") > 0 Or InStr(media, "ssd") > 0 Then
      kind = "SSD"
    ElseIf InStr(media, "fixed") > 0 Or InStr(model, "st") > 0 Then
      kind = "HDD"
    End If
  Next
  DetectDiskKind = kind
  On Error GoTo 0
End Function

Function NullToEmpty(v)
  If IsNull(v) Then NullToEmpty = "" Else NullToEmpty = v
End Function

Sub RunHidden(cmd, wait)
  On Error Resume Next
  Dim rc : rc = sh.Run(cmd, 0, wait)
  Call LogLine("CMD: " & cmd & " (rc=" & rc & ")")
  On Error GoTo 0
End Sub

Function TaskExists(taskPath)
  Dim rc
  rc = sh.Run("schtasks /Query /TN """ & taskPath & """ >nul 2>&1", 0, True)
  If rc = 0 Then TaskExists = "1" Else TaskExists = "0"
End Function

Function TaskEnabled(taskPath)
  Dim tmp, out
  tmp = sh.ExpandEnvironmentStrings("%TEMP%") & "\taskq.txt"
  RunHidden "cmd /c schtasks /Query /TN """ & taskPath & """ /FO LIST /V > """ & tmp & """", True
  If fso.FileExists(tmp) Then
    out = LCase(ReadAll(tmp))
    If InStr(out, "disabled") > 0 Then TaskEnabled = "0" Else TaskEnabled = "1"
    On Error Resume Next: fso.DeleteFile tmp, True: On Error GoTo 0
  Else
    TaskEnabled = ""
  End If
End Function

Function ExtractBetween(s, a, b)
  Dim p1, p2
  p1 = InStr(s, a)
  If p1 = 0 Then ExtractBetween = "": Exit Function
  p2 = InStr(p1 + Len(a), s, b)
  If p2 = 0 Then ExtractBetween = "": Exit Function
  ExtractBetween = Mid(s, p1 + Len(a), p2 - (p1 + Len(a)))
End Function

Function ReadAll(p)
  Dim tf: Set tf = fso.OpenTextFile(p, 1, False)
  ReadAll = tf.ReadAll
  tf.Close
End Function

Function SafeStr(v)
  If IsNull(v) Then SafeStr = "" Else SafeStr = CStr(v)
End Function

' ======= KV (Backup INI simples) =======
Sub WriteKV(k, v)
  Dim dict: Set dict = LoadAllKV()
  dict(k) = CStr(v)
  SaveAllKV dict
End Sub

Function ReadKV(k)
  Dim dict: Set dict = LoadAllKV()
  If dict.Exists(k) Then ReadKV = dict(k) Else ReadKV = ""
End Function

Function LoadAllKV()
  Dim d: Set d = CreateObject("Scripting.Dictionary")
  If Not fso.FileExists(bakPath) Then Set LoadAllKV = d: Exit Function
  Dim tf, line, p
  Set tf = fso.OpenTextFile(bakPath, 1, False)
  Do Until tf.AtEndOfStream
    line = tf.ReadLine
    If Len(line) > 0 And Left(line,1) <> "#" Then
      p = InStr(line, "=")
      If p > 0 Then d(Trim(Left(line, p-1))) = Mid(line, p+1)
    End If
  Loop
  tf.Close
  Set LoadAllKV = d
End Function

Sub SaveAllKV(d)
  Dim tf, k
  Set tf = fso.OpenTextFile(bakPath, 2, True)
  tf.WriteLine "# TuneUp Backup - atualizado em " & Now
  For Each k In d.Keys
    tf.WriteLine k & "=" & d(k)
  Next
  tf.Close
End Sub
