<div align="center">
  <img src="https://i.ibb.co/0jcfxbz/Atlas-Logo.png" alt="Atlas Admin Logo" width="300"/>

---

# Atlas Admin
### [MIT License](LICENSE)
### Roblox Game Administration System
### Developed and maintained by [MochaTheDev](https://github.com/MochaTheDev) and [WakeTheTyrant](https://github.com/WakeTheTyrant)

---

### [Wiki](https://github.com/MochaTheDev/atlas/wiki)

---
</div>

> [!NOTE] 
> 
> Please be aware that this is an early-version system.
> This can mean that there will be bugs, frequent patches, and more.
>
> We recommend enabling auto-updates to pull the latest version,
> however we also recommend manually updating when major releases
> are made. (Eg. 1.3.4 => 2.0.0)

## <span style="color: #3498DB;">&#x1F4DA;</span> Installation Methods

### Option One: Roblox Asset (Recommended)
You can install Atlas Admin from the Roblox Asset Store [here](https://create.roblox.com/store/asset/17166069350/Atlas-Admin-v132).

### Option Two: GitHub
Alternatively, you can download the latest version from GitHub as an `.rbxm` file [here](https://github.com/MochaTheDev/atlas/releases/latest).

---

## <span style="color: #2ECC71;">&#x1F527;</span> Setup Instructions

After installation, follow these steps to set up Atlas Admin in your Roblox game:

1. **Placement**
   - Place the "atlas_RepStg" folder into ReplicatedStorage.
   - Place the "atlas_SrvScrptSrv" folder into ServerScriptService.
   - Place the "atlas_StarterGui" folder into StarterGui.

2. **Additional Tasks**
   - Delete the "AdminPart."
   - Delete this README script.
   - Go to ReplicatedStorage -> atlas_RepStg -> Settings (ModuleScript) and configure settings as needed.

3. **Notes**
   - **Do Not Edit** `atlas_SrvScrptSrv -> atlas_CORE`. This contains the system's core code. Editing it can cause the system to fail, requiring a complete reinstallation and reconfiguration. Edit at your own risk.

---

## <span style="color: #F39C12;">&#x1F4DD;</span> Settings Overview

Here's a quick explanation of the key settings you can configure:

- **prefix**: Sets the command prefix. Default is ":".
- **datastore**: Set this to a random string for system logging, bans, etc.
- **Server_Message_Header**: Change this to customize the server message header.
- **debug**: Keep this `false` to prevent bypassing admin/override verification checks.
- **fun_commands**: Enable fun commands like `:sit`, `:jump`, etc.
- **plugins_enabled**: Set to `true` to enable custom plugins (see Plugins section).
- **auto_update**: Recommended to keep on. Ensures system automatically sources the latest version.
- **component_verification**: Helps delete broken components and source the correct ones.
- **banned_users**: Hard-banned users cannot be unbanned unless removed from this script.
- **whitelist**: When enabled, players in this list are allowed access.
- **Override**: Users in this section can run special commands and are immune to certain restrictions.
- **Admins**: Hard-coded admins. Any other user (added with `:admin user`) is a temporary admin.

---

## <span style="color: #9B59B6;">&#x1F50E;</span> Plugins

To add your own plugins, refer to the `example_plugin` ModuleScript file for setup instructions.

- **Requirements**
  - Plugins must have a maximum of two arguments. They can have a minimum of zero arguments.

---

## <span style="color: #E74C3C;">&#x1F4AC;</span> Support

If you have any questions, suggestions, or feature requests, join our support server on Discord [here](https://discord.gg/yhTNzJre76).
