$BIOS = Get-CimInstance -ClassName Win32_BIOS

$Interfaces = netsh mbn show interfaces
$Interface = netsh mbn show readyinfo interface=*

if ($Interface | Select-String 'Subscriber Id') {$IMSI =($Interface | Select-String 'Subscriber Id').ToString().Replace(' ', '').Replace('SubscriberId:', '').Trim()} else {$IMSI = 'N/a'}

$result = [PSCustomObject]@{
   'SN' = $BIOS.SerialNumber
   'Interface Name' = ($Interfaces | Select-String 'Name' | Select-Object -First 1).ToString().Replace(' ', '').Replace('Name:', '').Trim()
   'Description' = ($Interfaces | Select-String 'Description').ToString().Replace(' ', '').Replace('Description:', '').Trim()
   'MAC Address' = ($Interfaces | Select-String 'Physical Address').ToString().Replace(' ', '').Replace('PhysicalAddress:', '').Trim()
   'IMEI' = ($Interfaces | Select-String 'Device Id').ToString().Replace(' ', '').Replace('DeviceId:', '').Trim()
   'Manufacturer' = ($Interfaces | Select-String 'Manufacturer').ToString().Replace(' ', '').Replace('Manufacturer:', '').Trim()
   'Model' = ($Interfaces | Select-String 'Model').ToString().Replace(' ', '').Replace('Model:', '').Trim()
   'Carrier' = ($Interfaces | Select-String 'Provider Name').ToString().Replace(' ', '').Replace('ProviderName:', '').Trim()
   'IMSI' = $IMSI
   'SIM ICCID' = ($Interface | Select-String 'SIM ICC Id').ToString().Replace(' ', '').Replace('SIMICCId:', '').Trim()
   'Mobile Number' = ($Interface | Select-String 'Telephone #1').ToString().Replace(' ', '').Replace('Telephone#1:', '').Trim()
   'A1_Key' = $BIOS.SerialNumber
}

Write-Output $result
