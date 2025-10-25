if (${ProductKey})
{
   & 'C:\Windows\System32\cscript.exe' C:\Windows\System32\slmgr.vbs /ipk ${ProductKey} | Out-Null
   & 'C:\Windows\System32\cscript.exe' C:\Windows\System32\slmgr.vbs /ato
   & 'C:\Windows\System32\cscript.exe' C:\Windows\System32\slmgr.vbs /dlv
}
