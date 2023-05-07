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
$Drives = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"

# Iterate through each drive letter
foreach ($Drive in $Drives) {
    # Search and remove "fn.txt" files, then log their locations
    Get-ChildItem -Path "$($Drive.DeviceID)\" -Filter "fn.txt" -Recurse -ErrorAction SilentlyContinue -Force |
    ForEach-Object {
        try {
            # Remove the "fn.txt" file
            Remove-Item $_.FullName -Force

            # Log the removed file location
            $LogMessage = "Removed file: $($_.FullName)"
            Out-File -FilePath $LogFile -Append -InputObject $LogMessage
        }
        catch {
            Write-Warning "Failed to remove file: $($_.FullName)"
        }
    }
}

# Display the contents of the log file
Get-Content $LogFile
