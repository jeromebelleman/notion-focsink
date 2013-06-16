--[[
-- Focus sink, a simple-minded focus stealing prevention
--]]

focsink = {}

local NAME = 'focsink'
local ATTR = 'sink'

local oldname

function focsink.anythingbuturxvt(prop, cwin, id)
    if id.class ~= 'URxvt' then
        return true
    end
end

defwinprop{
    target = NAME,
    match = focsink.anythingbuturxvt,
}

function focsink.toggle()
    -- Unset previous focus sink if any
    local oldfrm
    ioncore.region_i(function(f)
        if f:name() == NAME then
            oldfrm = f
        end
        return true
    end, 'WFrame')
    if oldfrm then
        oldfrm:set_name(oldname)
        oldfrm:set_grattr(ATTR, 'unset')
    end

    -- Set new focus sink if previous one isn't the same
    cur = ioncore.current()
    if obj_is(cur, 'WFrame') then
        oldname = cur:name()
        if cur ~= oldfrm then
            cur:set_name(NAME)
            cur:set_grattr(ATTR, 'set')
        end
    elseif obj_is(cur, 'WClientWin') then
        oldname = cur:parent():name()
        if cur:parent() ~= oldfrm then
            cur:parent():set_name(NAME)
            cur:parent():set_grattr(ATTR, 'set')
        end
    end
end
