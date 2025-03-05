# Check if src folder exists and create it if not
if (-not (Test-Path -Path ".\src" -PathType Container)) {
    New-Item -Path ".\src" -ItemType Directory
}

# Process all .txt files in ./raw, add newlines after "\r\n", and save as .csv in ./src
Get-ChildItem -Path ".\raw\*.txt" | ForEach-Object {
    $content = Get-Content -Path $_.FullName -Raw

    # Replace literal "\r\n" with "\r\n" followed by an actual CRLF
    $newContent = $content -replace '\\r\\n', "\r\n`r`n"

    # Create the new file path with .csv extension in src directory
    $newFilePath = ".\src\" + [System.IO.Path]::GetFileNameWithoutExtension($_.Name) + ".csv"

    # Save content to new .csv file
    Set-Content -Path $newFilePath -Value $newContent -NoNewline

    Write-Host "Processed: $($_.Name) -> $([System.IO.Path]::GetFileName($newFilePath))"
}

Write-Host "All .txt files from raw have been processed with newlines added after '\r\n' and saved as .csv in src."
