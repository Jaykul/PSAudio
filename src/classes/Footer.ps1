# on startup:
$engine = [AudioPlaybackEngine]::new(44100, 2)
$CachedAudio = @{}

$AudioRoot = Join-Path $PSScriptRoot Audio

if ($Module = Get-Module NAudio) {
    $Module.OnRemove = { $engine.Dispose(); }.GetNewClosure()
}