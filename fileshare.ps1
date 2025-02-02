param (
    [Parameter(Mandatory=$true)][String]$SAKey,
    [Parameter(Mandatory=$true)][String]$SAName,
    [Parameter(Mandatory=$true)][String]$FSName,
    [Parameter(Mandatory=$true)][String]$MountPath
)

if (-not $SAKey -or -not $SAName -or -not $FSName -or -not $MountPath) {
    Write-Host "Missing req parameters Usage:" -ForegroundColor Red 
    Write-Host "  .\fileshare.ps1 -SAKey <StorageAccountKey> -SAName <StorageAccountName> -FSName <FileShareName> -MountPath <MountPath>" -ForegroundColor Yellow
    exit 1
}

if(Test-Path "$MountPath") {
    net use ${MountPath}: /delete /y
}

cmdkey /list

cmdkey /delete:"$SAName.file.core.windows.net"

$SAKey=[System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::UTF8.GetBytes($SAKey))

$SAKey=$SAKey.Trim() -replace '\s',''


$RootPath="\\$SAName.file.core.windows.net\$FSName"
$UserName="localhost\$SAName"
$UserName=$UserName.Trim() 

Write-Host "User Name: $UserName" -ForegroundColor Cyan 

Write-Host "Storage Account Name: $SAName" -ForegroundColor Cyan
Write-Host "Storage Account Key: $SAKey" -ForegroundColor Cyan
Write-Host "length of Storage Account Key: $($SAKey.Length)" -ForegroundColor Cyan
Write-Host "File Share Name: $FSName" -ForegroundColor Cyan
Write-Host "Mount Path: $MountPath" -ForegroundColor Cyan

Write-Host "Attempting to mount the file share $FSName from storage account $SAName to $MountPath" -ForegroundColor Cyan
# # Save credentials
# # cmd.exe /C "cmdkey /add:`"$SAName.file.core.windows.net`" /user:`"$UserName`" /pass:`"$SAKey`""
# cmd.exe /C "cmdkey /add:`"$($SAName).file.core.windows.net`" /user:`"$($UserName)`" /pass:`"$($SAKey)`""



# Write-Host "Mounting file share $FSName from storage account $SAName to $MountPath" -ForegroundColor Cyan
# # Mount the file share

# cmd.exe /C "net use ${MountPath}: ${RootPath} /user:${UserName} ${SAKey}"


# Write-Host "Confirming the drive is mounted" -ForegroundColor Green

Test-NetConnection -ComputerName "$SAName.file.core.windows.net" -Port 445 
$cmdKeyCommand = "cmdkey /add:`"$($SAName).file.core.windows.net`" /user:`"$($UserName)`" /pass:`"$($SAKey)`""
Write-Host "Executing: $cmdKeyCommand" -ForegroundColor Yellow
cmd.exe /C $cmdKeyCommand

Write-Host "Mounting file share $FSName from storage account $SAName to $MountPath" -ForegroundColor Cyan

# Mount the file share
$netUseCommand = "net use ${MountPath}: ${RootPath} /user:${UserName} ${SAKey}"
Write-Host "Executing: $netUseCommand" -ForegroundColor Yellow
cmd.exe /C $netUseCommand

Write-Host "Confirming the drive is mounted" -ForegroundColor Green


