Connect-ExchangeOnline
# List of shared mailboxes
$sharedMailboxes = @(
  
    # Add more shared mailboxes as needed
)

# Path to save the CSV file eg * change location to export file 
$outputFile = "/Users/jlucena/Documents/AllSharedMailboxMembers.csv"

# Initialize an empty array to store results
$allResults = @()

# Loop through each shared mailbox
foreach ($sharedMailbox in $sharedMailboxes) {
    $members = Get-MailboxPermission -Identity $sharedMailbox | Where-Object { $_.AccessRights -eq "FullAccess" -and $_.User -notlike "NT AUTHORITY\SELF" } | Select-Object User

    foreach ($member in $members) {
        $userDetails = Get-Recipient -Identity $member.User
        $allResults += [PSCustomObject]@{
            SharedMailbox = $sharedMailbox
            Name          = $userDetails.DisplayName
            Email         = $userDetails.PrimarySmtpAddress
        }
    }
}

# Export the combined results to a CSV file
$allResults | Export-Csv -Path $outputFile -NoTypeInformation