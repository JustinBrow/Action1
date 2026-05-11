try {
   Get-ChildItem -Path 'Registry::HKEY_USERS\' | where PSChildName -ne '.DEFAULT' | ForEach {
      if (Test-Path -Path ([IO.Path]::Combine($_.PSPath, 'Software\Microsoft\Terminal Server Client'))) {
         Get-Item ([IO.Path]::Combine($_.PSPath, 'Software\Microsoft\Terminal Server Client')) | New-ItemProperty -Name 'RdpLaunchConsentAccepted' -Type DWord -Value 1 -Force | Out-Null;
      };
   };
} catch {
   $Host.UI.WriteErrorLine($_.Exception.Message);
};
.{
   try {
      $hostname = 'https://rdsh.example.com/'
      $path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services';
      $WR = Invoke-WebRequest -UseBasicParsing -Uri $hostname -TimeoutSec 3 -ErrorAction Stop;
      $servicePoint = [Net.ServicePointManager]::FindServicePoint($hostname);
      $certHash = $servicePoint.Certificate.GetCertHashString([Security.Cryptography.HashAlgorithmName]::SHA1);
      if (-not (Test-Path $path)) {
         New-Item -Path $path -Force -ErrorAction Stop | Out-Null;
      };
      if (Get-ItemProperty -Path $path -Name 'TrustedCertThumbprints' -ErrorAction SilentlyContinue) {
         if ($Host.Version.Major -le 4) {
            throw [NotSupportedException]::new($Host.Version);
         };
         $TrustedCertThumbprints = Get-ItemPropertyValue -Path $path -Name 'TrustedCertThumbprints';
         if ($TrustedCertThumbprints.Split(',').Contains($certHash)) {
            return;
         };
         if ($TrustedCertThumbprints.Split(',').Count -eq 2) {
            $TrustedCertThumbprints = $TrustedCertThumbprints.Split(',')[0];
         };
         $TrustedCertThumbprints = $certHash, $TrustedCertThumbprints -join ',';
         Set-ItemProperty -Path $path -Name 'TrustedCertThumbprints' -Value $TrustedCertThumbprints -Force -ErrorAction Stop | Out-Null;
      } else {
         New-ItemProperty -Path $path -Name 'TrustedCertThumbprints' -Value $certHash -PropertyType String -Force -ErrorAction Stop | Out-Null;
      };
   } catch {
      $Host.UI.WriteErrorLine($_.Exception.Message);
      exit 1;
   };
};
