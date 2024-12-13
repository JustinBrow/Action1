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
   exit 1
}
