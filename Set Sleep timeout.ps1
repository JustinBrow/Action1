if (${WallPower} -is [int] -and ${WallPower} -ge 0 -and ${WallPower} -le 71582788)
{
   & C:\Windows\System32\powercfg.exe /change standby-timeout-ac ${WallPower};
};
if (${BatteryPower} -is [int] -and ${BatteryPower} -ge 0 -and ${BatteryPower} -le 71582788)
{
   & C:\Windows\System32\powercfg.exe /change standby-timeout-dc ${BatteryPower};
};
