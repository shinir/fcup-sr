# Define the range of ports you want to use
$minPort = 1025
$maxPort = 65535

# Function to check if a port is available
function Test-PortAvailability {
    param(
        [int]$Port
    )
    $result = Test-NetConnection -ComputerName localhost -Port $Port
    return $result.TcpTestSucceeded
}

# Generate a random port within the specified range
do {
    $randomPort = Get-Random -Minimum $minPort -Maximum $maxPort
} while (!(Test-PortAvailability -Port $randomPort))

# Set the new RDP port
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'PortNumber' -Value $randomPort

# Restart the Remote Desktop Services to apply the changes
Restart-Service -Name TermService -Force

# Display the new RDP port
Write-Host "RDP port changed to $randomPort"
