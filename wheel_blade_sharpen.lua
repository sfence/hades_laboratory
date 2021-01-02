-------------------------
-- Wheel Blade Sharpen --
-------------------------
-------- Ver 1.0 --------
-----------------------
-- Initial Functions --
-----------------------
laboratory.wheel_blade_sharpen = {}

local wheel_blade_sharpen = laboratory.wheel_blade_sharpen

wheel_blade_sharpen.recipes = laboratory.get_empty_recipe();

wheel_blade_sharpen.power_data = {
  ["LV"] = {
      demand = 200,
      run_speed = 2,
    },
  ["no_technic"] = {
      run_speed = 1,
    },
}

--------------
-- Formspec --
--------------

local wheel_blade_sharpen_fs = "formspec_version[3]" .. "size[12.75,8.5]" ..
                              "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]" ..
                              "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[transformR270]]" ..
                              "list[current_player;main;1.5,3;8,4;]" ..
                              "list[context;input;2,0.25;1,1;]" ..
                              "list[context;use_in;2,1.5;1,1;]" ..
                              "list[context;output;9.75,0.25;2,2;]" ..
                              "listring[current_player;main]" ..
                              "listring[context;input]" ..
                              "listring[current_player;main]" ..
                              "listring[context;output]" ..
                              "listring[current_player;main]"

local function get_active_wheel_blade_sharpen_fs(item_percent)
    local form = {
        "formspec_version[3]", "size[12.75,8.5]",
        "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]",
        "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[lowpart:" ..
            (item_percent) ..
            ":laboratory_progress_bar_full.png^[transformR270]]",
        "list[current_player;main;1.5,3;8,4;]",
        "list[context;input;2,0.25;1,1;]",
        "list[context;use_in;2,1.5;1,1;]",
        "list[context;output;9.75,0.25;2,2;]",
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
        formspec = get_active_wheel_blade_sharpen_fs(item_percent)
    else
        formspec = wheel_blade_sharpen_fs
    end

    meta:set_string("formspec", formspec)
end

---------------------
-- Inactive/Active --
---------------------

local function activate(pos, meta)
  local timer = minetest.get_node_timer(pos);
  if (not timer:is_started()) then
    timer:start(1)
    laboratory.power_need(meta, wheel_blade_sharpen.power_data)
  end
end

local function deactivate(pos, meta)
  minetest.get_node_timer(pos):stop()
  update_formspec(0, 3, meta)
  laboratory.swap_node(pos, "hades_laboratory:wheel_blade_sharpen");
  laboratory.power_idle(meta, wheel_blade_sharpen.power_data)
end
local function running(pos, meta)
  laboratory.swap_node(pos, "hades_laboratory:wheel_blade_sharpen_active");
  laboratory.power_need(meta, wheel_blade_sharpen.power_data)
end
local function waiting(pos, meta)
  laboratory.swap_node(pos, "hades_laboratory:wheel_blade_sharpen");
  laboratory.power_idle(meta, wheel_blade_sharpen.power_data)
end
local function no_power(pos, meta)
  laboratory.swap_node(pos, "hades_laboratory:wheel_blade_sharpen");
  laboratory.power_need(meta, wheel_blade_sharpen.power_data)
end

--------------------
-- Node callbacks --
--------------------

-- mssecon action
local mesecons_action =
  {
    effector = {
      action_on = function(pos, node)
        minetest.get_meta(pos):set_int("is_powered", 1);
      end,
      action_off = function(pos, node)
        minetest.get_meta(pos):set_int("is_powered", 0);
      end,
    }
  };

local tube =
  {
    insert_object = function(pos, node, stack, direction, owner)
        local stack = laboratory.tube_insert(pos, node, stack, direction, owner, wheel_blade_sharpen.recipes);
        
        local meta = minetest.get_meta(pos);
        local inv = meta:get_inventory();
        local use_input, use_usage = laboratory.recipe_aviable_input(wheel_blade_sharpen.recipes, inv)
        if use_input then
          activate(pos, meta);
        end
        
        return stack;
      end,
    can_insert = function(pos, node, stack, direction, owner)
        return laboratory.tube_can_insert(pos, node, stack, direction, owner, wheel_blade_sharpen.recipes);
      end,
    connect_sides = {left = 1, right = 1}, 
    input_inventory = "output",
  };

local can_dig = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      return inv:is_empty("input") and inv:is_empty("output")
  end
local after_dig_node = function(pos, oldnode, oldmetadata, digger)
    pipeworks.scan_for_pipe_objects(pos);
    pipeworks.scan_for_tube_objects(pos);
    
    local stack = oldmetadata.inventory["use_in"][1];
    local consumption_time = tonumber(oldmetadata.fields["consumption_time"] or "0");
    if (consumption_time>0) then
      stack:take_item(1);
    end
    minetest.item_drop(stack, digger, pos)
  end

on_blast = function(pos)
    local drops = {}
    default.get_inventory_drops(pos, "input", drops)
    default.get_inventory_drops(pos, "use_in", drops)
    default.get_inventory_drops(pos, "output", drops)
    table.insert(drops, "hades_laboratory:water_electrolysis")
    minetest.remove_node(pos)
    return drops
  end

local on_timer = function(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    
    local production_time = meta:get_int("production_time") or 0
    local consumption_time = meta:get_int("consumption_time") or 0
    
    -- have aviable production recipe?
    local use_input, use_usage = laboratory.recipe_aviable_input(wheel_blade_sharpen.recipes, inv)
    if (use_input==nil) then
      waiting(pos, meta);
      return true;
    end
    
    -- space for production outputs?
    if (#use_input.outputs==1) then
      local output = laboratory.recipe_select_output(use_input.outputs);
      if (not laboratory.recipe_room_for_output(inv, output)) then
        waiting(pos, meta);
        return true;
      end
    end
    
    -- check for water pipe connection
    if (laboratory.is_pipe_over_loaded(pos)~=true) then
      waiting(pos, meta);
      return true;
    end
    
    -- check if node is powered
    local speed = laboratory.is_powered(meta, wheel_blade_sharpen.power_data)
    if (speed==0) then
      no_power(pos, meta);
      return true;
    end
    
    -- time update
    local production_step_size = laboratory.recipe_step_size(use_usage.production_step_size*speed);
    local consumption_step_size = laboratory.recipe_step_size(speed);
    
    production_time = production_time + production_step_size;
    consumption_time = consumption_time + consumption_step_size;
    
    -- remove used item
    if (consumption_time>=use_usage.consumption_time) then
      local output = laboratory.recipe_select_output(use_usage.outputs); 
      if (not laboratory.recipe_room_for_output(inv, output)) then
        waiting(pos, meta);
        return true;
      end
      laboratory.recipe_output_to_stack(inv, output);
      laboratory.recipe_usage_from_stack(inv, use_usage);
      consumption_time = 0;
      meta:set_int("consumption_time", 0);
    end
    
    -- production done
    if (production_time>=use_input.production_time) then
      local output = laboratory.recipe_select_output(use_input.outputs); 
      if (not laboratory.recipe_room_for_output(inv, output)) then
        waiting(pos, meta);
        return true;
      end
      laboratory.recipe_output_to_stack(inv, output);
      laboratory.recipe_input_from_stack(inv, use_input);
      production_time = 0;
      meta:set_int("production_time", 0);
    end
    
    update_formspec(production_time, use_input.production_time, meta)
    meta:set_int("production_time", production_time)
    meta:set_int("consumption_time", consumption_time)
    
    -- have aviable production recipe?
    local use_input, use_usage = laboratory.recipe_aviable_input(wheel_blade_sharpen.recipes, inv)
    if use_input then
      running(pos, meta);
      return true
    else
      if (production_time) then
        waiting(pos, meta)
      else
        deactivate(pos, meta)
      end
      return false
    end
  end

local allow_metadata_inventory_put = function(pos, listname, index, stack, player)
    return laboratory.recipe_inventory_can_put(pos, listname, index, stack, player, wheel_blade_sharpen.recipes);
  end

local allow_metadata_inventory_move = function() return 0 end

local allow_metadata_inventory_take = function(pos, listname, index, stack, player)
    return laboratory.recipe_inventory_can_take(pos, listname, index, stack, player, wheel_blade_sharpen.recipes);
  end

local on_metadata_inventory_put = function(pos)
    local meta = minetest.get_meta(pos)
    local timer = minetest.get_node_timer(pos)
    local inv = meta:get_inventory()
    
    -- have aviable production recipe?
    local use_input, use_usage = laboratory.recipe_aviable_input(wheel_blade_sharpen.recipes, inv)
    if use_input then
      activate(pos, meta);
      return
    else
      deactivate(pos, meta)
      
    end
  end

local on_metadata_inventory_take = function(pos)
    local meta = minetest.get_meta(pos)
    local timer = minetest.get_node_timer(pos)
    local inv = meta:get_inventory()
    
    -- have aviable production recipe?
    local use_input, use_usage = laboratory.recipe_aviable_input(wheel_blade_sharpen.recipes, inv)
    if use_input then
      activate(pos, meta);
      return
    else
      deactivate(pos, meta)
      return
    end
  end
    

----------
-- Node --
----------

local def_desc = "Wheel Blade Sharpen";

minetest.register_node("hades_laboratory:wheel_blade_sharpen", {
    description = def_desc,
    _tt_help = "Connect to power (LV) and water".."\n".."Make blunt blades sharp again",
    tiles = {
        "laboratory_wheel_blade_sharpen_top.png",
        "laboratory_wheel_blade_sharpen_bottom.png",
        "laboratory_wheel_blade_sharpen_side.png",
        "laboratory_wheel_blade_sharpen_side.png",
        "laboratory_wheel_blade_sharpen_side.png",
        "laboratory_wheel_blade_sharpen_front.png"
    },
    paramtype2 = "facedir",
    groups = {cracky = 2, tubedevice = 1, tubedevice_receiver = 1, technic_machine = 1, technic_lv = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = hades_sounds.node_sound_stone_defaults(),
    drawtype = "node",
    
    -- power connect
    connect_sides = {"back"}, 
    
    -- tube connect
    tube = tube,
    
    -- pipe connect
    pipe_connections = { top = true },
    
    -- mssecon action
    mesecons = mesecons_action,
    
    can_dig = can_dig,
    after_dig_node = after_dig_node,
    on_blast = on_blast,

    on_timer = on_timer,

    allow_metadata_inventory_put = allow_metadata_inventory_put,
    allow_metadata_inventory_move = allow_metadata_inventory_move,
    allow_metadata_inventory_take = allow_metadata_inventory_take,

    on_metadata_inventory_put = on_metadata_inventory_put,

    on_metadata_inventory_take = on_metadata_inventory_take,

    on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("formspec", wheel_blade_sharpen_fs)
      meta:set_string("infotext", def_desc)
      local inv = meta:get_inventory()
      inv:set_size("input", 1)
      inv:set_size("use_in", 1)
      inv:set_size("output", 4)
    end,
    
    after_place_node = function(pos)
      pipeworks.scan_for_pipe_objects(pos);
      pipeworks.scan_for_tube_objects(pos);
      if (not minetest.global_exists("mesecon")) then
        minetest.get_meta(pos):set_int("is_powered", 1);
      end
    end,
})
minetest.register_node("hades_laboratory:wheel_blade_sharpen_active", {
    description = def_desc,
    tiles = {
        "laboratory_wheel_blade_sharpen_top.png",
        "laboratory_wheel_blade_sharpen_bottom.png",
        "laboratory_wheel_blade_sharpen_side.png",
        "laboratory_wheel_blade_sharpen_side.png",
        "laboratory_wheel_blade_sharpen_side.png",
        {
          image = "laboratory_wheel_blade_sharpen_front_active.png",
          backface_culling = true,
          animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 1.5
          }
        }
    },
    paramtype2 = "facedir",
    groups = {cracky = 2, tubedevice = 1, tubedevice_receiver = 1, technic_machine = 1, technic_lv = 1, not_in_creative_inventory = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = hades_sounds.node_sound_stone_defaults(),
    drawtype = "node",
    
    -- power connect
    connect_sides = {"back"}, 
    
    -- tube connect
    tube = tube,
    
    -- pipe connect
    pipe_connections = { top = true },
    
    -- mssecon action
    mesecons = mesecons_action,
    
    can_dig = can_dig,
    after_dig_node = after_dig_node,
    on_blast = on_blast,

    on_timer = on_timer,

    allow_metadata_inventory_put = allow_metadata_inventory_put,
    allow_metadata_inventory_move = allow_metadata_inventory_move,
    allow_metadata_inventory_take = allow_metadata_inventory_take,

    on_metadata_inventory_put = on_metadata_inventory_put,

    on_metadata_inventory_take = on_metadata_inventory_take,

    on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      meta:set_string("formspec", wheel_blade_sharpen_fs)
      meta:set_string("infotext", def_desc)
      local inv = meta:get_inventory()
      inv:set_size("input", 1)
      inv:set_size("use_in", 1)
      inv:set_size("output", 2)
    end,
    
    after_place_node = function(pos)
      pipeworks.scan_for_pipe_objects(pos);
      pipeworks.scan_for_tube_objects(pos);
      if (not minetest.global_exists("mesecon")) then
        minetest.get_meta(pos):set_int("is_powered", 1);
      end
    end,
})

if laboratory.have_technic then
  technic.register_machine("LV", "hades_laboratory:wheel_blade_sharpen",        technic.receiver)
  technic.register_machine("LV", "hades_laboratory:wheel_blade_sharpen_active", technic.receiver)
end

-------------------------
-- Recipe Registration --
-------------------------
  
laboratory.recipe_register_usage( wheel_blade_sharpen.recipes,
  "hades_laboratory:sand_grinding_wheel",
  {
    outputs = {{"hades_laboratory:grinding_wheel_base", "hades_laboratory:diamond_dust"}},
    consumption_time = 60,
    production_step_size = 1,
  });
laboratory.recipe_register_usage( wheel_blade_sharpen.recipes,
  "hades_laboratory:diamond_grinding_wheel",
  {
    outputs = {{"hades_laboratory:grinding_wheel_base", "hades_laboratory:diamond_dust"}},
    consumption_time = 120,
    production_step_size = 2,
  });

laboratory.recipe_register_input( wheel_blade_sharpen.recipes,
  "hades_laboratory:steel_blade_blunt",
  {
    inputs = 1,
    outputs = {"hades_laboratory:steel_blade_sharp"},
    production_time = 30,
  });
laboratory.recipe_register_input( wheel_blade_sharpen.recipes,
  "hades_laboratory:titan_blade_blunt",
  {
    inputs = 1,
    outputs = {"hades_laboratory:titan_blade_sharp"},
    production_time = 60,
  });
laboratory.recipe_register_input( wheel_blade_sharpen.recipes,
  "hades_laboratory:tungsten_blade_blunt",
  {
    inputs = 1,
    outputs = {"hades_laboratory:tungsten_blade_sharp"},
    production_time = 90,
  });
laboratory.recipe_register_input( wheel_blade_sharpen.recipes,
  "hades_laboratory:diamond_blade_blunt",
  {
    inputs = 1,
    outputs = {"hades_laboratory:diamond_blade_sharp"},
    require_usage = {["hades_laboratory:diamond_grinding_wheel"]=true},
    production_time = 120,
  });

