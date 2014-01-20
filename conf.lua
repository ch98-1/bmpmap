 function bmpmap.getnode (x, y, z)
 --[[ configure stuff here ]]
 -- list of required nodes
 local nodes = {"default:dirt", "default:dirt_with_grass", "default:water_source"}
 
 --[[ end configuring stuff ]]
 for a = 1, table.getn(nodes)
        local nodes[a]  = minetest.get_content_id(nodes[a])
 end
 