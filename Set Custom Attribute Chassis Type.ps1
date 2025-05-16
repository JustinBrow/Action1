#Requires -Version 5.1;
$ErrorActionPreference = 'Stop';
# https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-systemenclosure;
# https://www.dmtf.org/sites/default/files/standards/documents/DSP0134_3.8.0.pdf;
# https://learn.microsoft.com/en-us/windows-hardware/drivers/bringup/sample-powershell-script-to-query-smbios-locally;
Enum ChassisTypes
{
  Other                   =  1;
  Unknown                 =  2;
  Desktop                 =  3;
  Low_Profile_Desktop     =  4;
  Pizza_Box               =  5;
  Mini_Tower              =  6;
  Tower                   =  7;
  Portable                =  8;
  Laptop                  =  9;
  Notebook                = 10;
  Hand_Held               = 11;
  Docking_Station         = 12;
  All_in_One              = 13;
  Sub_Notebook            = 14;
  Space_Saving            = 15;
  Lunch_Box               = 16;
  Main_System_Chassis     = 17;
  Expansion_Chassis       = 18;
  SubChassis              = 19;
  Bus_Expansion_Chassis   = 20;
  Peripheral_Chassis      = 21;
  Storage_Chassis         = 22;
  Rack_Mount_Chassis      = 23;
  Sealed_Case_PC          = 24;
  Multi_system_Chassis    = 25;
  Compact_PCI             = 26;
  Advanced_TCA            = 27;
  Blade                   = 28;
  Blade_Enclosure         = 29;
  Tablet                  = 30;
  Convertible             = 31;
  Detachable              = 32;
  IoT_Gateway             = 33;
  Embedded_PC             = 34;
  Mini_PC                 = 35;
  Stick_PC                = 36
};
try
{
   $ComputerSystem = Get-CimInstance -ClassName Win32_ComputerSystem;
   if ($ComputerSystem.Model -eq 'Virtual Machine' -or $ComputerSystem.Model -eq 'VMware Virtual Platform' -or $ComputerSystem.Model -eq 'VMware7,1')
   {
      Action1-Set-CustomAttribute 'Chassis Type' 'Virtual_Machine';
      exit 0;
   };
   $SystemEnclosure = Get-CimInstance -ClassName Win32_SystemEnclosure;
   if ($SystemEnclosure)
   {
      $ChassisType = [ChassisTypes[]]$SystemEnclosure.ChassisTypes -join ', ';
      if ($ChassisType)
      {
         Action1-Set-CustomAttribute 'Chassis Type' $ChassisType;
         exit 0;
      };
   };
}
catch
{
   $Host.UI.WriteErrorLine($_.Exception.Message);
   exit 1;
};
