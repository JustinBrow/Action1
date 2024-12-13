$path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
$pathExists = Test-Path -Path $path
if (-not $pathExists)
{
   try
   {
      New-Item -Path $path -Force
   }
   catch
   {
      $Host.UI.WriteErrorLine("Failed to create Windows Update policy registry path: $($_.Exception.Message)")
      exit 1
   };
};

try
{
   New-ItemProperty -Path $path -Name 'AUPowerManagement' -PropertyType 'DWord' -Value 1 -Force
   New-ItemProperty -Path $path -Name 'SetUpdateNotificationLevel' -PropertyType 'DWord' -Value 1 -Force
   New-ItemProperty -Path $path -Name 'UpdateNotificationLevel' -PropertyType 'DWord' -Value 1 -Force
   New-ItemProperty -Path $path -Name 'SetDisablePauseUXAccess' -PropertyType 'DWord' -Value 1 -Force
   New-ItemProperty -Path $path -Name 'SetDisableUXWUAccess' -PropertyType 'DWord' -Value 1 -Force
   New-ItemProperty -Path $path -Name 'SetActiveHours' -PropertyType 'DWord' -Value 1 -Force
   New-ItemProperty -Path $path -Name 'ActiveHoursStart' -PropertyType 'DWord' -Value 7 -Force
   New-ItemProperty -Path $path -Name 'ActiveHoursEnd' -PropertyType 'DWord' -Value 18 -Force
}
catch
{
   $Host.UI.WriteErrorLine("Failed to set Windows Update policy registry: $($_.Exception.Message)")
   exit 2
}

$path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
$pathExists = Test-Path -Path $path
if (-not $pathExists)
{
   try
   {
      New-Item -Path $path -Force
   }
   catch
   {
      $Host.UI.WriteErrorLine("Failed to create Windows Update policy registry path: $($_.Exception.Message)")
      exit 3
   }
}

try
{
   New-ItemProperty -Path $path -Name 'AUOptions' -PropertyType 'DWord' -Value 4 -Force
   New-ItemProperty -Path $path -Name 'ScheduledInstallDay' -PropertyType 'DWord' -Value 6 -Force
   New-ItemProperty -Path $path -Name 'ScheduledInstallTime' -PropertyType 'DWord' -Value 19 -Force
   New-ItemProperty -Path $path -Name 'ScheduledInstallEveryWeek' -PropertyType 'DWord' -Value 1 -Force
   New-ItemProperty -Path $path -Name 'AllowMUUpdateService' -PropertyType 'DWord' -Value 1 -Force
   New-ItemProperty -Path $path -Name 'AutoInstallMinorUpdates' -PropertyType 'DWord' -Value 1 -Force
   New-ItemProperty -Path $path -Name 'IncludeRecommendedUpdates' -PropertyType 'DWord' -Value 0 -Force
   New-ItemProperty -Path $path -Name 'AlwaysAutoRebootAtScheduledTime' -PropertyType 'DWord' -Value 1 -Force
   New-ItemProperty -Path $path -Name 'AlwaysAutoRebootAtScheduledTimeMinutes' -PropertyType 'DWord' -Value 15 -Force
   New-ItemProperty -Path $path -Name 'NoAUAsDefaultShutdownOption' -PropertyType 'DWord' -Value 0 -Force
}
catch
{
   $Host.UI.WriteErrorLine("Failed to set Windows Update policy registry: $($_.Exception.Message)")
   exit 4
}
