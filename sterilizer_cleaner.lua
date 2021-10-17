--------------------
---- Sterilizer ----
--------------------
------ Ver 2.0 -----
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.sterilizer = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:sterilizer",
      node_name_active = "hades_laboratory:sterilizer_active",
      
      node_description = S("Sterilizer and cleaner"),
    	node_help = S("Connect to power 200 EU (LV) and water.").."\n"..S("Clean and sterilize botte."),
      
      output_stack_size = 1,
      use_stack_size = 0,
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

local sterilizer = laboratory.sterilizer


--------------
-- Formspec --
--------------

function sterilizer:get_formspec(meta, production_percent, consumption_percent)
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
                    "list[context;"..self.input_stack..";2,0.8;1,1;]" ..
                    "list[context;"..self.output_stack..";9.75,0.8;1,1;]" ..
                    "listring[current_player;main]" ..
                    "listring[context;"..self.input_stack.."]" ..
                    "listring[current_player;main]" ..
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
        "laboratory_sterilizer_top.png",
        "laboratory_sterilizer_bottom.png",
        "laboratory_sterilizer_side.png",
        "laboratory_sterilizer_side.png",
        "laboratory_sterilizer_side.png", 
        "laboratory_sterilizer_front.png"
    },
  }

local node_active = {
    tiles = {
        "laboratory_sterilizer_top.png",
        "laboratory_sterilizer_bottom.png",
        "laboratory_sterilizer_side.png",
        "laboratory_sterilizer_side.png",
        "laboratory_sterilizer_side.png", 
        {
          image = "laboratory_sterilizer_front_active.png",
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

sterilizer:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_sterilizer", {
    description = S("Changing"),
    width = 1,
    height = 1,
  })

if (laboratory.have_paleotest) then
  sterilizer:recipe_register_input(
    "vessels:glass_bottle",
    {
      inputs = 1,
      outputs = {"hades_laboratory:sterilized_glass_bottle"},
      production_time = 30,
      consumption_step_size = 1,
    });
  
  sterilizer:recipe_register_input(
    "vessels:steel_bottle",
    {
      inputs = 1,
      outputs = {"hades_laboratory:sterilized_steel_bottle"},
      production_time = 30,
      consumption_step_size = 1,
    });
  
  sterilizer:recipe_register_input(
    "hades_laboratory:water_filter_dirty",
    {
      inputs = 1,
      outputs = {"hades_laboratory:water_filter_sterilized"},
      production_time = 37,
      consumption_step_size = 1,
    });
  
  sterilizer:recipe_register_input(
    "hades_laboratory:biomaterial_filter_dirty",
    {
      inputs = 1,
      outputs = {"hades_laboratory:biomaterial_filter_sterilized"},
      production_time = 45,
      consumption_step_size = 1,
    });
  
  sterilizer:recipe_register_input(
    "hades_core:coal_lump",
    {
      inputs = 1,
      outputs = {"hades_laboratory:sterilized_coal_lump"},
      production_time = 60,
      consumption_step_size = 1,
    });
  
  sterilizer:recipe_register_input(
    "hades_core:fertile_sand",
    {
      inputs = 1,
      outputs = {"hades_laboratory:sterilized_sand"},
      production_time = 60,
      consumption_step_size = 1,
    });
  
  for i=2,5 do
    sterilizer:recipe_register_input(
      "hades_laboratory:growth_medium_remains_"..i,
      {
        inputs = 1,
        outputs = {"hades_laboratory:sterilized_glass_bottle"},
        production_time = 30,
        consumption_step_size = 1,
      });
  end
end

sterilizer:register_recipes("laboratory_sterilizer", "laboratory_sterilizer_use")

