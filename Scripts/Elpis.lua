-- Author: AXiX
-- Version: 1.0
-- AssetStudio-Version: 1.37.04
-- Description: This script is used for game Elpis.
   
SetGame("UnityCN")
SetUnityCNKey("Elpis", "79756E67756968616F77616E31323334")
local tmp = CreateFileStream(filepath)
tmp.Position = 32
local fs = CreateMemoryStream()
tmp:CopyTo(fs)
tmp:Close()
fs.Position = 0
return fs