try
{
   Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideShutDown' -Name 'value' -Value 0
}
catch
{
   $Host.UI.WriteErrorLine("Could not set registry value: $($_.Exception.Message)")
   exit 1
}