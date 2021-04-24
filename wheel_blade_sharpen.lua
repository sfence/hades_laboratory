-------------------------
-- Wheel Blade Sharpen --
-------------------------
-------- Ver 2.0 --------
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.wheel_blade_sharpen = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:wheel_blade_sharpen",
      node_name_active = "hades_laboratory:wheel_blade_sharpen_active",
      
      node_description = S("Wheel blade sharpen"),
    	node_help = S("Connect to power 200 EU (LV) and water.").."\n"..S("Make blunt metal blades sharp again."),
      
      output_stack_size = 1,
      have_usage = false,
      
      need_water = true,
      
      power_data = {
        ["LV"] = {
            demand = 200,
            run_speed = 1,
          },
        ["no_technic"] = {
            run_speed = 1,
          },
      },
    })

local wheel_blade_sharpen = laboratory.wheel_blade_sharpen

--------------
-- Formspec --
--------------

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
    local consumption_step_size = laboratory.recipe_step_size(speed*use_input.consumption_step_size);
    
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

local node_def = {
  paramtype2 = "facedir",
  groups = {cracky = 2},
  legacy_facedir_simple = true,
  is_ground_content = false,
  sounds = hades_sounds.node_sound_stone_defaults(),
  drawtype = "node",
}

local node_inactive = {
    tiles = {
        "laboratory_wheel_blade_sharpen_top.png",
        "laboratory_wheel_blade_sharpen_bottom.png",
        "laboratory_wheel_blade_sharpen_side.png",
        "laboratory_wheel_blade_sharpen_side.png",
        "laboratory_wheel_blade_sharpen_side.png",
        "laboratory_wheel_blade_sharpen_front.png"
    },
  }

local node_active = {
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
  }

wheel_blade_sharpen:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_wheel_blade_sharpen", {
    description = S("Sharping"),
    width = 1,
    height = 1,
  })

appliances.register_craft_type("laboratory_wheel_blade_sharpen_use", {
    description = S("Use for sharping"),
    width = 1,
    height = 1,
  })
  
wheel_blade_sharpen:recipe_register_usage(
  "hades_laboratory:sand_grinding_wheel",
  {
    outputs = {{"hades_laboratory:grinding_wheel_base", "hades_laboratory:diamond_dust"}},
    consumption_time = 60,
    production_step_size = 1,
  });
wheel_blade_sharpen:recipe_register_usage(
  "hades_laboratory:diamond_grinding_wheel",
  {
    outputs = {{"hades_laboratory:grinding_wheel_base", "hades_laboratory:diamond_dust"}},
    consumption_time = 120,
    production_step_size = 2,
  });

wheel_blade_sharpen:recipe_register_input(
  "hades_laboratory:steel_blade_blunt",
  {
    inputs = 1,
    outputs = {"hades_laboratory:steel_blade_sharp"},
    production_time = 30,
    consumption_step_size = 1,
  });
wheel_blade_sharpen:recipe_register_input(
  "hades_laboratory:titan_blade_blunt",
  {
    inputs = 1,
    outputs = {"hades_laboratory:titan_blade_sharp"},
    production_time = 60,
    consumption_step_size = 1,
  });
wheel_blade_sharpen:recipe_register_input(
  "hades_laboratory:tungsten_blade_blunt",
  {
    inputs = 1,
    outputs = {"hades_laboratory:tungsten_blade_sharp"},
    production_time = 90,
    consumption_step_size = 1,
  });
wheel_blade_sharpen:recipe_register_input(
  "hades_laboratory:diamond_blade_blunt",
  {
    inputs = 1,
    outputs = {"hades_laboratory:diamond_blade_sharp"},
    require_usage = {["hades_laboratory:diamond_grinding_wheel"]=true},
    production_time = 120,
    consumption_step_size = 1,
  });

wheel_blade_sharpen:register_recipes("laboratory_wheel_blade_sharpen", "laboratory_wheel_blade_sharpen_use")

