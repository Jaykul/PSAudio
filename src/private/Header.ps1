# on startup:
$script:CachedAudio = @{}

$script:AudioRoot = Join-Path $PSScriptRoot Audio

if ($Module = Get-Module NAudio) {
    $Module.OnRemove = { [AudioPlaybackEngine]::Instance.Dispose() }
}