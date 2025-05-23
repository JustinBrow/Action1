$ErrorActionPreference = 'Stop';
# Create the Umbrella folder then write the certificate file to disk.
if (-not (Test-Path -LiteralPath 'C:\ProgramData\Cisco\Cisco Secure Client\Umbrella\'))
{
   try
   {
      New-Item -Type Directory -Path 'C:\ProgramData\Cisco\Cisco Secure Client\Umbrella\' -Force | Out-Null;
   }
   catch
   {
      $Host.UI.WriteErrorLine($_.Exception.Message);
      exit 1;
   };
};
try
{
   $Certificate = @"
-----BEGIN CERTIFICATE-----
MIIDJjCCAg6gAwIBAgIIUW6l3kYeVMEwDQYJKoZIhvcNAQELBQAwMTEOMAwGA1UE
ChMFQ2lzY28xHzAdBgNVBAMTFkNpc2NvIFVtYnJlbGxhIFJvb3QgQ0EwHhcNMTYw
NjI4MTUzNzUzWhcNMzYwNjI4MTUzNzUzWjAxMQ4wDAYDVQQKEwVDaXNjbzEfMB0G
A1UEAxMWQ2lzY28gVW1icmVsbGEgUm9vdCBDQTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAO7ZjfBSCaz5EMYSiWYoXjHPP/w7xFT4bXa82lOZ9CJJXDQw
bZpBdmuqX9UWo769LIAaSUvkYEeZqcTsjrx/7juPKoOErhJY0cPK12LU9PbHXqEd
XESIqBjdOC5oiIFHhTAKuuKRlL7rhPYkYhZtgdll4h0FLIG+xNsMVfzJb7z69X8Y
vF9r1drLkd7oR2xHuRkXgzeblFVpF+DRF7WXNhLy0By38ZxtClxYUSitdz53W0ic
maelG7EyCVNVxARxn5waaphRvki1hkuqqrm3JdlV165zAOdSz3JKzRISQinCTQuT
+RK/w0qLsDTyOVO/mEIVWLXu/Z1NtuXgj/jhegcCAwEAAaNCMEAwDgYDVR0PAQH/
BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFENzAN4kukAaQFQsfXzV
AEiJDHCkMA0GCSqGSIb3DQEBCwUAA4IBAQBIEoceSPZLmo5sLmgDfQA+Fq5BKztL
qg8aAvZdrbdMEKEBr1RDB0OAhuPcaaVxZi6Hjyql1N999Zmp8qIw/lLTt3VSTmEa
29uPgjdMGLl9KyfZjARiA/PPvPdHTwg7TMJOet+w7P5nWabLNW55+Wc/JzCSFE30
+0Kdz/jojxlA/8t0xYLCdS2UK7zC4kuAbojHLJDbIQO3HeEWwVmg4FO89AHVvC4R
Y+V0t7SaEradv6tPG9DHX7PLwjQ/Xs95NGDIJTeFwCRqYUlBu9iZjIvKba0e0tST
Vuyw2+P2HuWazjBPawGrbfyw+uO3KO4WnNGjMutJJ920o8B5M8gW1+Ye
-----END CERTIFICATE-----
"@;
   $Encoding = [System.Text.UTF8Encoding]::new($false);
   [System.IO.File]::WriteAllLines('C:\ProgramData\Cisco\Cisco Secure Client\Umbrella\Cisco_Umbrella_Root_CA.cer', $Certificate, $Encoding);
}
catch
{
   $Host.UI.WriteErrorLine($_.Exception.Message);
   exit 2;
};
if (Test-Path -LiteralPath 'C:\ProgramData\Cisco\Cisco Secure Client\Umbrella\Cisco_Umbrella_Root_CA.cer')
{
   try
   {
      Import-Certificate -FilePath 'C:\ProgramData\Cisco\Cisco Secure Client\Umbrella\Cisco_Umbrella_Root_CA.cer' -CertStoreLocation 'Cert:\LocalMachine\Root\' | Out-Null;
   }
   catch
   {
      $Host.UI.WriteErrorLine($_.Exception.Message);
      exit 3;
   };
};
exit 0;
