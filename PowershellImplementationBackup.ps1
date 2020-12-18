
######################################################################################################
######################################################################################################
##                                                                                                  ##
## BackupScript                                                                                     ##
## Nicola Fioretti                                                                                  ##
## Laurin Lötscher                                                                                  ##
##                                                                                                  ##
######################################################################################################
######################################################################################################



# @Desc Macht das Backup
# @Return Nichts
# @Param: $SourcePath - Quellverzeichnis, von diesem Ordner aus wird alles Kopiert
# @Param: $BackUpPath - Backupverzeicniss in diesen Ordner wird alles Kopiert
# @Param: $LogFilePath - Verzeichniss zur Logdatei - in diese Datei werden alle Meldungen ausgegeben. Wenn die Datei nicht vorhanden ist wird sie erstellt, die Ordnerstruktur jedoch nicht
# @Param: $WriteLogToHost - Boolean: wenn true werden die Log-Nachrichten auch im Write-Host ausgegeben.
function doBackup(
$SourcePath = 'C:\Backup\Source\', 
$BackUpPath = 'C:\Backup\Backup\',
$LogFilePath = 'C:\Backup\Log\log.txt',
[bool]$WriteLogToHost = 1
){
    if (-not(Test-Path $LogFilePath -PathType Leaf)){
        New-Item -Path $LogFilePath -ItemType File
        LogMessage -Message "Ungültiges Log-File." -doHostWrite $WriteLogToHost -LogPath $LogFilePath 
    }
    if (-not(Test-Path $SourcePath)){
        LogMessage -Message "Ungültiges Quellverzeichnis. Breche ab..." -doHostWrite $WriteLogToHost -LogPath $LogFilePath 
        return
        
    }
    if (-not(Test-Path $BackUpPath)){
        New-Item -Path $BackUpPath -ItemType Directory
         LogMessage -Message "Ungültiges BackUp-Verzeichnis angegeben. Breche ab..." -doHostWrite $WriteLogToHost -LogPath $LogFilePath 
         return
    }    
    LogMessage -Message "Alle Parameter sind Korrekt. Backup Wird gestartet" -doHostWrite $WriteLogToHost -LogPath $LogFilePath
    
    #Starte Backup


    Get-ChildItem -Path $SourcePath -Recurse | ForEach-Object {
        if ($_.DirectoryName -eq $null){
        LogMessage -Message "Ordner Entdeckt: $_" -doHostWrite $WriteLogToHost -LogPath $LogFilePath
        }
        else{
        LogMessage -Message "Datei Entdeckt: $_" -doHostWrite $WriteLogToHost -LogPath $LogFilePath
            Set-Location $SourcePath
            $relativePath = Resolve-Path -Relative $_.Directory
            Set-Location $BackUpPath
            if (-not(Test-Path $relativePath)){
                mkdir $relativePath
                LogMessage -Message "Neuer Ordner erstellt: $relativePath" -doHostWrite $WriteLogToHost -LogPath $LogFilePath
            }
            if ($relativePath.StartsWith("..")){
                $_ | Copy-Item -Destination $BackUpPath
                LogMessage -Message "Datei Kopiert $_" -doHostWrite $WriteLogToHost -LogPath $LogFilePath
            }
            else{
                $_ | Copy-Item -Destination $relativePath
                LogMessage -Message "Datei Kopiert $_" -doHostWrite $WriteLogToHost -LogPath $LogFilePath
            }
            
        }
    }

    #Get-Item -Path $SourcePath| Get-ChildItem -Recurse | foreach { LogMessage -Message $_ -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath }

    LogMessage -Message "Das Backup wurde abgeschlossen" -doHostWrite $WriteLogToHost -LogPath $LogFilePath

    $FilesMissing = checkBackup -SourcePath $SourcePath -BackUpPath $BackUpPath -doHostWrite $WriteLogToHost -LogPath $LogFilePath

    if ($FilesMissing -eq 0){
        LogMessage -Message "Beim Backup wurden alle Datein übernommen" -doHostWrite $WriteLogToHost -LogPath $LogFilePath   
    }
    else{
        LogMessage -Message "Es wurden $FilesMissing nicht richtig im Backup gespeichert" -doHostWrite $WriteLogToHost -LogPath $LogFilePath 
    }


   
}

# @Desc Schreibt das Log mit Time-Stamp.
# @Return Nichts
# @Param: $Message - Die Nachricht welche ausgegeben werden soll
# @Param: $doHostWrite - Boolean: wenn true werden die Log-Messages auch auf der Konsole angezeigt
# @Param: $LogPath - Die Datei mit Pfad in welche die Ausgabe angefügt wird.
function LogMessage(
$Message = "",
[bool]$doHostWrite = 1,
$LogPath = 'C:\Backup\Log\log.txt'
){
if (Test-Path $LogPath -PathType Leaf){
        $MessageToWrite = "["+(Get-Date -Format "dd/MM/yyyy HH:mm:ss") + "]:"+$Message+ "(" + (Get-PSCallStack | Select-Object -Property Command) + ")"
        $MessageToWrite|Add-Content $LogPath
           
    }
    if(!$doHostWrite){return}
    Write-Host "["(Get-Date -Format "dd/MM/yyyy HH:mm:ss") "]:"$Message  "(" (Get-PSCallStack | Select-Object -Property Command) ")"


    
    
}


# @Desc ¨Überprüft ob das Backup funktioniert hat
# @Return Anzahl Fehlender oder Veralteter Dateien
# @Param: $SourcePath - Quellverzeichnis, der Ordner aus welchem das Backup gemacht wurde
# @Param: $BackUpPath - Backupverzeicniss der Ordner in welchem das Backup gespeichert ist
# @Param: $WriteLogToHost - Boolean: wenn true werden die Log-Nachrichten auch im Write-Host ausgegeben.
# @Param: $LogPath - Das Verzeichniss zum Log file. Muss vorhanden un korrekt sein
function checkBackup(
$SourcePath = "C:\Backup\Source\",
$BackUpPath = 'C:\Backup\Backup\',
[bool]$doHostWrite = $true ,
$LogPath = 'C:\Backup\Log\log.txt'
){
     $MissingFiles = 0
     Get-ChildItem -Path $SourcePath -Recurse | ForEach-Object {
        if ($_.DirectoryName -ne $null){
            Set-Location $SourcePath
            $relativePath = Resolve-Path -Relative $_.FullName
            Set-Location $BackUpPath
            if (-not(Test-Path $relativePath -PathType Leaf)){
                LogMessage -Message "Eine Datei wurde nicht richtig gespeichert: $_" -doHostWrite $doHostWrite -LogPath $LogPath
                $MissingFiles++
            }
            else {
                if ((Get-Content $_.FullName) -ne $null){
                    if(Compare-Object -ReferenceObject (Get-Content (Get-Item $relativePath)) -DifferenceObject (Get-Content $_.FullName)){
                        LogMessage -Message "Eine Datei wurde im Backup gefunden, ist jedoch nicht aktuell: $_" -doHostWrite $doHostWrite -LogPath $LogPath
                        $MissingFiles++ 
                    }
                }
  
            }
        }
    }
    return $MissingFiles
}



