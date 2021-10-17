-----------------------
-- Bacterium Changer --
-----------------------
------- Ver 1.0 -------
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.bacterium_changer = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:bacterium_changer",
      node_name_active = "hades_laboratory:bacterium_changer_active",
      
      node_description = S("Bacterium changer"),
      node_help = S("Connect to power 2000 EU (LV).").."\n"..S("Overwrite bacteriums DNA.").."\n"..S("Use bottle of bacteriums and upgraded DNA."),
      
      need_water = false,
      power_data = {
        ["LV"] = {
            demand = 2000,
            run_speed = 1,
          },
        ["no_technic"] = {
            run_speed = 0.25,
          },
      },
    }
  );

local bacterium_changer = laboratory.bacterium_changer;

--------------
-- Formspec --
--------------


--function bacterium_changer:get_formspec(production_percent, consumption_percent)
function not_used()
  local progress = "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[transformR270]]";
  if production_percent then
    progress = "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[lowpart:" ..
            (production_percent) ..
            ":laboratory_progress_bar_full.png^[transformR270]]";
  end
  
  local formspec =  "formspec_version[3]" .. "size[12.75,8.5]" ..
                    "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]" ..
                    progress..
                    "list[current_player;main;0.3,3;10,4;]" ..
                    "list[context;input;2,0.25;1,1;]" ..
                    "list[context;use_in;2,1.5;1,1;]" ..
                    "list[context;output;9.75,0.25;2,2;]" ..
                    "listring[current_player;main]" ..
                    "listring[context;input]" ..
                    "listring[current_player;main]" ..
                    "listring[context;output]" ..
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
    groups = {cracky = 2,},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = hades_sounds.node_sound_stone_defaults(),
    drawtype = "node",
  }
local inactive_node = {
    tiles = {
      "laboratory_bacterium_changer_top.png",
      "laboratory_bacterium_changer_bottom.png",
      "laboratory_bacterium_changer_side.png",
      "laboratory_bacterium_changer_side.png",
      "laboratory_bacterium_changer_side.png",
      "laboratory_bacterium_changer_front.png"
    },
  }
local active_node = {
    tiles = {
      "laboratory_bacterium_changer_top.png",
      "laboratory_bacterium_changer_bottom.png",
      "laboratory_bacterium_changer_side.png",
      "laboratory_bacterium_changer_side.png",
      "laboratory_bacterium_changer_side.png",
      {
        image = "laboratory_bacterium_changer_front_active.png",
        backface_culling = true,
        animation = {
          type = "vertical_frames",
          aspect_w = 16,
          aspect_h = 16,
          length = 1.5,
        }
      },
    },
  }

bacterium_changer:register_nodes(node_def, inactive_node, active_node)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_bacterium_changer", {
    description = S("Changing"),
    width = 1,
    height = 1,
  })

appliances.register_craft_type("laboratory_bacterium_changer_use", {
    description = S("Use for changing"),
    width = 1,
    height = 1,
  })
  
bacterium_changer:recipe_register_usage(
  "hades_laboratory:glass_bottle_of_polymerase",
  {
    outputs = {{"hades_laboratory:grinding_wheel_base", "hades_laboratory:diamond_dust"}},
    consumption_time = 3600,
    production_step_size = 1,
  });

bacterium_changer:recipe_register_input(
  "hades_laboratory:bottle_of_bacteries",
  {
    inputs = 1,
    outputs = {"hades_laboratory:bottle_of_bacteries"},
    production_time = 3600,
    consumption_step_size = 1,
  });

bacterium_changer:register_recipes("laboratory_bacterium_changer", "laboratory_bacterium_changer_use")

