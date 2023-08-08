# Function to write log entries
function Write-Log {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Info", "Success", "Error", "Warning", "Debug", "Critical")]
        [string]$Severity = "Info",

        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [string]$RequestID,

        [Parameter(Mandatory = $false)]
        [ValidateSet("AD", "SNow", "AAD")]
        [string]$Category,

        [Parameter(Mandatory = $false)]
        [string]$LogFilePath,

        [Parameter(Mandatory = $false)]
        [string]$TimestampFormat = "yyyy-MM-dd HH:mm:ss"
    )

    # Construct a log entry object with specified properties
    $logEntry = [PSCustomObject]@{
        Timestamp = Get-Date -Format $TimestampFormat
        Severity = $Severity
        RequestID = $RequestID
        Message = $Message
        Category = $Category
    }

    # If a log file path is provided, handle logging to the CSV file
    if ($LogFilePath) {
        # If the log file doesn't exist, create a new one with headers and append the log entry
        if (-not (Test-Path $LogFilePath)) {
            $logEntry | Export-Csv -Path $LogFilePath -NoTypeInformation -Append -Force
        } else {
            # If the log file already exists, check if the headers are present
            $headersExist = (Get-Content $LogFilePath -TotalCount 1) -match 'Timestamp|Severity|RequestID|Message|Category'
            
            # If headers are missing, add them and then append the log entry
            if (-not $headersExist) {
                $logEntry | Export-Csv -Path $LogFilePath -NoTypeInformation -Append -Force
            } else {
                # If headers are present, simply append the log entry
                $logEntry | Export-Csv -Path $LogFilePath -NoTypeInformation -Append
            }
        }
    }

    # Return the constructed log entry object
    return $logEntry
}
