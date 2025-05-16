try
{
   Get-LocalUser -Name ${Username} -ErrorAction Stop;
}
catch
{
   $Host.UI.WriteErrorLine($_.Exception.Message);
   exit 1;
};

if ([string]::IsNullOrEmpty(${Password}))
{
   $Host.UI.WriteErrorLine('Password is null or empty');
   exit 2;
};

try
{
   Set-LocalUser -Name ${Username} -Password (ConvertTo-SecureString -String ${Password} -AsPlainText -Force) -ErrorAction Stop;
}
catch
{
   $Host.UI.WriteErrorLine($_.Exception.Message);
   exit 3;
};
