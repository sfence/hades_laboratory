--------------------------
-- Polymerase Extractor --
--------------------------
--------- Ver 2.0 --------
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.polymerase_extractor = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:polymerase_extractor",
      node_name_active = "hades_laboratory:polymerase_extractor_active",
      
      node_description = "Polymerase extractor",
    	node_help = S("Connect to power 200 EU (LV).").."\n"..S("Extract polymerase from bacteries and filter it for better result."),
      
      output_stack_size = 2,
      
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

local polymerase_extractor = laboratory.polymerase_extractor


--------------
-- Formspec --
--------------

function polymerase_extractor:get_formspec(meta, production_percent, consumption_percent)
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
        "laboratory_polymerase_extractor_top.png",
        "laboratory_polymerase_extractor_bottom.png",
        "laboratory_polymerase_extractor_side.png",
        "laboratory_polymerase_extractor_side.png",
        "laboratory_polymerase_extractor_side.png",
        "laboratory_polymerase_extractor_front.png"
    },
  }

local node_active = {
    tiles = {
        "laboratory_polymerase_extractor_top.png",
        "laboratory_polymerase_extractor_bottom.png",
        "laboratory_polymerase_extractor_side.png",
        "laboratory_polymerase_extractor_side.png",
        "laboratory_polymerase_extractor_side.png",
        {
          image = "laboratory_polymerase_extractor_front.png",
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

polymerase_extractor:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_polymerase_extractor", {
    description = S("Extracting"),
    width = 1,
    height = 1,
  })

appliances.register_craft_type("laboratory_polymerase_extractor_use", {
    description = S("Use for extracting"),
    width = 1,
    height = 1,
  })

polymerase_extractor:recipe_register_usage(
  "hades_laboratory:biomaterial_filter_sterilized",
  {
    outputs = {"hades_laboratory:biomaterial_filter_dirty"},
    consumption_time = 90,
    production_step_size = 1,
  });

if laboratory.have_paleotest then
  polymerase_extractor:recipe_register_input(
    "hades_laboratory:bottle_of_bacteries",
    {
      inputs = 1,
      outputs = {"hades_laboratory:glass_bottle_of_some_polymerase"},
      production_time = 180,
      consumption_step_size = 1,
    });
end

polymerase_extractor:register_recipes("laboratory_polymerase_extractor", "laboratory_polymerase_extractor_use")

