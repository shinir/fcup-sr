# PowerShell script to block an IP address using Windows Firewall with an argument

param(
    [string]$IPAddressToBlock
)

# Check if IP address is passed as an argument
if(-not $IPAddressToBlock) {
    Write-Host "No IP address provided. Please provide an IP address as an argument."
    exit
}

# Define the name of the rule
$RuleName = "Block IP Address - $IPAddressToBlock"

# Create the new firewall rule
New-NetFirewallRule -DisplayName $RuleName -Direction Inbound -Action Block -RemoteAddress $IPAddressToBlock -Protocol Any -Profile Any

# Output the status
Write-Host "Firewall rule '$RuleName' to block IP address $IPAddressToBlock has been created."
