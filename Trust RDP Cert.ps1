try {
   $hostname = 'https://rdsh.example.com/'
   $path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services';
   $WR = Invoke-WebRequest -UseBasicParsing -Uri $hostname -TimeoutSec 3 -ErrorAction Stop;
   $servicePoint = [Net.ServicePointManager]::FindServicePoint($hostname);
   $certHash = $servicePoint.Certificate.GetCertHashString([Security.Cryptography.HashAlgorithmName]::SHA1);
   if (-not(Test-Path $path)) {
      New-Item -Path $path -Force -ErrorAction Stop | Out-Null;
   };
   New-ItemProperty -Path $path -Name 'TrustedCertThumbprints' -Value $certHash -PropertyType String -Force -ErrorAction Stop | Out-Null;
} catch {
   $Host.UI.WriteErrorLine($_.Exception.Message);
   exit 1;
};
