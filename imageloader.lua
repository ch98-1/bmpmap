bmpmap = { }

local types = { }

local bmp_meta = {
        __index = bmp_methods,
}

--[[
typedef = {
        description = "FOO File",
        check = func(file), --> bool
        load = func(file), --> table or (nil, errormsg)
}
]]

function bmpmap.register_type(def)

        types[#types + 1] = def

end

local function find_loader(file)

        for _,def in ipairs(types) do

                file:seek("set", 0)
                local r = def.check(file)
                file:seek("set", 0)

                if r then
                        return def
                end

        end

        return nil, "bmpmap: unknown file type"

end

function bmpmap.load(filename)

        local f, e = io.open(filename)
        if not f then return nil, "bmpmap: "..e end

        local def, e = find_loader(f)
        if not def then return nil, e end

        local r, e = def.load(f)

        f:close()

        if r then
                r = setmetatable(r, bmp_meta)
        end

        return r, e

end

function bmpmap.type(filename)

        local f, e = io.open(filename)
        if not f then return nil, "bmpmap: "..e end

        local def, e = find_loader(f)
        if not def then return nil, e end

        return def.description

end


