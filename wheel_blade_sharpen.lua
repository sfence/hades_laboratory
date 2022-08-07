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
    })

local wheel_blade_sharpen = laboratory.wheel_blade_sharpen

wheel_blade_sharpen:power_data_register(
  {
    ["LV_power"] = {
        demand = 200,
        run_speed = 1,
        disable = {"no_power"},
      },
    ["power_generators_power"] = {
        demand = 200,
        run_speed = 1,
        disable = {"no_power"},
      },
    ["no_power"] = {
        run_speed = 0,
      },
  })
wheel_blade_sharpen:supply_data_register(
  {
    ["water_pipe_liquid"] = {
      },
  })
wheel_blade_sharpen:item_data_register(
  {
    ["tube_item"] = {
      },
  })
wheel_blade_sharpen:item_data_register(
  {
    ["tube_item"] = {
      },
  })

--------------
-- Formspec --
--------------

--------------------
-- Node callbacks --
--------------------

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
    outputs = {{"hades_laboratory:grinding_wheel_base", "technic:stone_dust"}},
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

