------------------
-- Bone Grinder --
------------------
---- Ver 1.0 -----
-----------------------
-- Initial Functions --
-----------------------

laboratory.bone_grinder = {}

local bone_grinder = laboratory.bone_grinder

bone_grinder.recipes = {}

function bone_grinder.register_recipe(input, output)
    bone_grinder.recipes[input] = output;
end

bone_grinder.blades = {};
bone_grinder.blades["hades_laboratory:steel_blade_sharp"] = {
    grind_time = 180,
    blunt_time = 45,
    blunt_name = "hades_laboratory:steel_blade_blunt",
  }
bone_grinder.blades["hades_laboratory:titan_blade_sharp"] = {
    grind_time = 72,
    blunt_time = 24,
    blunt_name = "hades_laboratory:titan_blade_blunt",
  }
bone_grinder.blades["hades_laboratory:wolfram_blade_sharp"] = {
    grind_time = 60,
    blunt_time = 30,
    blunt_name = "hades_laboratory:wolfram_blade_blunt",
  }
bone_grinder.blades["hades_laboratory:diamond_blade_sharp"] = {
    grind_time = 45,
    blunt_time = 45,
    blunt_name = "hades_laboratory:diamond_blade_blunt",
  }

--------------
-- Formspec --
--------------

local bone_grinder_fs = "formspec_version[3]" .. "size[12.75,8.5]" ..
                              "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]" ..
                              "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[transformR270]]" ..
                              "list[current_player;main;1.5,3;8,4;]" ..
                              "list[context;input;2,0.25;1,1;]" ..
                              "list[context;blades_in;2,1.5;1,1;]" ..
                              "list[context;output;9.75,0.25;1,1;]" ..
                              "list[context;blades_out;9.75,1.5;1,1;]" ..
                              "listring[current_player;main]" ..
                              "listring[context;input]" ..
                              "listring[current_player;main]" ..
                              "listring[context;output]" ..
                              "listring[current_player;main]"

local function get_active_bone_grinder_fs(item_percent)
    local form = {
        "formspec_version[3]", "size[12.75,8.5]",
        "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]",
        "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[lowpart:" ..
            (item_percent) ..
            ":laboratory_progress_bar_full.png^[transformR270]]",
        "list[current_player;main;1.5,3;8,4;]",
        "list[context;input;2,0.25;1,1;]",
        "list[context;blades_in;2,1.5;1,1;]",
        "list[context;output;9.75,0.25;1,1;]",
        "list[context;blades_out;9.75,1.5;1,1;]",
        "listring[current_player;main]",
        "listring[context;input]", "listring[current_player;main]",
        "listring[context;output]", "listring[current_player;main]"
    }
    return table.concat(form, "")
end

local function update_formspec(progress, goal, meta)
    local formspec

    if progress > 0 and progress <= goal then
        local item_percent = math.floor(progress / goal * 100)
        formspec = get_active_bone_grinder_fs(item_percent)
    else
        formspec = bone_grinder_fs
    end

    meta:set_string("formspec", formspec)
end

---------------
-- Cultivate --
---------------

local function cultivate(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local input_item = inv:get_stack("input", 1)
    --local blades_item = inv:get_stack("blades", 1)
    local output_item = bone_grinder.recipes[input_item:get_name()]
    input_item:set_count(1)

    if not bone_grinder.recipes[input_item:get_name()] or
        not inv:room_for_item("output", output_item) then
        minetest.get_node_timer(pos):stop()
        update_formspec(0, 3, meta)
    else
        inv:remove_item("input", input_item)
        inv:add_item("output", output_item)
    end
end

----------
-- Node --
----------
local def_desc = "Bone Grinder";

minetest.register_node("hades_laboratory:bone_grinder", {
    description = def_desc,
    _tt_help = "Connect to power and water".."\n".."Grind bones to small pieces.",
    tiles = {
        "laboratory_bone_grinder_top.png",
        "laboratory_bone_grinder_bottom.png",
        "laboratory_bone_grinder_side.png",
        "laboratory_bone_grinder_side.png",
        "laboratory_bone_grinder_side.png",
        "laboratory_bone_grinder_front.png"
    },
    paramtype2 = "facedir",
    groups = {cracky = 2, tubedevice = 1, tubedevice_receiver = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = hades_sounds.node_sound_stone_defaults(),
    drawtype = "node",
    
    -- mssecon action
    mesecons = {
      effector = {
        action_on = function(pos, node)
          minetest.get_meta(pos):set_int("is_powered", 1);
        end,
        action_off = function(pos, node)
          minetest.get_meta(pos):set_int("is_powered", 0);
        end,
      },
    },
    
    can_dig = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        return inv:is_empty("input") and inv:is_empty("blades_in") and inv:is_empty("output") and inv:is_empty("blades_out")
    end,

    on_timer = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        local blades_in = inv:get_stack("blades_in", 1)
        local blades_out = inv:get_stack("blades_out", 1)
        if not bone_grinder.recipes[stack:get_name()] then return false end
        
        local cultivating_time = meta:get_int("cultivating_time") or 0
        
        -- do test for water connection
        local node_over = minetest.get_node({x=pos.x;y=pos.y+1;z=pos.z});
        if (node_over.name~="pipeworks:entry_panel_loaded") then 
          return true;
        end
        -- check if node is powered
        local is_powered = minetest.get_meta(pos):get_int("is_powered");
        if (is_powered==0) then
          return true;
        end
        -- check for blades
        if (blades_in:get_count()==0) then
          return true;
        end
        -- check for free space of blades
        if (blades_out:get_free_space()==0) then
          return true;
        end
      
        local recipe = bone_grinder.recipes[stack:get_name()]
        local blade = bone_grinder.blades[blades_in:get_name()];
        local output_item = recipe;
        local output_time = blade.grind_time;
        cultivating_time = cultivating_time + 1
        if ((cultivating_time%blade.blunt_time)==0) then
          blades_in:take_item(1);
          inv:set_stack("blades_in", 1, blades_in);
          inv:add_item("blades_out", ItemStack(blade.blunt_name));
        end
        if not inv:room_for_item("output", output_item) then return true end
        if cultivating_time % output_time == 0 then cultivate(pos) end
        update_formspec(cultivating_time % output_time, output_time, meta)
        meta:set_int("cultivating_time", cultivating_time)

        if (not stack:is_empty()) then
            return true
        else
            meta:set_int("cultivating_time", 0)
            update_formspec(0, 3, meta)
            return false
        end
    end,

    allow_metadata_inventory_put = function(pos, listname, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end
        if listname == "input" then
            return bone_grinder.recipes[stack:get_name()] and
                       stack:get_count() or 0
        end
        if listname == "blades_in" then
            return (stack:get_name()=="hades_laboratory:steel_blade_sharp" 
                    or stack:get_name()=="hades_laboratory:diamond_blade_sharp")
                    and stack:get_count() or 0
        end
        return 0
    end,

    allow_metadata_inventory_move = function() return 0 end,

    allow_metadata_inventory_take = function(pos, listname, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end
        
        if (listname=="input") then
          local meta = minetest.get_meta(pos);
          local cultivating_time = meta:get_int("cultivating_time") or 0
          if (cultivating_time>0) then
            local count = stack:get_count();
            if (count > 0) then return count-1; end
            return 0;
          end
        end
        
        return stack:get_count()
    end,

    on_metadata_inventory_put = function(pos)
        local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        local blades_in = inv:get_stack("blades_in", 1)
        local output_item = bone_grinder.recipes[stack:get_name()]
        local cultivating_time = meta:get_int("cultivating_time") or 0
        if not bone_grinder.recipes[stack:get_name()] then
            timer:stop()
            meta:set_string("formspec", bone_grinder_fs)
            return
        end
        if blades_in:get_count()==0 then
            timer:stop()
            meta:set_string("formspec", bone_grinder_fs)
            return
        end
        if not inv:room_for_item("output", output_item) then
            --timer:stop()
            return
        else
            if cultivating_time < 1 then update_formspec(0, 3, meta) end
            timer:start(1)
        end
    end,

    on_metadata_inventory_take = function(pos)
        local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        local cultivating_time = meta:get_int("cultivating_time") or 0
        if not bone_grinder.recipes[stack:get_name()] then
            timer:stop()
            meta:set_string("formspec", bone_grinder_fs)
            if cultivating_time > 0 then
                meta:set_int("cultivating_time", 0)
            end
            return
        end
        timer:stop()
        if cultivating_time < 1 then update_formspec(0, 3, meta) end
        timer:start(1)
    end,

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", bone_grinder_fs)
        meta:set_string("infotext", def_desc)
        local inv = meta:get_inventory()
        inv:set_size("input", 1)
        inv:set_size("blades_in", 1)
        inv:set_size("output", 1)
        inv:set_size("blades_out", 1)
    end,
    on_blast = function(pos)
        local drops = {}
        default.get_inventory_drops(pos, "input", drops)
        default.get_inventory_drops(pos, "output", drops)
        table.insert(drops, "hades_laboratory:bone_grinder")
        minetest.remove_node(pos)
        return drops
    end,
    
    after_place_node = function(pos)
      pipeworks.scan_for_pipe_objects(pos);
      if (not minetest.global_exists("mesecon")) then
        minetest.get_meta(pos):set_int("is_powered", 1);
      end
    end,
    after_dig_node = function(pos)
      pipeworks.scan_for_pipe_objects(pos);
    end,
})

-------------------------
-- Recipe Registration --
-------------------------

if laboratory.have_paleotest then
  bone_grinder.register_recipe( "hades_paleotest:bones_dinosaur",
                                "hades_laboratory:crushed_bones_dinosaur")
  bone_grinder.register_recipe( "hades_paleotest:bones_iceage",
                                "hades_laboratory:crushed_bones_iceage")
  bone_grinder.register_recipe( "hades_paleotest:bones_recent",
                                "hades_laboratory:crushed_bones_recent")
  
  bone_grinder.register_recipe( "hades_laboratory:crushed_bones_dinosaur",
                                "hades_laboratory:dust_bones_dinosaur")
  bone_grinder.register_recipe( "hades_laboratory:crushed_bones_iceage",
                                "hades_laboratory:dust_bones_iceage")
  bone_grinder.register_recipe( "hades_laboratory:crushed_bones_recent",
                                "hades_laboratory:dust_bones_recent")
end

