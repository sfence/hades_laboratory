--------------------
--- Medium Mixer ---
--------------------
------ Ver 2.0 -----
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.medium_mixer = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:medium_mixer",
      node_name_active = "hades_laboratory:medium_mixer_active",
      
      node_description = S("Medium mixer"),
			node_help = S("Connect to power 200 EU (LV) and water.").."\n"..S("Mix bottle of something with water."),
      
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

local medium_mixer = laboratory.medium_mixer

--------------
-- Formspec --
--------------

function medium_mixer:get_formspec(meta, production_percent, consumption_percent)
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
        "laboratory_medium_mixer_top.png",
        "laboratory_medium_mixer_bottom.png",
        "laboratory_medium_mixer_side.png",
        "laboratory_medium_mixer_side.png",
        "laboratory_medium_mixer_side.png",
        "laboratory_medium_mixer_front.png"
    },
  }

local node_active = {
    tiles = {
        "laboratory_medium_mixer_top.png",
        "laboratory_medium_mixer_bottom.png",
        "laboratory_medium_mixer_side.png",
        "laboratory_medium_mixer_side.png",
        "laboratory_medium_mixer_side.png",
        {
          image = "laboratory_medium_mixer_front.png",
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

medium_mixer:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_medium_mixer", {
    description = S("Mixing"),
    width = 1,
    height = 1,
  })

if laboratory.have_paleotest then
  medium_mixer:recipe_register_input(
    "hades_laboratory:bottle_of_sugar",
    {
      inputs = 1,
      outputs = {"hades_laboratory:growth_medium"},
      production_time = 66,
      consumption_step_size = 1,
    });
  for i=2,5 do
    medium_mixer:recipe_register_input(
      "hades_laboratory:growth_medium_complemented_"..i,
      {
        inputs = 1,
        outputs = {"hades_laboratory:growth_medium_use_"..i},
        production_time = 33,
        consumption_step_size = 1,
      });
  end
end

medium_mixer:register_recipes("laboratory_medium_mixer", "laboratory_medium_mixer_use")

