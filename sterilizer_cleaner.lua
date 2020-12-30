--------------------
---- Sterilizer ----
--------------------
------ Ver 1.0 -----
-----------------------
-- Initial Functions --
-----------------------
laboratory.sterilizer = {}

local sterilizer = laboratory.sterilizer

sterilizer.recipes = {}

function sterilizer.register_recipe(input, output)
    sterilizer.recipes[input] = output
end

--------------
-- Formspec --
--------------

local sterilizer_fs = "formspec_version[3]" .. "size[12.75,8.5]" ..
                              "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]" ..
                              "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[transformR270]]" ..
                              "list[current_player;main;1.5,3;8,4;]" ..
                              "list[context;input;2,0.75;1,1;]" ..
                              "list[context;output;9.75,0.75;1,1;]" ..
                              "listring[current_player;main]" ..
                              "listring[context;input]" ..
                              "listring[current_player;main]" ..
                              "listring[context;output]" ..
                              "listring[current_player;main]"

local function get_active_sterilizer_fs(item_percent)
    local form = {
        "formspec_version[3]", "size[12.75,8.5]",
        "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]",
        "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[lowpart:" ..
            (item_percent) ..
            ":laboratory_progress_bar_full.png^[transformR270]]",
        "list[current_player;main;1.5,3;8,4;]",
        "list[context;input;2,0.75;1,1;]",
        "list[context;output;9.75,0.75;1,1;]", "listring[current_player;main]",
        "listring[context;input]", "listring[current_player;main]",
        "listring[context;output]", "listring[current_player;main]"
    }
    return table.concat(form, "")
end

local function update_formspec(progress, goal, meta)
    local formspec

    if progress > 0 and progress <= goal then
        local item_percent = math.floor(progress / goal * 100)
        formspec = get_active_sterilizer_fs(item_percent)
    else
        formspec = sterilizer_fs
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
    local output_item = sterilizer.recipes[input_item:get_name()]
    input_item:set_count(1)

    if not sterilizer.recipes[input_item:get_name()] or
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

local def_desc = "Sterilizer and cleaner";

minetest.register_node("hades_laboratory:sterilizer", {
    description = def_desc,
    _tt_help = "Connect to power and water".."\n".."Clean and sterilize botte",
    tiles = {
        "laboratory_sterilizer_top.png",
        "laboratory_sterilizer_bottom.png",
        "laboratory_sterilizer_side.png",
        "laboratory_sterilizer_side.png",
        "laboratory_sterilizer_side.png", 
        "laboratory_sterilizer_front.png"
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
        return inv:is_empty("input") and inv:is_empty("output")
    end,

    on_timer = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = meta:get_inventory():get_stack("input", 1)
        if not sterilizer.recipes[stack:get_name()] then return false end
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
      
        local output_item = sterilizer.recipes[stack:get_name()]
        local cultivating_time = meta:get_int("cultivating_time") or 0
        cultivating_time = cultivating_time + 1
        if cultivating_time % 30 == 0 then cultivate(pos) end
        update_formspec(cultivating_time % 30, 30, meta)
        meta:set_int("cultivating_time", cultivating_time)
        if not inv:room_for_item("output", output_item) then return false end

        if not stack:is_empty() then
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
            return sterilizer.recipes[stack:get_name()] and
                       stack:get_count() or 0
        end
        return 0
    end,

    allow_metadata_inventory_move = function() return 0 end,

    allow_metadata_inventory_take = function(pos, _, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end
        return stack:get_count()
    end,

    on_metadata_inventory_put = function(pos)
        local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        local output_item = sterilizer.recipes[stack:get_name()]
        local cultivating_time = meta:get_int("cultivating_time") or 0
        if not sterilizer.recipes[stack:get_name()] then
            timer:stop()
            meta:set_string("formspec", sterilizer_fs)
            return
        end
        if not inv:room_for_item("output", output_item) then
            timer:stop()
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
        if not sterilizer.recipes[stack:get_name()] then
            timer:stop()
            meta:set_string("formspec", sterilizer_fs)
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
        meta:set_string("formspec", sterilizer_fs)
        meta:set_string("infotext", def_desc)
        local inv = meta:get_inventory()
        inv:set_size("input", 1)
        inv:set_size("output", 1)
    end,
    on_blast = function(pos)
        local drops = {}
        default.get_inventory_drops(pos, "input", drops)
        default.get_inventory_drops(pos, "output", drops)
        table.insert(drops, "hades_laboratory:sterilizer")
        minetest.remove_node(pos)
        return drops
    end,
    
    after_place_node = function(pos)
      pipeworks.scan_for_pipe_objects(pos);
      if (not minetest.global_exists("mesecon")) then
        minetest.get_meta(pos):set_int("is_powered", 1);
      end
    end,
})

-------------------------
-- Recipe Registration --
-------------------------

if (laboratory.have_paleotest) then
  sterilizer.register_recipe("vessels:glass_bottle",
                               "hades_laboratory:sterilized_glass_bottle");
  
  sterilizer.register_recipe("vessels:steel_bottle",
                               "hades_laboratory:sterilized_steel_bottle");
  
  sterilizer.register_recipe("hades_laboratory:water_filter_dirty",
                               "hades_laboratory:water_filter");
  
  sterilizer.register_recipe("hades_laboratory:biomaterial_filter_dirty",
                               "hades_laboratory:biomaterial_filter_sterilized");
  
  sterilizer.register_recipe("hades_core:coal_lump",
                               "hades_laboratory:sterilized_coal_lump");
  
  sterilizer.register_recipe("hades_core:fertile_sand",
                               "hades_laboratory:sterilized_sand");
  
  for i=2,5 do
    sterilizer.register_recipe("hades_laboratory:growth_medium_remains_"..i,
                               "hades_laboratory:sterilized_glass_bottle");
  end
end

