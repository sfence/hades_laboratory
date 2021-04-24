--------------------------
-- Bacterium Cultivator --
--------------------------
--------- Ver 2.0 --------
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.bacterium_cultivator = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:bacterium_cultivator",
      node_name_active = "hades_laboratory:bacterium_cultivator_active",
      
      node_description = S("Bacterium cultivator"),
    	node_help = S("Connect to power 50 EU (LV)").."\n"..S("Cultivate bacteries in growth medium"),
      
      output_stack_size = 1,
      use_stack_size = 0,
      have_usage = false,
      
      power_data = {
        ["LV"] = {
            demand = 50,
            run_speed = 1,
          },
        ["no_technic"] = {
            run_speed = 1,
          },
      },
    })

local bacterium_cultivator = laboratory.bacterium_cultivator;

--------------
-- Formspec --
--------------

function bacterium_cultivator:get_formspec(meta, production_percent, consumption_percent)
  local progress = "image[3.6,0.9;5.5,0.95;appliances_production_progress_bar.png^[transformR270]]";
  if production_percent then
    progress = "image[3.6,0.9;5.5,0.95;appliances_production_progress_bar.png^[lowpart:" ..
            (production_percent) ..
            ":appliances_production_progress_bar_full.png^[transformR270]]";
  end
  
  
  
  local formspec =  "formspec_version[3]" .. "size[12.75,8.5]" ..
                    "background[-1.25,-1.25;15,10;appliances_appliance_formspec.png]" ..
                    progress..
                    "list[current_player;main;1.5,3;8,4;]" ..
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
      "laboratory_bacterium_cultivator_top.png",
      "laboratory_bacterium_cultivator_bottom.png",
      "laboratory_bacterium_cultivator_side.png",
      "laboratory_bacterium_cultivator_side.png",
      "laboratory_bacterium_cultivator_side.png",
      "laboratory_bacterium_cultivator_front.png"
    },
  }

local node_active = {
    tiles = {
      "laboratory_bacterium_cultivator_top.png",
      "laboratory_bacterium_cultivator_bottom.png",
      "laboratory_bacterium_cultivator_side.png",
      "laboratory_bacterium_cultivator_side.png",
      "laboratory_bacterium_cultivator_side.png",
      {
        image = "laboratory_bacterium_cultivator_front_active.png",
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

bacterium_cultivator:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_bacterium_cultivator", {
    description = S("Cultivating"),
    width = 1,
    height = 1,
  })

if laboratory.have_paleotest then

  bacterium_cultivator:recipe_register_input(
    "hades_laboratory:growth_medium",
    {
      inputs = 1,
      outputs = {"hades_laboratory:medium_with_bacteries"},
      production_time = 180,
      consumption_step_size = 1,
    });
  for i=2,5 do
    bacterium_cultivator:recipe_register_input(
      "hades_laboratory:growth_medium_use_"..i,
      {
        inputs = 1,
        outputs = {"hades_laboratory:medium_with_bacteries_"..i},
        production_time = 180,
        consumption_step_size = 1,
      });
  end
end

bacterium_cultivator:register_recipes("laboratory_bacterium_cultivator", "laboratory_bacterium_cultivator_use")

