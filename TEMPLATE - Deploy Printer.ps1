<# At the time of writing using "using namespace" was not supported by Action1
using namespace System;
using namespace System.IO;
using namespace System.Security.AccessControl;
using namespace System.Security.Principal;
#>

#Requires -Version 5.1;

$ErrorActionPreference = 'Stop';
$ProgressPreference = 'SilentlyContinue';

$SC = @{ErrorAction = 'SilentlyContinue'};

$Printer = @{
   PrinterAdministrator = 'Help Desk' # Local user to grant "Manage this printer" permission to. Might work with domain users, but didn't test.
   PrinterName = 'Printer';
   PortName = '192.168.0.69:9100';
   SNMPIndex = 1;
   SNMPCommunity = 'public';
   DriverName = 'TOSHIBA Universal Printer 2';
   DriverURL = 'https://cdn.example.com/drivers/eb4-ebn-Uni-64bit.zip';
   DriverHash = 'DB538A0E34117EE436C668DB23A87D4FD34A9AADE7816CFB5A429C7EFF732A60';
   Datatype = 'RAW';
   PrintProcessor = 'winprint';
};

enum AccessType {
   TakeOwnership = 524288;
   ReadPermissions = 131072;
   ChangePermissions = 262144;
   ManagePrinter = 983052;
   ManageDocuments = 983088;
   Print = 131080;
};

$PrinterPortArgs = @{
   Name = $Printer.PortName;
};

if (-not (Get-PrinterPort @PrinterPortArgs @SC))
{
   $PrinterPortArgs.Add('PrinterHostAddress', $Printer.PortName.Split(':')[0]);
   $PrinterPortArgs.Add('PortNumber', $Printer.PortName.Split(':')[1]);
   if (-not ([String]::IsNullOrEmpty($Printer.SNMPIndex)))
   {
      $PrinterPortArgs.Add('SNMPIndex', $Printer.SNMPIndex);
   };
   if (-not ([String]::IsNullOrEmpty($Printer.SNMPCommunity)))
   {
      $PrinterPortArgs.Add('SNMPCommunity', $Printer.SNMPCommunity);
   };

   try
   {
      Add-PrinterPort @PrinterPortArgs;
   }
   catch
   {
      $Host.UI.WriteErrorLine("Failed to add printer port: $($_.Exception.Message)");
      exit 1;
   };
};

if (-not (Get-PrinterDriver -Name $Printer.DriverName @SC))
{
   $isOldPnPUtil = & PnPUtil.exe /? | Select-String 'This usage screen' -Quiet;
   $TempFile = [System.IO.Path]::GetTempFileName();
   if (Test-Path -Path $TempFile)
   {
      Remove-Item -Path $TempFile;
   };
   $TempFile = $TempFile -replace 'tmp$', 'zip';
   $TempFolder = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetFileNameWithoutExtension($TempFile));

   try
   {
      Resolve-DnsName -Name 'cdn.example.com' -DnsOnly -ErrorAction Stop;
   }
   catch
   {
      $Host.UI.WriteErrorLine("It's not DNS`r`nThere's no way it's DNS`r`nIt was DNS");
      exit 2;
   };

   try
   {
      Invoke-WebRequest -UseBasicParsing -Uri $Printer.DriverURL -OutFile $TempFile;
   }
   catch
   {
      $Host.UI.WriteErrorLine("Failed to download driver: $($_.Exception.Message)");
      exit 3;
   };

   if (-not ((Get-FileHash $TempFile -Algorithm SHA256).Hash -eq $Printer.DriverHash))
   {
      $Host.UI.WriteErrorLine("Failed to validate driver: $($_.Exception.Message)");
      exit 4;
   };

   try
   {
      Expand-Archive -Path $TempFile -DestinationPath $TempFolder;
   }
   catch
   {
      $Host.UI.WriteErrorLine("Failed to extract driver: $($_.Exception.Message)");
      exit 5;
   };

   try
   {
      $DriverPath = @((Resolve-Path -Path "$TempFolder\*.inf").Path);
      if ($DriverPath.Count -gt 1)
      {
         throw;
      };
      if ($isOldPnPUtil)
      {
         Start-Process -FilePath PnPUtil.exe -ArgumentList "-i -a $DriverPath" -Wait;
      }
      else
      {
         Start-Process -FilePath PnPUtil.exe -ArgumentList "/add-driver $DriverPath" -Wait;
      };
      Add-PrinterDriver -Name $Printer.DriverName;
   }
   catch
   {
      $Host.UI.WriteErrorLine("Failed to add driver: $($_.Exception.Message)");
      exit 6;
   }
   finally
   {
      if (Test-Path -Path $TempFile)
      {
         Remove-Item -Path $TempFile;
      };
      if (Test-Path -Path $TempFolder)
      {
         Remove-Item -Path $TempFolder -Recurse;
      };
   };
};

if (-not (Get-Printer -Name $Printer.PrinterName @SC))
{
   try
   {
      Add-Printer -Name $Printer.PrinterName -DriverName $Printer.DriverName -PortName $Printer.PortName -Datatype $Printer.Datatype -PrintProcessor $Printer.PrintProcessor;
   }
   catch
   {
      $Host.UI.WriteErrorLine("Failed to add printer: $($_.Exception.Message)");
      exit 7;
   };
};

$objPrinter = Get-Printer -Name $Printer.PrinterName -Full @SC;
if (Get-LocalUser -Name $Printer.PrinterAdministrator @SC)
{
   $SID = ([System.Security.Principal.NTAccount]::new($Printer.PrinterAdministrator).Translate([System.Security.Principal.SecurityIdentifier])).Value;
   $modifiedSDDL = $false;
   $SecurityDescriptor = [System.Security.AccessControl.CommonSecurityDescriptor]::new($true, $false, $objPrinter.PermissionSDDL);
   if (-not ($SecurityDescriptor.DiscretionaryAcl.Where({$_.SecurityIdentifier -eq $SID -and $_.AccessMask -eq [AccessType]::ManagePrinter})))
   {
      $SecurityDescriptor.DiscretionaryAcl.AddAccess(
         [System.Security.AccessControl.AccessControlType]::Allow,
         [System.Security.Principal.SecurityIdentifier]$SID,
         [AccessType]::ManagePrinter,
         [System.Security.AccessControl.InheritanceFlags]::None,
         [System.Security.AccessControl.PropagationFlags]::None
      );
      $modifiedSDDL = $true;
   };
   if (-not ($SecurityDescriptor.DiscretionaryAcl.Where({$_.SecurityIdentifier -eq $SID -and $_.AccessMask -eq [AccessType]::ManageDocuments})))
   {
      $SecurityDescriptor.DiscretionaryAcl.AddAccess(
         [System.Security.AccessControl.AccessControlType]::Allow,
         [System.Security.Principal.SecurityIdentifier]$SID,
         [AccessType]::ManageDocuments,
         [System.Security.AccessControl.InheritanceFlags]::ObjectInherit,
         [System.Security.AccessControl.PropagationFlags]::InheritOnly
      );
      $modifiedSDDL = $true;
   };
   if ($modifiedSDDL = $true)
   {
      try
      {
         Set-Printer -Name $Printer.PrinterName -PermissionSDDL $SecurityDescriptor.GetSddlForm([System.Security.AccessControl.AccessControlSections]::All);
      }
      catch
      {
         $Host.UI.WriteErrorLine("Failed to set printer permissions: $($_.Exception.Message)");
         exit 8;
      };
   };
};

try
{
   $PrintConfiguration = Get-PrintConfiguration -PrinterName $Printer.PrinterName @SC;
   if ($PrintConfiguration.Color -eq $true)
   {
      Set-PrintConfiguration -PrinterName $Printer.PrinterName -Color $false;
   };

   if ($PrintConfiguration.DuplexingMode -ne 'OneSided')
   {
      Set-PrintConfiguration -PrinterName $Printer.PrinterName -DuplexingMode 'OneSided';
   };

   if (Get-PrinterPort -Name $Printer.PortName.Split(':')[0] @SC)
   {
      if ($objPrinter.PortName -eq $Printer.PortName.Split(':')[0])
      {
         Set-Printer -Name $Printer.PrinterName -PortName $Printer.PortName;
      };
      Remove-PrinterPort -Name $Printer.PortName.Split(':')[0];
   };
}
catch
{
   $Host.UI.WriteErrorLine("Failed final steps: $($_.Exception.Message)");
   exit 9;
};
