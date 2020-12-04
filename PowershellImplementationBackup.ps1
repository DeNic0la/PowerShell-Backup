
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
[bool]$WriteLogToHost = 'false'
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



