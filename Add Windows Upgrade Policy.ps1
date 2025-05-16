$GPOsupportedSKUs = @(48, 161);
$OS = Get-CimInstance -ClassName Win32_OperatingSystem;
if ($OS.OperatingSystemSKU -in $GPOsupportedSKUs)
{
   $path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate';
   $pathExists = Test-Path -Path $path;
   if (-not $pathExists)
   {
      try
      {
         New-Item -Path $path -Force | Out-Null;
      }
      catch
      {
         $Host.UI.WriteErrorLine("Failed to create Windows Update policy registry path: $($_.Exception.Message)");
         exit 2;
      };
   };

   try
   {
      New-ItemProperty -Path $path -Name 'AUPowerManagement' -PropertyType 'DWord' -Value 1 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'SetUpdateNotificationLevel' -PropertyType 'DWord' -Value 1 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'UpdateNotificationLevel' -PropertyType 'DWord' -Value 1 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'SetDisablePauseUXAccess' -PropertyType 'DWord' -Value 1 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'SetDisableUXWUAccess' -PropertyType 'DWord' -Value 0 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'SetActiveHours' -PropertyType 'DWord' -Value 1 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'ActiveHoursStart' -PropertyType 'DWord' -Value 7 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'ActiveHoursEnd' -PropertyType 'DWord' -Value 18 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'ProductVersion' -PropertyType 'String' -Value 'Windows 11' -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'TargetReleaseVersion' -PropertyType 'DWord' -Value 1 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'TargetReleaseVersionInfo' -PropertyType 'String' -Value '24H2' -Force | Out-Null;
   }
   catch
   {
      $Host.UI.WriteErrorLine("Failed to set Windows Update policy registry: $($_.Exception.Message)");
      exit 3;
   };

   $path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU';
   $pathExists = Test-Path -Path $path;
   if (-not $pathExists)
   {
      try
      {
         New-Item -Path $path -Force | Out-Null;
      }
      catch
      {
         $Host.UI.WriteErrorLine("Failed to create Windows Update policy registry path: $($_.Exception.Message)");
         exit 4;
      };
   };

   try
   {
      New-ItemProperty -Path $path -Name 'NoAutoUpdate' -PropertyType 'DWord' -Value 0 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'AUOptions' -PropertyType 'DWord' -Value 4 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'ScheduledInstallDay' -PropertyType 'DWord' -Value 0 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'ScheduledInstallTime' -PropertyType 'DWord' -Value 24 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'ScheduledInstallEveryWeek' -PropertyType 'DWord' -Value 1 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'AllowMUUpdateService' -PropertyType 'DWord' -Value 1 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'AutoInstallMinorUpdates' -PropertyType 'DWord' -Value 1 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'IncludeRecommendedUpdates' -PropertyType 'DWord' -Value 0 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'AlwaysAutoRebootAtScheduledTime' -PropertyType 'DWord' -Value 1 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'AlwaysAutoRebootAtScheduledTimeMinutes' -PropertyType 'DWord' -Value 15 -Force | Out-Null;
      New-ItemProperty -Path $path -Name 'NoAUAsDefaultShutdownOption' -PropertyType 'DWord' -Value 0 -Force | Out-Null;
   }
   catch
   {
      $Host.UI.WriteErrorLine("Failed to set Windows Update policy registry: $($_.Exception.Message)");
      exit 5;
   };
}
else
{
   $Host.UI.WriteErrorLine("Unsupported Windows edition: $($OS.OperatingSystemSKU)");
   exit 1;
};
