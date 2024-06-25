$include = @("*.xml", "*.lua", "*.dds", "src\vehicles\specialization\*.lua", "src\vehicles\specialization\event\*.lua", "src\*.lua", "translations\*.xml")
$zipFilename = "FS22_FrontBackLiftControl.zip"

if(test-path "$env:ProgramFiles\WinRAR\WinRAR.exe")
{
    Set-Alias winrar "$env:ProgramFiles\WinRAR\WinRar.exe"
    Start-Process -wait -FilePath winrar -ArgumentList "a -afzip $zipFilename $include"
}
