----------------------------------
-- Deoxyribonucleic Cultivator --
----------------------------------
------------ Ver 2.0 -------------
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.deoxyribonucleic_cultivator = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:deoxyribonucleic_cultivator",
      node_name_active = "hades_laboratory:deoxyribonucleic_cultivator_active",
      
      node_description = S("Deoxyribonucleic cultivator"),
    	node_help = S("Connect to power 100 EU (LV) and water.").."\n"..S("Keep process running.").."\n"..S("Cultivate miniature fragments of deoxyribonucletic acid from prepared bones.").."\n"..S("Use glass bottle of polymerases to cultivate miniature fragments of deoxyribonucletic acid.").."\n"..S("Use bones dust for more effectivity."),
      
      output_stack_size = 2,
      
      stoppable_production = false,
      stoppable_consumption = false,
      
      need_water = true,
      
      power_data = {
        ["LV"] = {
            demand = 100,
            run_speed = 1,
          },
        ["no_technic"] = {
            run_speed = 1,
          },
      },
    })

local deoxyribonucleic_cultivator = laboratory.deoxyribonucleic_cultivator

--------------
-- Formspec --
--------------

function deoxyribonucleic_cultivator:get_formspec(meta, production_percent, consumption_percent)
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
        "laboratory_deoxyribonucleic_cultivator_top.png",
        "laboratory_deoxyribonucleic_cultivator_bottom.png",
        "laboratory_deoxyribonucleic_cultivator_side.png",
        "laboratory_deoxyribonucleic_cultivator_side.png",
        "laboratory_deoxyribonucleic_cultivator_side.png",
        "laboratory_deoxyribonucleic_cultivator_front.png"
    },
  }

local node_active = {
    tiles = {
        "laboratory_deoxyribonucleic_cultivator_top.png",
        "laboratory_deoxyribonucleic_cultivator_bottom.png",
        "laboratory_deoxyribonucleic_cultivator_side.png",
        "laboratory_deoxyribonucleic_cultivator_side.png",
        "laboratory_deoxyribonucleic_cultivator_side.png",
        {
          image = "laboratory_deoxyribonucleic_cultivator_front_active.png",
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

deoxyribonucleic_cultivator:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_deoxyribonucleic_cultivator", {
    description = S("Cultivating (by chance)"),
    width = 1,
    height = 1,
  })

appliances.register_craft_type("laboratory_deoxyribonucleic_cultivator_use", {
    description = S("Use for cultivating"),
    width = 1,
    height = 1,
  })

deoxyribonucleic_cultivator:recipe_register_usage(
  "hades_laboratory:glass_bottle_of_polymerase",
  {
    outputs = {"vessels:glass_bottle"},
    consumption_time = 360,
    production_step_size = 1,
  });
deoxyribonucleic_cultivator:recipe_register_usage(
  "hades_laboratory:steel_bottle_of_polymerase",
  {
    outputs = {"vessels:steel_bottle"},
    consumption_time = 360*7, -- more efective when glass bottle of polymerases
    production_step_size = 1,
  });

local crushed_bones_dinosaur_outputs = {};
local crushed_bones_iceage_outputs = {};
local crushed_bones_recent_outputs = {};

local dust_bones_dinosaur_outputs = {};
local dust_bones_iceage_outputs = {};
local dust_bones_recent_outputs = {};

if laboratory.have_paleotest then
  for key, name in pairs(paleotest.dinosaurs) do
    table.insert(crushed_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key);
    table.insert(crushed_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key);
    table.insert(crushed_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key.." 2");
    
    table.insert(dust_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key.." 2");
    table.insert(dust_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key.." 3");
    table.insert(dust_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key.." 4");
  end
  for key, name in pairs(paleotest.iceage_animals) do
    table.insert(crushed_bones_iceage_outputs, "hades_laboratory:dna_fragments_"..key);
    table.insert(crushed_bones_iceage_outputs, "hades_laboratory:dna_fragments_"..key);
    table.insert(crushed_bones_iceage_outputs, "hades_laboratory:dna_fragments_"..key.." 2");
    
    table.insert(dust_bones_iceage_outputs, "hades_laboratory:dna_fragments_"..key.." 2");
    table.insert(dust_bones_iceage_outputs, "hades_laboratory:dna_fragments_"..key.." 3");
    table.insert(dust_bones_iceage_outputs, "hades_laboratory:dna_fragments_"..key.." 4");
  end
  for key, name in pairs(paleotest.water_dinosaurs) do
    table.insert(crushed_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key);
    table.insert(crushed_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key);
    table.insert(crushed_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key.." 2");
    
    table.insert(dust_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key.." 2");
    table.insert(dust_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key.." 3");
    table.insert(dust_bones_dinosaur_outputs, "hades_laboratory:dna_fragments_"..key.." 4");
  end
  
  if laboratory.have_animals then
    for key, name in pairs(paleotest.hades_animals) do
      table.insert(crushed_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key);
      table.insert(crushed_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key);
      table.insert(crushed_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key.." 2");
      
      table.insert(dust_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key.." 2");
      table.insert(dust_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key.." 3");
      table.insert(dust_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key.." 4");
    end
  end
  
  if (laboratory.have_villages) then
    for key, name in pairs(paleotest.hades_villages) do
      table.insert(crushed_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key);
      table.insert(crushed_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key);
      table.insert(crushed_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key.." 2");
      
      table.insert(dust_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key.." 2");
      table.insert(dust_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key.." 3");
      table.insert(dust_bones_recent_outputs, "hades_laboratory:dna_fragments_"..key.." 4");
    end
  end
  
  deoxyribonucleic_cultivator:recipe_register_input(
    "hades_laboratory:crushed_bones_dinosaur",
    {
      inputs = 1,
      outputs = crushed_bones_dinosaur_outputs,
      production_time = 360,
      consumption_step_size = 1,
    });
  deoxyribonucleic_cultivator:recipe_register_input(
    "hades_laboratory:crushed_bones_iceage",
    {
      inputs = 1,
      outputs = crushed_bones_iceage_outputs,
      production_time = 360,
      consumption_step_size = 1,
    });
  deoxyribonucleic_cultivator:recipe_register_input(
    "hades_laboratory:crushed_bones_recent",
    {
      inputs = 1,
      outputs = crushed_bones_recent_outputs,
      production_time = 360,
      consumption_step_size = 1,
    });
  
  deoxyribonucleic_cultivator:recipe_register_input(
    "hades_laboratory:dust_bones_dinosaur",
    {
      inputs = 1,
      outputs = dust_bones_dinosaur_outputs,
      production_time = 360,
      consumption_step_size = 1,
    });
  deoxyribonucleic_cultivator:recipe_register_input(
    "hades_laboratory:dust_bones_iceage",
    {
      inputs = 1,
      outputs = dust_bones_iceage_outputs,
      production_time = 360,
      consumption_step_size = 1,
    });
  deoxyribonucleic_cultivator:recipe_register_input(
    "hades_laboratory:dust_bones_recent",
    {
      inputs = 1,
      outputs = dust_bones_recent_outputs,
      production_time = 360,
      consumption_step_size = 1,
    });
end

deoxyribonucleic_cultivator:register_recipes("laboratory_deoxyribonucleic_cultivator", "laboratory_deoxyribonucleic_cultivator_use")

