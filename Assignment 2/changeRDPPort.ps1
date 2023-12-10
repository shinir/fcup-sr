# PowerShell Script to Change RDP Port to a Random Unused Port

# Define a function to check if a port is in use
function Test-PortInUse {
    param (
        [Parameter(Mandatory=$true)]
        [int]$Port
    )

    $inUse = $false
    $endPoints = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetActiveTcpListeners()
    foreach ($ep in $endPoints) {
        if ($ep.Port -eq $Port) {
            $inUse = $true
            break
        }
    }
    return $inUse
}

# Generate a random port and check if it's in use
do {
    $randomPort = Get-Random -Minimum 1025 -Maximum 65535
} while (Test-PortInUse -Port $randomPort)

# Update the registry to change the RDP port
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
Set-ItemProperty -Path $regPath -Name "PortNumber" -Value $randomPort

# Restart the RDP service to apply the change
Restart-Service -Name TermService -Force

# Output the new RDP port
Write-Host "RDP port changed to: $randomPort"
