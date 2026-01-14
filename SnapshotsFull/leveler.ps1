param(
    [Parameter(Mandatory=$true)]
    [string]$RootFolder
)

Write-Host "Started process: $RootFolder" -ForegroundColor Green

$manufactureFolders = Get-ChildItem -Path $RootFolder -Directory

foreach ($manufacture in $manufactureFolders) {
    Write-Host "Processing brand: $($manufacture.Name)" -ForegroundColor Yellow
    
    $carModelFolders = Get-ChildItem -Path $manufacture.FullName -Directory
    
    foreach ($carModel in $carModelFolders) {
        $snapFullPath = Join-Path -Path $carModel.FullName -ChildPath "snap_full.png"
        
        if (Test-Path -Path $snapFullPath) {
            $newFileName = "$($carModel.Name).png"
            $destinationPath = Join-Path -Path $manufacture.FullName -ChildPath $newFileName
            
            try {
                Copy-Item -Path $snapFullPath -Destination $destinationPath -Force
                Write-Host "  Copied: $newFileName" -ForegroundColor Green
                
                Remove-Item -Path $carModel.FullName -Recurse -Force
                Write-Host "  Deleted: $($carModel.Name)" -ForegroundColor Gray
            }
            catch {
                Write-Host "  Error $($carModel.Name): $_" -ForegroundColor Red
            }
        }
        else {
            Write-Host "  File snap_full.png not found: $($carModel.Name)" -ForegroundColor Yellow
        }
    }
}

Write-Host "`nCompleted!" -ForegroundColor Green