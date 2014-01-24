-- set images here mapa is water, mapb is ice, mapc is elevation on here.
local mapa = minetest.get_modpath("bmpmap").."/maps/world_water.bmp"
local mapb = minetest.get_modpath("bmpmap").."/maps/world_ice.bmp"
local mapc = minetest.get_modpath("bmpmap").."/maps/world_elev.bmp"
-- configure needed nodes here
 local dirt  = minetest.get_content_id("default:dirt")
 local air = minetest.get_content_id("air")




minetest.register_on_mapgen_init(function(mgparams)
        minetest.set_mapgen_params({mgname="singlenode", flags="nolight", flagmask="nolight"})
end)
 
minetest.register_on_generated(function(minp, maxp, seed)
        local t1 = os.clock()
        local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
        local a = VoxelArea:new{
                MinEdge={x=emin.x, y=emin.y, z=emin.z},
                MaxEdge={x=emax.x, y=emax.y, z=emax.z},
        }
 
        local data = vm:get_data()

        local sidelen = maxp.x - minp.x + 1
 
        local noise = minetest.get_perlin_map(
                {offset=0, scale=1, spread={x=200, y=125, z=200}, seed=5, octaves=5, persist=0.6},
                {x=sidelen, y=sidelen, z=sidelen}
        )
        local nvals = noise:get3dMap_flat({x=minp.x, y=minp.y, z=minp.z})
                bmpa = { }
                bmpb = { }
                bmpc = { }
                collectgarbage()
		local bmpa, ea = bmpmap.load(mapa, minp.z, maxp.z, minp.x, maxp.x)
		local bmpb, eb = bmpmap.load(mapb, minp.z, maxp.z, minp.x, maxp.x)
		local bmpc, ec = bmpmap.load(mapc, minp.z, maxp.z, minp.x, maxp.x)
		if not bmpa then
                        print(("[imageloader] Failed to load image: "..(ea or "unknown error")))
                        return
                end
		if not bmpb then
                        print(("[imageloader] Failed to load image: "..(eb or "unknown error")))
                        return
                end
		if not bmpc then
                        print(("[imageloader] Failed to load image: "..(ec or "unknown error")))
                        return
                end
        local ni = 1
        for z = minp.z, maxp.z do
        for y = minp.y, maxp.y do
        for x = minp.x, maxp.x do
        	        local vi = a:index(x, y, z)
			if math.floor(bmpa.w/2) < math.abs(x)  and math.floor(bmpa.h/2) < math.abs(z)then
				local ca = bmpa.pixels[z + math.floor(bmpa.h/2)][x + math.floor(bmpa.w/2)]
				local cb = bmpb.pixels[z + math.floor(bmpa.h/2)][x + math.floor(bmpa.w/2)]
				local cc = bmpc.pixels[z + math.floor(bmpa.h/2)][x + math.floor(bmpa.w/2)]
				if ((cc.r + cc.g + cc.b)/3) >= y then
                                      data[vi] = dirt
                                else
                                      data[vi] = air
                                end
			else
				data[vi] = air
			end
        end
        end
        end
 
        vm:set_data(data)
       
        vm:calc_lighting(
                {x=minp.x-16, y=minp.y, z=minp.z-16},
                {x=maxp.x+16, y=maxp.y, z=maxp.z+16}
        )
 
        vm:write_to_map(data)
 
    print(string.format("elapsed time: %.2fms", (os.clock() - t1) * 1000))
end)
