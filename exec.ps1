param(
    [string] $StorageAccountName,
    [string] $StorageAccountKey,
    [string] $container,
    [string] $blobName
)

$BlobContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
$scriptFile = Join-Path $PSScriptRoot ([Guid]::NewGuid().ToString() + ".ps1")
$outputFile = "$scriptFile.output"

$ProgressPreference = "SilentlyContinue"

Get-AzureStorageBlobContent -Context $blobContext -Container $container -Blob $blobName -Destination $scriptFile -Force | Out-Null

try {
    . $scriptFile
    if (Test-Path -Path $outputFile) {
        Set-AzureStorageBlobContent -File $outputFile -Context $blobContext -Container $container -Blob "$blobName.output" -Force | Out-Null
    }
} finally {
    Remove-Item $scriptFile -Force -ErrorAction SilentlyContinue
    Remove-Item $outputFile -Force -ErrorAction SilentlyContinue
}
