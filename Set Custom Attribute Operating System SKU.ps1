#Requires -Version 5.1;
$ErrorActionPreference = 'Stop';
# https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-operatingsystem;
# https://learn.microsoft.com/en-us/dotnet/api/microsoft.powershell.commands.operatingsystemsku;
# https://github.com/MicrosoftDocs/memdocs/blob/main/memdocs/intune/fundamentals/filters-device-properties.md;
Enum OperatingSystemSKU
{
  Undefined                        =   0;
  Ultimate                         =   1;
  HomeBasic                        =   2;
  HomePremium                      =   3;
  Enterprise                       =   4;
  HomeBasicNEdition                =   5;
  Business                         =   6;
  StandardServer                   =   7;
  DatacenterServer                 =   8;
  SmallBusinessServer              =   9;
  EnterpriseServer                 =  10;
  Starter                          =  11;
  DatacenterServerCore             =  12;
  StandardServerCore               =  13;
  EnterpriseServerCore             =  14;
  EnterpriseServerIA64Edition      =  15;
  BusinessNEdition                 =  16;
  WebServer                        =  17;
  ClusterServerEdition             =  18;
  HomeServer                       =  19;
  StorageExpressServer             =  20;
  StorageStandardServer            =  21;
  StorageWorkgroupServer           =  22;
  StorageEnterpriseServer          =  23;
  ServerForSmallBusiness           =  24;
  SmallBusinessServerPremium       =  25;
  TBD                              =  26;
  EnterpriseN                      =  27;
  UltimateN                        =  28;
  WebServerCore                    =  29;
  ServerFoundation                 =  33;
  WindowsHomeServer                =  34;
  StandardServerV                  =  36;
  DatacenterServerV                =  37;
  EnterpriseServerV                =  38;
  DatacenterServerCoreV            =  39;
  StandardServerCoreV              =  40;
  EnterpriseServerCoreV            =  41;
  HyperV                           =  42;
  StorageExpressServerCore         =  43;
  StorageStandardServerCore        =  44;
  StorageWorkgroupServerCore       =  45;
  StorageEnterpriseServerCore      =  46;
  Professional                     =  48;
  BusinessN                        =  49;
  SBSolutionServer                 =  50;
  SmallBusinessServerPremiumCore   =  63;
  ClusterServerV                   =  64;
  EnterpriseEval                   =  72;
  EnterpriseNEval                  =  84;
  WindowsThinPC                    =  87;
  WindowsEmbeddedIndustry          =  89;
  CoreARM                          =  97;
  CoreN                            =  98;
  CoreCountrySpecific              =  99;
  CoreSingleLanguage               = 100;
  Core                             = 101;
  ProfessionalWMC                  = 103;
  MobileCore                       = 104;
  SKU_111                          = 111;
  WindowsEmbeddedHandheld          = 118;
  PPIPro                           = 119;
  Education                        = 121;
  EducationN                       = 122;
  IoTUAP                           = 123;
  EnterpriseS                      = 125;
  EnterpriseSN                     = 126;
  EnterpriseSEval                  = 129;
  IoTUAPCommercial                 = 131;
  Holographic                      = 136;
  ProfessionalSingleLanguage       = 138;
  DatacenterNanoServer             = 143;
  StandardNanoServer               = 144;
  DatacenterWSServerCore           = 147;
  StandardWSServerCore             = 148;
  ProfessionalWorkstation          = 161;
  ProfessionalN                    = 162;
  ProfessionalEducation            = 164;
  ProfessionalEducationN           = 165;
  EnterpriseG                      = 171;
  EnterpriseGN                     = 172;
  EnterpriseForVirtualDesktops     = 175;
  IoTEnterprise                    = 188;
  CloudEditionN                    = 202;
  CloudEdition                     = 203;
  DatacenterServerAzureEdition     = 407
};
try
{
   $OS = Get-CimInstance -ClassName Win32_OperatingSystem;
   if ($OS)
   {
      $OperatingSystemSKU = [OperatingSystemSKU]$OS.OperatingSystemSKU;
      if ($OperatingSystemSKU)
      {
         Action1-Set-CustomAttribute 'Operating System SKU' "$OperatingSystemSKU";
         exit 0;
      }
   }
}
catch
{
   $Host.UI.WriteErrorLine($_.Exception.Message);
   exit 1;
};
