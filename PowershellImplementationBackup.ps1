
######################################################################################################
######################################################################################################
##                                                                                                  ##
## BackupStrategie                                                                                  ##
## Nicola Fioretti                                                                                  ##
## Laurin Lötscher                                                                                  ##
##                                                                                                  ##
######################################################################################################
######################################################################################################



# @Desc Macht das Backup
# @Return das ergebniss der Addition von den beiden parameter
# @Param: $ErsteZahl - Die erste Zahl für die Addition
# @Param: $ZweiteZahl - Die zweite Zahl für die Addition
function doBackup(
$SourcePath = 'C:\Backup\Source\', 
$BackUpPath = 'C:\Backup\Backup\',
$LogFilePath = 'C:\Backup\Log\log.txt',
[bool]$WriteLogToHost = 1
){
    if (-not(Test-Path $LogFilePath -PathType Leaf)){
        New-Item -Path $LogFilePath -ItemType File
        LogMessage -Message "Ungültiges Log-File. Es wurde eines Erstellt" -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath 
    }
    if (-not(Test-Path $SourcePath)){
        LogMessage -Message "Ungültiges Quellverzeichnis" -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath 
        
    }
    if (-not(Test-Path $BackUpPath)){
        New-Item -Path $BackUpPath -ItemType Directory
         LogMessage -Message "Ungültiges BackUp-Verzeichnis angegeben. Es wurde ein Neues erstellt" -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath 
    }    
    LogMessage -Message "Alle Parameter sind Korrekt. Backup Wird gestartet" -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath
    
    #Starte Backup


    Get-ChildItem -Path $SourcePath -Recurse | ForEach-Object {
        if ($_.DirectoryName -eq $null){
        LogMessage -Message "Ordner Entdeckt: $_" -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath
        }
        else{
        LogMessage -Message "Datei Entdeckt: $_" -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath
            Set-Location $SourcePath
            $relativePath = Resolve-Path -Relative $_.Directory
            Set-Location $BackUpPath
            if (-not(Test-Path $relativePath)){
                mkdir $relativePath
                LogMessage -Message "Neuer Ordner erstellt: $relativePath" -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath
            }
            if ($relativePath.StartsWith("..")){
                $_ | Copy-Item -Destination $BackUpPath
                LogMessage -Message "Datei Kopiert $_" -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath
            }
            else{
                $_ | Copy-Item -Destination $relativePath
                LogMessage -Message "Datei Kopiert $_" -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath
            }
            
        }
    }

    #Get-Item -Path $SourcePath| Get-ChildItem -Recurse | foreach { LogMessage -Message $_ -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath }

    LogMessage -Message "Das Backup wurde abgeschlossen" -WriteToLogFile $WriteLogToHost -LogPath $LogFilePath

    Compare-Object -ReferenceObject (Get-ChildItem $SourcePath -Recurse) -DifferenceObject (Get-ChildItem $BackUpPath -Recurse) -Property Name,Length| Write-Host
}

# @Desc Macht das Backup
# @Return das ergebniss der Addition von den beiden parameter
# @Param: $ErsteZahl - Die erste Zahl für die Addition
# @Param: $ZweiteZahl - Die zweite Zahl für die Addition
function LogMessage(
$Message = "",
[bool]$WriteToLogFile = 'true',
$LogPath = 'C:\Backup\Log\log.txt'
){
    Write-Host "["(Get-Date -Format "dd/MM/yyyy HH:mm:ss") "]:"$Message
    if(!$WriteToLogFile){return}
    if (Test-Path $LogPath -PathType Leaf){
        $MessageToWrite = "["+(Get-Date -Format "dd/MM/yyyy HH:mm:ss") + "]:"+$Message
        $MessageToWrite|Add-Content $LogPath
           
    }
}



