# Get the current date and time and format it as a string
$DateTimeStamp = (Get-Date).ToString("yyyyMMdd-HHmmss")

# Get the hostname
$HostName = $env:COMPUTERNAME

# Define the log file path with the hostname and runtime included
$LogFile = "removed_fn_txt_${HostName}_$DateTimeStamp.log"

# Clear the content of the log file if it already exists
if (Test-Path $LogFile) {
    Clear-Content $LogFile
}

# Get all available drive letters
$Drives = Get-PSDrive -PSProvider 'FileSystem'

# Iterate through each drive letter
foreach ($Drive in $Drives) {
    # Search and remove "fn.txt" files, then log their locations
    Get-ChildItem -Path "$($Drive.Name):\" -Filter "fn.txt" -Recurse -ErrorAction SilentlyContinue -Force |
    ForEach-Object {
        try {
            # Remove the "fn.txt" file
            Remove-Item $_.FullName -Force

            # Log the removed file location
            Write-Output "Removed file: $($_.FullName)" | Out-File -Append $LogFile
        }
        catch {
            Write-Warning "Failed to remove file: $($_.FullName)"
        }
    }
}

# Display the contents of the log file
Get-Content $LogFile
