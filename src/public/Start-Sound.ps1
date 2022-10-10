function Start-Sound {
    [CmdletBinding()]
    param(
        [Parameter()]
        [Alias("PSPath")]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$Path,

        [Parameter(Position = 0 )]
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            foreach($file in Get-ChildItem $PSScriptRoot/audio -File -Filter ${WordToComplete}*) {
                [System.Management.Automation.CompletionResult]::new($file.BaseName)
            }
        })]
        [string[]]$Name = (Split-Path $Path -Leaf),

        [switch]$NoCache
    )
    process {
        if ($Path -and $Name.Count -eq 1 -and -not $NoCache) {
            $CachedAudio[$Name] = [PSAudio.CachedSoundSampleProvider]::new($Path)
        }

        foreach ($Sound in $Name) {
            if (!$CachedAudio.ContainsKey($Sound) -and !$Path) {
                $Path = Join-Path $AudioRoot "$Sound.*" | Convert-Path
                if (Test-Path $Path) {
                    if (!$NoCache) {
                        $CachedAudio[$Sound] = [PSAudio.CachedSoundSampleProvider]::new($Path)
                    }
                } else {
                    throw "No sound '$Sound' found (looked in $Path)"
                }
            }

            [PSAudio.AudioPlaybackEngine]::Instance.PlaySound($NoCache ? $Path : $CachedAudio[$Sound])
        }
    }
}