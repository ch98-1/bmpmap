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
 
        local ni = 1
        for z = minp.z, maxp.z do
        for y = minp.y, maxp.y do
        for x = minp.x, maxp.x do
            data[vi] = getnode(x, y, z)
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
