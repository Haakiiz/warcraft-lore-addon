__NS = {}
-- Record every global the addon creates.
setmetatable(_G, { __newindex = function(t, k, v)
    MOCK.newGlobals[#MOCK.newGlobals + 1] = tostring(k)
    rawset(t, k, v)
end })
