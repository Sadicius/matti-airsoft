# 🔫 matti-airsoft - Ultimate Airsoft Arena for QBCore

Welcome to the most thrilling airsoft experience for your FiveM server! This script brings competitive, safe airsoft battles to your players with complete customization options.

## 🎯 Key Features

### Core Gameplay

- **Realistic Loadouts**: Choose from pre-configured or randomized weapon sets
- **Dynamic Arenas**: Random spawn locations keep matches fresh and unpredictable
- **Safety First**: Automatic ejection when players are "downed"

### Immersive Elements

- **Interactive Peds**: Entry/Exit NPCs with full customization
- **Visual Feedback**: Clear arena status notifications
- **Debug Tools**: Developer-friendly features for testing spawns and zones

### Framework Support

- **Target Systems**: Works with both qb-target and ox_target
- **Inventory Compatible**: Supports qb-inventory and ox_inventory
- **Notification Options**: Choose between qb-core or ox_lib styles

## 🎮 Screenshot Gallery

### Loadout Selection

![image](https://github.com/user-attachments/assets/6c69564e-46a1-4adf-9f9b-185a3c610374)
![image](https://github.com/user-attachments/assets/52f2d3a1-1ece-49a8-9b3b-a2d61a442cdf)

### Arena Access

![image](https://github.com/user-attachments/assets/8f1cd476-3149-4f3a-b099-395d62fb36d3)
![image](https://github.com/user-attachments/assets/dc8d958d-36e1-4a56-8bcc-d58719db2197)

### Match Notifications

![image](https://github.com/user-attachments/assets/07c4bf14-e37c-406c-bbc2-9768fe809520)
![image](https://github.com/user-attachments/assets/c47c5ed3-094d-4a82-af9e-9bd5c6e1ca57)
![image](https://github.com/user-attachments/assets/1734da67-f623-426f-b106-9cd3a5d32e28)

### Developer Tools

![image](https://github.com/user-attachments/assets/f503072d-90c2-4bd9-ab14-8920d22c6b76)
![image](https://github.com/user-attachments/assets/e53f8654-b817-496c-bfb9-f66ea64a2505)

_🎥 Video preview coming soon!_

## 🗺️ Recommended Maps

For the best experience, pair this script with [iakkoise's Softair Map](https://www.gta5-mods.com/maps/ymap-softair-sp-fivem-alt-v) - a lightweight, optimized arena using native GTA props.

## 🔫 Weapon Recommendations

Enhance realism with [Localspetsnaz's Airsoft Guns Pack](https://forum.cfx.re/t/free-standalone-add-on-standalone-add-on-airsoft-guns/5026328):

- Non-lethal BB pellets that stun instead of kill
- Authentic airsoft weapon models
- Complete setup guide below:

<details>
<summary>📖 Installation Guide</summary>

1. Add guns to your server resources and start them in `server.cfg`
2. In `qb-core/shared/items.lua`:
   ```lua
   weapon_airsoftglock20 = {
     name = 'weapon_airsoftglock20',
     label = 'Airsoft Glock 20',
     weight = 1000,
     type = 'weapon',
     ammotype = 'AMMO_PISTOL',
     image = 'weapon_pistol.png',
     unique = true,
     useable = false,
     description = 'Airsoft Glock 20'
   },
   ```
3. In `qb-core/shared/weapons.lua`:
   ```lua
   [`weapon_airsoftglock20`] = {
     name = 'weapon_airsoftglock20',
     label = 'Airsoft Glock 20',
     weapontype = 'Pistol',
     ammotype = 'AMMO_PISTOL',
     damagereason = 'Hit by a BB'
   },
   ```
4. In `qb-weapons/config.lua` (Durability section):
   ```lua
   weapon_airsoftglock20 = 0.05,
   ```
5. In `qb-weapons/client/weapdraw.lua`:
   ```lua
   'WEAPON_AIRSOFTGLOCK20',
   ```
   </details>

## 🚨 Pro Tip for Police Systems

Using ps-dispatch? Prevent false alerts by adding a NoDispatchZone:

```lua
[3] = {
  label = "Airsoft Arena",
  coords = vector3(2025.99, 2784.98, 76.39),
  length = 14.0,
  width = 5.0,
  heading = 270,
  minZ = 28.62,
  maxZ = 32.62
},
```

## ⚙️ Dependencies

- [ox_lib](https://github.com/overextended/ox_lib) - For version checking
- [PolyZone](https://github.com/mkafrin/PolyZone) - Zone management
