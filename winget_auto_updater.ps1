$packagesToSkip = @(
"Discord.Discord",
"Microsoft.VCRedist.2015+.x64")

$packageIDs = @() # array of package ID's

$upgradeLines = winget upgrade | Out-String -Stream # each line of the output of the command 'winget upgrade' is indexed as an array

for ($i = 4; $i -lt $upgradeLines.Length - 1 ; $i++) # start at line 4 for first package, skip last line (-1) which isn't a package
{
    $upgradeLineSegments = $upgradeLines[$i] -split "\s+" # split each line into segments seperated by a space

    for ($f = 0; $f -lt $upgradeLineSegments.Length - 3; $f++) # for each line iterate through each segment seperated by a space, skip last 3 segments as they are always numbers and dots and 'winget'
    {
        if ($upgradeLineSegments[$f].Contains(".") -and $upgradeLineSegments[$f] -notmatch '\d+.\d') # if the segment contains a . and does not contain a . followed by a number
        {
            $packageIDs += $upgradeLineSegments[$f]
        }
    }
}

foreach ($packageID in $packageIDs) 
{
    if (-not $packagesToSkip.Contains($packageID)) # if packageID isn't in the exclude packages list, proceed to upgrade the package
    {
        Write-Host "Upgrading: $($packageID)"
        winget upgrade $packageID # upgrade the package
    }
    else 
    {
        Write-Host "Skipping $($packageID)"
    }
}