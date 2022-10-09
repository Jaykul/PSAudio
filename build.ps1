#requires -Module ModuleBuilder
Push-Location $PSScriptRoot -StackName NAudioModuleBuild

if (!(Test-Path lib)) {
    mkdir lib
    Push-Location lib
    nuget install NAudio
    Pop-Location
}
Build-Module -SourcePath $PSScriptRoot\build.psd1 -Target CleanBuild -Passthru

Pop-Location -StackName NAudioModuleBuild