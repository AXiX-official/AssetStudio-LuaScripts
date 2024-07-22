-- Author: AXiX
-- Version: 1.0
-- AssetStudio-Version: 1.37.04
-- Description: This script is form game Orisries.

local keystr = 'wiki is transfer'
local tmp = ReadAllBytes(filepath)
local len = tmp.Length
local iv_len = tmp[len - 4] + tmp[len - 3] * 256 + tmp[len - 2] * 256 * 256 + tmp[len - 1] * 256 * 256 * 256
local data_end = len - iv_len - 4
local iv = SliceByteArray(tmp, data_end, iv_len)
local data = SliceByteArray(tmp, 0, data_end)
local key = EncodeStringToBytes(keystr)
local de_data = AES_Decrypt(data, key, iv)
local fs = CreateMemoryStreamFormByteArray(de_data)
return fs