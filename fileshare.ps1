# Set variables
$StorageAccount = "mystoragenew1234567"
$FileShareName = "cirrusfileshare"
$StorageKey = "5AjazBGvc3aAXEf5KAkAZi9Nlrb19aTH80LBuMLDuOFJ7FovPf9m9VIarvsSNUFBQeOdsOnBrE66+AStUphkWg=="
$MountPath = "X"
$RootPath="\\$StorageAccount.file.core.windows.net\$FileShareName"

# Save credentials
cmd.exe /C "cmdkey /add:`"$($StorageAccount).file.core.windows.net`" /user:`"$StorageAccount`" /pass:`"$StorageKey`""

# Mount the file share
New-PSDrive -Name $MountPath -PSProvider FileSystem -Root $RootPath -Persist

# Confirm the drive is mounted
Get-PSDrive | Where-Object { $_.Name -eq $MountPath }
