--------------------
-- DNA Duplicator --
--------------------
----- Ver 2.0 ------
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.dna_duplicator = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:dna_duplicator",
      node_name_active = "hades_laboratory:dna_duplicator_active",
      
      node_description = S("DNA duplicator"),
    	node_help = S("Connect to power 100 EU (LV) and water.").."\n"..S("Keep process running.").."\n"..S("Use glass bottle of polymerases to duplicate DNA."),
      
      output_stack_size = 2,
      
      stoppable_production = false,
    })

local dna_duplicator = laboratory.dna_duplicator


dna_duplicator:power_data_register(
  {
    ["LV_power"] = {
        demand = 100,
        run_speed = 1,
        disable = {"no_power"},
      },
    ["power_generators_electric_power"] = {
        demand = 100,
        run_speed = 1,
        disable = {"no_power"},
      },
    ["no_power"] = {
        run_speed = 0,
      },
  })
dna_duplicator:supply_data_register(
  {
    ["water_pipe_liquid"] = {
      },
  })
dna_duplicator:item_data_register(
  {
    ["tube_item"] = {
      },
  })

--------------
-- Formspec --
--------------

function dna_duplicator:get_formspec(meta, production_percent, consumption_percent)
  local progress = "image[3.6,0.5;5.5,0.95;appliances_production_progress_bar.png^[transformR270]]";
  if production_percent then
    progress = "image[3.6,0.5;5.5,0.95;appliances_production_progress_bar.png^[lowpart:" ..
            (production_percent) ..
            ":appliances_production_progress_bar_full.png^[transformR270]]";
  end
  if consumption_percent then
    progress = progress.."image[3.6,1.35;5.5,0.95;appliances_consumption_progress_bar.png^[lowpart:" ..
            (consumption_percent) ..
            ":appliances_consumption_progress_bar_full.png^[transformR270]]";
  else
    progress = progress.."image[3.6,1.35;5.5,0.95;appliances_consumption_progress_bar.png^[transformR270]]";
  end
  
  local formspec =  "formspec_version[3]" .. "size[12.75,8.5]" ..
                    "background[-1.25,-1.25;15,10;appliances_appliance_formspec.png]" ..
                    progress..
                    "list[current_player;main;0.3,3;10,4;]" ..
                    "list[context;"..self.input_stack..";2,0.25;1,1;]" ..
                    "list[context;"..self.use_stack..";2,1.5;1,1;]" ..
                    "list[context;"..self.output_stack..";9.75,0.25;1,2;]" ..
                    "listring[current_player;main]" ..
                    "listring[context;"..self.input_stack.."]" ..
                    "listring[current_player;main]" ..
                    "listring[context;"..self.use_stack.."]" ..
                    "listring[current_player;main]"..
                    "listring[context;"..self.output_stack.."]" ..
                    "listring[current_player;main]";
  return formspec;
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
        "laboratory_dna_duplicator_top.png",
        "laboratory_dna_duplicator_bottom.png",
        "laboratory_dna_duplicator_side.png",
        "laboratory_dna_duplicator_side.png",
        "laboratory_dna_duplicator_side.png",
        "laboratory_dna_duplicator_front.png"
    },
  }

local node_active = {
    tiles = {
        "laboratory_dna_duplicator_top.png",
        "laboratory_dna_duplicator_bottom.png",
        "laboratory_dna_duplicator_side.png",
        "laboratory_dna_duplicator_side.png",
        "laboratory_dna_duplicator_side.png",
        {
          image = "laboratory_dna_duplicator_front.png",
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

dna_duplicator:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_dna_duplicator", {
    description = S("Duplicating"),
    width = 1,
    height = 1,
  })

appliances.register_craft_type("laboratory_dna_duplicator_use", {
    description = S("Use for duplicating"),
    width = 1,
    height = 1,
  })

dna_duplicator:recipe_register_usage(
  "hades_laboratory:glass_bottle_of_polymerase",
  {
    outputs = {"hades_vessels:glass_bottle"},
    consumption_time = 150,
    production_step_size = 1,
  });
dna_duplicator:recipe_register_usage(
  "hades_laboratory:steel_bottle_of_polymerase",
  {
    outputs = {"hades_vessels:steel_bottle"},
    consumption_time = 150*7, -- more efective then glass bottle of polymerases
    production_step_size = 1,
  });

if laboratory.have_paleotest then
  for key, name in pairs(paleotest.dinosaurs) do
    dna_duplicator:recipe_register_input(
      "hades_paleotest:dna_"..key,
      {
        inputs = 1,
        outputs = {"hades_paleotest:dna_"..key.." 2"},
        production_time = 300,
        consumption_step_size = 1,
      });
  end
  for key, name in pairs(paleotest.iceage_animals) do
    dna_duplicator:recipe_register_input(
      "hades_paleotest:dna_"..key,
      {
        inputs = 1,
        outputs = {"hades_paleotest:dna_"..key.." 2"},
        production_time = 300,
        consumption_step_size = 1,
      });
  end
  for key, name in pairs(paleotest.water_dinosaurs) do
    dna_duplicator:recipe_register_input(
      "hades_paleotest:dna_"..key,
      {
        inputs = 1,
        outputs = {"hades_paleotest:dna_"..key.." 2"},
        production_time = 300,
        consumption_step_size = 1,
      });
  end
end

for key, fauna in pairs(paleotest.hades_recent_fauna) do
end

dna_duplicator:register_recipes("laboratory_dna_duplicator", "laboratory_dna_duplicator_use")

