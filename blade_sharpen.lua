-------------------
-- Blade Sharpen --
-------------------
----- Ver 2.0 -----
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.blade_sharpen = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:blade_sharpen",
      node_name_active = "hades_laboratory:blade_sharpen_active",
      
      node_description = S("Blade sharpen"),
    	node_help = S("Connect to power 200 EU (LV) and water.").."\n"..S("Make blunt metal blades sharp again."),
      
      output_stack_size = 1,
      have_usage = false,
    })

local blade_sharpen = laboratory.blade_sharpen

blade_sharpen:power_data_register(
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
blade_sharpen:supply_data_register(
  {
    ["water_pipe_liquid"] = {
      },
  })
blade_sharpen:item_data_register(
  {
    ["tube_item"] = {
      },
  })

--------------
-- Formspec --
--------------

function blade_sharpen:get_formspec(meta, production_percent, consumption_percent)
  local progress = "image[3.6,0.9;5.5,0.95;appliances_production_progress_bar.png^[transformR270]]";
  if production_percent then
    progress = "image[3.6,0.9;5.5,0.95;appliances_production_progress_bar.png^[lowpart:" ..
            (production_percent) ..
            ":appliances_production_progress_bar_full.png^[transformR270]]";
  end
  
  
  
  local formspec =  "formspec_version[3]" .. "size[12.75,8.5]" ..
                    "background[-1.25,-1.25;15,10;appliances_appliance_formspec.png]" ..
                    progress..
                    "list[current_player;main;0.3,3;10,4;]" ..
                    "list[context;"..self.input_stack..";2,0.8;1,1;]"..
                    "list[context;"..self.output_stack..";9.75,0.8;1,1;]" ..
                    "listring[current_player;main]" ..
                    "listring[context;"..self.input_stack.."]" ..
                    "listring[current_player;main]" ..
                    "listring[context;"..self.output_stack.."]" ..
                    "listring[current_player;main]";
  return formspec;
end

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
        "laboratory_blade_sharpen_top.png",
        "laboratory_blade_sharpen_bottom.png",
        "laboratory_blade_sharpen_side.png",
        "laboratory_blade_sharpen_side.png",
        "laboratory_blade_sharpen_side.png",
        "laboratory_blade_sharpen_front.png"
    }
  }

local node_active = {
    tiles = {
        "laboratory_blade_sharpen_top.png",
        "laboratory_blade_sharpen_bottom.png",
        "laboratory_blade_sharpen_side.png",
        "laboratory_blade_sharpen_side.png",
        "laboratory_blade_sharpen_side.png",
        {
          image = "laboratory_blade_sharpen_front_active.png",
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

blade_sharpen:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_blade_sharpen", {
    description = S("Sharping"),
    width = 1,
    height = 1,
  })
  
blade_sharpen:recipe_register_input(
  "hades_laboratory:steel_blade_blunt",
  {
    inputs = 1,
    outputs = {"hades_laboratory:steel_blade_sharp"},
    production_time = 60,
    consumption_step_size = 1,
  });
blade_sharpen:recipe_register_input(
  "hades_laboratory:titan_blade_blunt",
  {
    inputs = 1,
    outputs = {"hades_laboratory:titan_blade_sharp"},
    production_time = 120,
    consumption_step_size = 1,
  });
blade_sharpen:recipe_register_input(
  "hades_laboratory:tungsten_blade_blunt",
  {
    inputs = 1,
    outputs = {"hades_laboratory:tungsten_blade_sharp"},
    production_time = 180,
    consumption_step_size = 1,
  });

blade_sharpen:register_recipes("laboratory_blade_sharpen", "laboratory_blade_sharpen_use")

