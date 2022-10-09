function Start-Sound {
    [CmdletBinding()]
    param(
        [Parameter()]
        [Alias("PSPath")]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$Path,

        [Parameter(Mandatory, Position = 0 )]
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
        [string[]]$Name = (Split-Path $Path -Leaf)
    )
    process {
        if ($Path) {
            if ($Name.Count -ne 1) {
                throw "When you specify a Path to a sound file, you can only specify one Name"
            }
            $CachedAudio[$Name] = [CachedSound]::new($Path)
        }

        foreach ($Sound in $Name) {
            if (!$CachedAudio.ContainsKey($Sound)) {
                $Path = Join-Path $AudioRoot "$Sound.*"
                if (Test-Path $Path) {
                    $CachedAudio[$Sound] = [CachedSound]::new($Path)
                } else {
                    throw "No sound with name '$Sound' found"
                }
            }

            $engine.PlaySound($CachedAudio[$Sound])
        }
    }
}