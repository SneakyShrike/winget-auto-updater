$packagesToSkip = @(
"Discord.Discord",
"Microsoft.VCRedist.2015+.x64")

$packageIDs = @()

$upgradeLines = winget upgrade | Out-String -Stream

for ($i = 4; $i -lt $upgradeLines.Length - 1; $i++) # start at line 4 for first package, skip last line (-1) which isn't a package
{
    $packageID
    $upgradeLineID = $upgradeLines[$i] -split "\s+"

    if ($upgradeLines[$i].Contains("Microsoft.VCRedist"))
    {
        $packageIDs += ,$upgradeLineID[5]
    }
    else 
    {
        $packageIDs += ,$upgradeLineID[1] 
    }
}

foreach ($packageID in $packageIDs) 
{
    if (-not $packagesToSkip.Contains($packageID)) # if packageID isn't in the exclude packages list, proceed to upgrade the package
    {
        Write-Host "Upgrading: $($packageID)"
    }
    else 
    {
        Write-Host "Skipping $($packageID) Upgrade"
    }
}


