$GPOsupportedSKUs = @(48, 161);
$OS = Get-CimInstance -ClassName Win32_OperatingSystem;
if ($OS.OperatingSystemSKU -in $GPOsupportedSKUs)
{
   try
   {
      Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideShutDown' -Name 'value' -Value 0;
      & 'C:\Windows\System32\powercfg.exe' /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3;
      & 'C:\Windows\System32\powercfg.exe' /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3;
   }
   catch
   {
      $Host.UI.WriteErrorLine("Could not set registry value: $($_.Exception.Message)");
      exit 2;
   };
}
else
{
   $Host.UI.WriteErrorLine("Unsupported Windows edition: $($OS.OperatingSystemSKU)");
   exit 1;
};
