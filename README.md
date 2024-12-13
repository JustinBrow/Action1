## Action1
#### Add/Remove Shutdown to/from Start Menu
Adds/Removes the shutdown button to/from the start menu so users don't shut down their PC on the day we schedule Windows Updates for.
#### Add Windows Update Policy
For adding our Windows Update policy to non-domain joined machines.
#### Rename PC
For renaming PCs. In the script library define a String parameter `New Name` and int parameter `Restart` with a default value of `0`. When running this script pass a non-zero value to restart the target PC. A restart is required to apply the new name.
#### Set Custom Attribute Chassis Type
Under `Advanced > Endpoint Custom Attributes` rename one of your custom attributes to `Chassis Type`. Then you can use this script to populate the value. We use this to create separate endpoint groups for laptops and desktops.
#### Set Sleep timeout
For setting the computer sleep timeout, in minutes while, connected to power. Intended for keeping the computer awake on the day we schedule updates for.
