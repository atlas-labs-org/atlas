<div align="center">

# JamarcusAdmin
### [MIT License](LICENSE)
### Roblox Game Administration System
### Developed and maintained by MochaTheDev (@mocha______, @Mocha_) and WakeTheTyrant (@wakethetyrant)

***

## Installation Methods

### Option one: Roblox Asset (recommended)
You can install it on the Roblox asset store [here](https://create.roblox.com/store/asset/17166069350/JamarcusAdmin-v132).

### Option two: GitHub
Similarly to the Roblox asset store, as of now all files will be in .rbxm format. Download that [here](https://github.com/NickanatorYT/jamarcus_admin/releases/latest)

***

## Setup

Once installed, follow the below steps to set up your system.
1. **Placement**
- Place "jamarcus_RepStg" folder into ReplicatedStorage.
- Place "jamarcus_SrvScrptSrv" folder into ServerScriptService.
- Place the "jamarcus_StarterGui" folder into StarterGui

2. **Additional**
- Delete the "AdminPart"
- Delete this READ_ME script
- Go to ReplicatedStorage -> jamarcus_RepStg -> Settings (ModuleScript) and edit settings for your preferences.

3. **Notes**
- DO NOT EDIT jamarcus_SrvScrptSrv -> jamarcus_CORE!! It contains the system's core code.
editing this can and will cause the entire system to fail, resulting in a full re-load and
reconfiguration. Edit at your own risk.

## Settings Explaination
- **prefix**
  - Prefix is obvious. It will set your command prefix. Default is ":". (Eg. :kill => ;kill or >kill)
- **datastore**
  - Set this to something random. This is your datastore for system logging, bans, etc.
- **Server_Message_Header**
  - Change this if you want it to say something other than "Server Message: Testing 123"
- **debug**
  - Recommended to keep this to false. Allows bypass to all admin/override verification checks.
- **fun_commands**
  - Commands like :sit, :jump, etc.
- **plugins_enabled**
  - If you have any custom plugins *(See plugins section)*, you will need this set to `true`.
- **auto_update**
  - Recommended to keep this on! This will automatically source the latest version. If your version is too outdated, it may ask for you to get the new asset.
- **component_verification**
  - Having this on will automatically allow the system to delete broken components and source the correct ones.
- **banned_users**
  - Hard-banned users. Cannot be unbanned unless removed from this script.
- **whitelist**
  - Automatically added to the whitelist when whitelist mode is enabled (:whitelist to enable, :whitelist username to add new users)
- **Override**
  - Users in this section may run commands like :reboot, which will reload the system. Also immune to commands like :kill or :unadmin.
- **Admins**
  - Hard-coded admins. Any other user (using :admin user) is a temporary admin. *(as of v1.3.2)*

***That's it for the settings!***

***

## Plugins

- **How to add a plugin**
To add your own plugins, refer to the `example_plugin` ModuleScript file, which will explain the setup process.

- **Requirements**
Plugins must have a maximum of two arguments as of `v1.3.2`. They may have a minimum of 0 arguments.

***

## Other

- **Support**
If you have any questions at all, or suggestions / feature requests, feel free to join the support server [here](https://discord.gg/yhTNzJre76) on Discord.
