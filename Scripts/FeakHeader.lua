-- Author: AXiX
-- Version: 1.0
-- AssetStudio-Version: 1.37.04
-- Description: This script is used to remove the fake header of the file.

local max_length = 2048

function read_to_null(buffer, index)
    -- 读取到'00'为止
    local i = index
    while buffer[i] ~= 0 do
        i = i + 1
    end
    return i + 1
end

function get_size_from_header(buffer, index)
    local i = index + 11
    i = read_to_null(buffer, i)
    i = read_to_null(buffer, i)
    local size = 0
    for j = 1, 8 do
        size = size * 256 + buffer[i + j - 1]
    end
    return size
end

function max(a, b)
    if a > b then
        return a
    else
        return b
    end
end

function get_offset(stream)
    local length = stream.Length
    Verbose("File length: " .. length)
    local readr = CreateEndianBinaryReader(stream)
    local buffer = readr:ReadBytes(max_length)
    local allText = string.char(table.unpack(buffer, 0 , max_length - 1))
    local indexs = {}
    local i = string.find(allText, 'UnityFS', 0)
    while i do
        Verbose("Find UnityFS at " .. i)
        table.insert(indexs, i)
        i = string.find(allText, 'UnityFS', i + 1)
    end
    for j = #indexs, 1, -1 do
        local j_size = get_size_from_header(buffer, indexs[j])
        Verbose("UnityFS size: " .. j_size)
        if j_size + indexs[j] - 1 == length then
            return indexs[j] - 1
        end
    end
    return -1
end
    
SetGame("Normal")
local tmp = CreateFileStream(filepath)
tmp.Position = get_offset(tmp)
local fs = CreateMemoryStream()
tmp:CopyTo(fs)
tmp:Close()
fs.Position = 0
return fs