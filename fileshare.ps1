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
$RootPath="\\$SAName.file.core.windows.net\$FSName"

Write-Host "Attempting to mount the file share $FSName from storage account $SAName to $MountPath" -ForegroundColor Cyan
# Save credentials
cmd.exe /C "cmdkey /add:`"$SAName.file.core.windows.net`" /user:`"$SAName`" /pass:`"$SAKey`""

Write-Host "Mounting file share $FSName from storage account $SAName to $MountPath" -ForegroundColor Cyan
# Mount the file share

cmd.exe /C "net use ${MountPath}: ${RootPath} /user:${SAName} ${SAKey}"

Write-Host "Confirming the drive is mounted" -ForegroundColor Green
