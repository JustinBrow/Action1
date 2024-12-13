if (${Minutes} -is [int] -and ${Minutes} -ge 0 -and ${Minutes} -le 71582788)
{
   & C:\Windows\System32\powercfg.exe /change standby-timeout-ac ${Minutes}
}
