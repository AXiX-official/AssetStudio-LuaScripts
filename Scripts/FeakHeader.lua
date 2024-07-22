-- Author: AXiX
-- Version: 1.0
-- AssetStudio-Version: 1.37.04
-- Description: This script is used to remove the fake header of the file.

function get_offset(stream)
    local readr = CreateEndianBinaryReader(stream)
    local buffer = readr:ReadBytes(1024)
    local firstSevenChars = string.char(table.unpack(buffer, 0, 6))
    local firstPos = 0
    if firstSevenChars == 'UnityFS' then
        firstPos = 7
    elseif buffer[1] == 0x89 then
        firstPos = 1
    end
    local allText = string.char(table.unpack(buffer, 0 , 1023))
    local secondPos = string.find(allText, 'UnityFS', firstPos)
    return secondPos - 1
end
    
SetGame("Normal")
local tmp = CreateFileStream(filepath)
tmp.Position = get_offset(tmp)
local fs = CreateMemoryStream()
tmp:CopyTo(fs)
tmp:Close()
fs.Position = 0
return fs