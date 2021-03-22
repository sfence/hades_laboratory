------------------------
-- Water Electrolysis --
------------------------
------- Ver 1.0 --------
-----------------------
-- Initial Functions --
-----------------------

laboratory.water_electrolysis = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:water_electrolysis",
      node_name_active = "hades_laboratory:water_electrolysis_active",
      
      node_description = "Water Electrolysis",
      
      need_water = false,
      power_data = {
        ["LV"] = {
            demand = 2000,
            run_speed = 1,
          },
        ["MV"] = {
            demand = 2000,
            run_speed = 2,
          },
        ["HV"] = {
            demand = 2000,
            run_speed = 3,
          },
        ["no_technic"] = {
            run_speed = 0.25,
          },
      },
    }
  );

local water_electrolysis = laboratory.water_electrolysis;

--------------
-- Formspec --
--------------

--function water_electrolysis:get_formspec(production_percent, consumption_percent)
local function not_used()
  
  local progress = "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[transformR270]]";
  if production_percent then
    progress = "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[lowpart:" ..
            (production_percent) ..
            ":laboratory_progress_bar_full.png^[transformR270]]";
  end
  local formspec =  "formspec_version[3]" .. "size[12.75,8.5]" ..
                    "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]" ..
                    progress..
                    "list[current_player;main;1.5,3;8,4;]" ..
                    "list[context;input;2,0.25;1,1;]" ..
                    "list[context;water_in;2,1.5;1,1;]" ..
                    "list[context;output;9.75,0.25;2,1;]" ..
                    "list[context;water_out;9.75,1.5;1,1;]" ..
                    "listring[current_player;main]" ..
                    "listring[context;input]" ..
                    "listring[current_player;main]" ..
                    "listring[context;output]" ..
                    "listring[current_player;main]"
  return formspec;
end

local function update_formspec(progress, goal, meta)
    local formspec

    if progress > 0 and progress <= goal then
        local item_percent = math.floor(progress / goal * 100)
        formspec = get_active_water_electrolysis_fs(item_percent)
    else
        formspec = water_electrolysis_fs
    end

    meta:set_string("formspec", formspec)
end

----------
-- Node --
----------
local node_def = {
    _tt_help = "Connect to power".."\n".."Change water to oxygen and hydrogen..".."\n".."Fill gas cylinders.".."\n",
    paramtype2 = "facedir",
    groups = {cracky = 2,},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = hades_sounds.node_sound_stone_defaults(),
    drawtype = "node",
  }
local inactive_node = {
    tiles = {
      "laboratory_water_electrolysis_top.png",
      "laboratory_water_electrolysis_bottom.png",
      "laboratory_water_electrolysis_side.png",
      "laboratory_water_electrolysis_side.png",
      "laboratory_water_electrolysis_side.png",
      "laboratory_water_electrolysis_front.png"
    },
  }
local active_node = {
  tiles = {
      "laboratory_water_electrolysis_top.png",
      "laboratory_water_electrolysis_bottom.png",
      "laboratory_water_electrolysis_side.png",
      "laboratory_water_electrolysis_side.png",
      "laboratory_water_electrolysis_side.png",
      {
        image = "laboratory_water_electrolysis_front_active.png",
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

water_electrolysis:register_nodes(node_def, inactive_node, active_node)

-------------------------
-- Recipe Registration --
-------------------------
  
water_electrolysis:recipe_register_usage(
  "hades_laboratory:steel_bottle_of_distilled_water",
  {
    outputs = {"vessels:steel_bottle"},
    consumption_time = 3300,
    production_step_size = 1,
  });

water_electrolysis:recipe_register_input(
  "hades_laboratory:gas_cylinder",
  {
    inputs = 2,
    outputs = {{"hades_laboratory:gas_cylinder_oxygen", "hades_laboratory:gas_cylinder_hydrogen"}},
    production_time = 3300,
    consumption_step_size = 1,
  });

--minetest.log("warning", dump(water_electrolysis))

