try
{
   if (${Restart})
   {
      Rename-Computer -NewName ${New Name} -Restart
   }
   else
   {
      Rename-Computer -NewName ${New Name}
      exit 0
   }
}
catch
{
   $Host.UI.WriteErrorLine($_.Exception.Message)
   exit 2
}
