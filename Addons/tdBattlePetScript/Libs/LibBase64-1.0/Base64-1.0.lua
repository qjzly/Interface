--[[
Base64.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

local MAJOR, MINOR = 'LibBase64-1.0', 1
local Base64 = LibStub:NewLibrary(MAJOR, MINOR)
if not Base64 then return end

local B = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local TAILS = {'', '==', '='}

local c, r

local gsub     = string.gsub
local strchar  = string.char
local strfind  = string.find
local tonumber = tonumber

local function tobitstr(b, l)
    r = ''
    for i = l, 1, -1 do
        r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0')
    end
    return r
end

function Base64:enc(data)
    data = gsub(data, '.', function(x)
        return tobitstr(x:byte(), 8)
    end) .. '0000'
    data = gsub(data, '%d%d%d?%d?%d?%d?', function(x)
        if #x < 6 then
            return ''
        end
        c = tonumber(x, 2) + 1
        return B:sub(c, c)
    end)
    return data .. TAILS[#data % 3 + 1]
end

function Base64:dec(data)
    data = gsub(data, '[^' .. B .. '=]', '')
    data = gsub(data, '.', function(x)
        if x == '=' then
            return ''
        end
        return tobitstr(strfind(B, x) - 1, 6)
    end)
    data = gsub(data, '%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then
            return ''
        end
        return strchar(tonumber(x, 2))
    end)
    return data
end
