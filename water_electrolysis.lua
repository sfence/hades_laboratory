------------------------
-- Water Electrolysis --
------------------------
------- Ver 1.0 --------
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.water_electrolysis = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:water_electrolysis",
      node_name_active = "hades_laboratory:water_electrolysis_active",
      
      node_description = S("Water Electrolysis"),
      node_help = S("Connect to power 2000 EU (LV, MV, HV)").."\n"..S("Change water to oxygen and hydrogen..").."\n"..S("Fill gas cylinders.").."\n",
    }
  );

local water_electrolysis = laboratory.water_electrolysis;

water_electrolysis:power_data_register(
  {
    ["LV_power"] = {
        demand = 10000,
        run_speed = 1,
        disable = {"no_power"},
      },
    ["MV_power"] = {
        demand = 10000,
        run_speed = 2,
        disable = {"no_power"},
      },
    ["HV_power"] = {
        demand = 10000,
        run_speed = 3,
        disable = {"no_power"},
      },
    ["power_generators_power"] = {
        demand = 150,
        run_speed = 0.01,
        disable = {"no_power"},
      },
    ["no_power"] = {
        run_speed = 0,
      },
  })
water_electrolysis:item_data_register(
  {
    ["tube_item"] = {
      },
  })

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
                    "list[current_player;main;0.3,3;10,4;]" ..
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

appliances.register_craft_type("laboratory_water_electrolysis", {
    description = S("Decomposing"),
    width = 1,
    height = 1,
  })

appliances.register_craft_type("laboratory_water_electrolysis_use", {
    description = S("Use for decomposing"),
    width = 1,
    height = 1,
  })
  
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

water_electrolysis:register_recipes("laboratory_water_electrolysis", "laboratory_water_electrolysis_use")

