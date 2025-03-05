# Check if dist folder exists and create it if not
if (-not (Test-Path -Path ".\dist" -PathType Container)) {
    New-Item -Path ".\dist" -ItemType Directory
    Write-Host "Created ./dist directory."
}

# Copy all .csv files from src to dist
Copy-Item -Path ".\src\*.csv" -Destination ".\dist\" -Force
Write-Host "Copied all .csv files to dist directory."

# Process all copied files: remove newlines after "\r\n" and convert to .txt
Get-ChildItem -Path ".\dist\*.csv" | ForEach-Object {
    $content = Get-Content -Path $_.FullName -Raw

    # Replace literal "\r\n" followed by an actual CRLF with just "\r\n"
    $newContent = $content -replace '\\r\\n\r\n', '\r\n'

    # Create the new file path with .txt extension
    $newFilePath = [System.IO.Path]::ChangeExtension($_.FullName, ".txt")

    # Save content to new .txt file
    Set-Content -Path $newFilePath -Value $newContent -NoNewline

    # Remove the original .csv file
    Remove-Item -Path $_.FullName

    Write-Host "Processed and converted: $($_.Name) -> $([System.IO.Path]::GetFileName($newFilePath))"
}

Write-Host "All .csv files in dist have been processed with newlines removed after '\r\n' and converted to .txt."
