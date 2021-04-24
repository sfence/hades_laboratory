------------------------------
-- Deoxyribonucleic Merger --
------------------------------
----------- Ver 2.0 ----------
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.deoxyribonucleic_merger = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:deoxyribonucleic_merger",
      node_name_active = "hades_laboratory:deoxyribonucleic_merger_active",
      
      node_description = S("Deoxyribonucleic merger"),
      node_help = S("Connect to power 1500 EU (LV)").."\n"..S("Calculate how to join DNA fragments together and do it.").."\n"..S("Use steel bottles of distilated water."),
      
      output_stack_size = 2,
      
      power_data = {
        ["LV"] = {
            demand = 3000,
            run_speed = 1,
          },
        ["no_technic"] = {
            run_speed = 1,
          },
      },
    })


local deoxyribonucleic_merger = laboratory.deoxyribonucleic_merger

--------------
-- Formspec --
--------------

function deoxyribonucleic_merger:get_formspec(meta, production_percent, consumption_percent)
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
                    "list[current_player;main;1.5,3;8,4;]" ..
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
        "laboratory_deoxyribonucleic_merger_top.png",
        "laboratory_deoxyribonucleic_merger_bottom.png",
        "laboratory_deoxyribonucleic_merger_side.png",
        "laboratory_deoxyribonucleic_merger_side.png",
        "laboratory_deoxyribonucleic_merger_side.png",
        "laboratory_deoxyribonucleic_merger_front.png"
    },
  }

local node_active = {
    tiles = {
        "laboratory_deoxyribonucleic_merger_top.png",
        "laboratory_deoxyribonucleic_merger_bottom.png",
        "laboratory_deoxyribonucleic_merger_side.png",
        "laboratory_deoxyribonucleic_merger_side.png",
        "laboratory_deoxyribonucleic_merger_side.png",
        {
          image = "laboratory_deoxyribonucleic_merger_front_active.png",
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

deoxyribonucleic_merger:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_deoxyribonucleic_merger", {
    description = S("Merging"),
    width = 1,
    height = 1,
  })

appliances.register_craft_type("laboratory_deoxyribonucleic_merger_use", {
    description = S("Use for merging"),
    width = 1,
    height = 1,
  })

deoxyribonucleic_merger:recipe_register_usage(
  "hades_laboratory:steel_bottle_of_distilled_water",
  {
    outputs = {"vessels:steel_bottle"},
    consumption_time = 10,
    production_step_size = 1,
  });
deoxyribonucleic_merger:recipe_register_usage(
  "hades_laboratory:steel_bottle_of_polymerase",
  {
    outputs = {"vessels:steel_bottle"},
    consumption_time = 60,
    production_step_size = 10,
  });


if laboratory.have_paleotest then
  for key, name in pairs(paleotest.dinosaurs) do
    deoxyribonucleic_merger:recipe_register_input(
      "hades_laboratory:dna_fragments_"..key,
      {
        inputs = 9,
        outputs = {"hades_paleotest:dna_part_"..key},
        production_time = 3600,
        consumption_step_size = 1,
      });
  end
  for key, name in pairs(paleotest.iceage_animals) do
    deoxyribonucleic_merger:recipe_register_input(
      "hades_laboratory:dna_fragments_"..key,
      {
        inputs = 9,
        outputs = {"hades_paleotest:dna_part_"..key},
        production_time = 3600,
        consumption_step_size = 1,
      });
  end
  for key, name in pairs(paleotest.water_dinosaurs) do
    deoxyribonucleic_merger:recipe_register_input(
      "hades_laboratory:dna_fragments_"..key,
      {
        inputs = 9,
        outputs = {"hades_paleotest:dna_part_"..key},
        production_time = 3600,
        consumption_step_size = 1,
      });
  end
  
  if laboratory.have_animals then
    for key, name in pairs(paleotest.hades_animals) do
      deoxyribonucleic_merger:recipe_register_input(
        "hades_laboratory:dna_fragments_"..key,
        {
          inputs = 9,
          outputs = {"hades_paleotest:dna_part_"..key},
          production_time = 3600,
          consumption_step_size = 1,
        });
    end
  end
  
  if (laboratory.have_villages) then
    for key, name in pairs(paleotest.hades_villages) do
      deoxyribonucleic_merger:recipe_register_input(
        "hades_laboratory:dna_fragments_"..key,
        {
          inputs = 9,
          outputs = {"hades_paleotest:dna_part_"..key},
          production_time = 3600,
          consumption_step_size = 1,
        });
    end
  end
end

deoxyribonucleic_merger:register_recipes("laboratory_deoxyribonucleic_merger", "laboratory_deoxyribonucleic_merger_use")

