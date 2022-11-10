##############
# iLOFWInventory v1.0 by Gary Howard
# Prereq: PWSH 5.x or later, HPEilocmdlets module, ilo.csv file
# Purpose: To query iLO to display FW information on any hardware that has firmware
# Updates: none 
##############

#Greet user and Ask ilo Creds
Write-Host "iLOFWLock v1.0 by Gary Howard"
Write-Host "Please Provide iLO Credentials that will be used to access all iLOs"
$Creds = Get-Credential -Message "Enter iLO Username and Password"

#Ask user for choice of Single IP address or CSV file to stores it in an Array for muliple servers
$choice = Read-Host "Please choose (1) for single iLO or (2) for muliple iLOs" 
if($choice -eq 1){
    $Hostname = Read-Host "Please provide iLO IP address"
}else {
    $filepath = Read-Host "Please provide the full path of the CSV file ex C:\Users"
$Hostname=@()
Import-Csv $filepath | ForEach-Object{
    $Hostname += $_.hostname
}
}

#Connect to ilO and changes downgrade policy 
$connection = Connect-HPEilo -ip $Hostname -Credential $Creds
$inventory = $connection | Get-HPEiLOFirmwareInventory 
$inventory.FirmwareInformation | Export-Csv -Path C:\FWinvo.csv

#Exit Message
Write-Host "Script Completed" -ForegroundColor Green
