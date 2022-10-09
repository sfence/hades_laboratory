-------------------------------
-- Biomaterial Triple Filter --
-------------------------------
----------- Ver 2.0 -----------
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.biomaterial_triple_filter = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:biomaterial_triple_filter",
      node_name_active = "hades_laboratory:biomaterial_triple_filter_active",
      
      node_description = S("Biomaterial triple filter"),
    	node_help = S("Connect to power 200 EU (LV) and water.").."\n"..S("Keep only biomaterial in bottle.").."\n"..S("Use biomaterial filters and sterilized glass bottles."),
      
      input_stack_size = 2,
      use_stack_size = 1,
      
      need_supply = true,
    })

local biomaterial_triple_filter = laboratory.biomaterial_triple_filter;

biomaterial_triple_filter:power_data_register(
  {
    ["LV_power"] = {
        demand = 200,
        run_speed = 1,
        disable = {"no_power"},
      },
    ["power_generators_electric_power"] = {
        demand = 200,
        run_speed = 1,
        disable = {"no_power"},
      },
    ["no_power"] = {
        run_speed = 0,
      },
  })
biomaterial_triple_filter:supply_data_register(
  {
    ["water_pipe_liquid"] = {
      },
  })
biomaterial_triple_filter:item_data_register(
  {
    ["tube_item"] = {
      },
  })

--------------
-- Formspec --
--------------

function biomaterial_triple_filter:get_formspec(meta, production_percent, consumption_percent)
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
                    "list[context;"..self.input_stack..";1,0.25;2,1;]" ..
                    "list[context;"..self.use_stack..";2,1.5;1,1;]" ..
                    "list[context;"..self.output_stack..";9.75,0.25;2,2;]" ..
                    "listring[current_player;main]" ..
                    "listring[context;"..self.input_stack.."]" ..
                    "listring[current_player;main]" ..
                    "listring[context;"..self.use_stack.."]" ..
                    "listring[current_player;main]"..
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
        "laboratory_biomaterial_triple_filter_top.png",
        "laboratory_biomaterial_triple_filter_bottom.png",
        "laboratory_biomaterial_triple_filter_side.png",
        "laboratory_biomaterial_triple_filter_side.png",
        "laboratory_biomaterial_triple_filter_side.png",
        "laboratory_biomaterial_triple_filter_front.png"
    },
  }

local node_active = {
    tiles = {
        "laboratory_biomaterial_triple_filter_top.png",
        "laboratory_biomaterial_triple_filter_bottom.png",
        "laboratory_biomaterial_triple_filter_side.png",
        "laboratory_biomaterial_triple_filter_side.png",
        "laboratory_biomaterial_triple_filter_side.png",
        {
          image = "laboratory_biomaterial_triple_filter_front_active.png",
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

biomaterial_triple_filter:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_biomaterial_triple_filter", {
    description = S("Filtering"),
    width = 1,
    height = 1,
  })

appliances.register_craft_type("laboratory_biomaterial_triple_filter_use", {
    description = S("Use for filtering"),
    width = 1,
    height = 1,
  })
  
biomaterial_triple_filter:recipe_register_usage(
  "hades_laboratory:biomaterial_filter_sterilized",
  {
    outputs = {"hades_laboratory:biomaterial_filter_dirty"},
    consumption_time = 90,
    production_step_size = 1,
  });

if laboratory.have_paleotest then
  biomaterial_triple_filter:recipe_register_input(
		"",
    {
    	inputs = {"hades_laboratory:medium_with_bacteries", "hades_laboratory:sterilized_glass_bottle"},
      outputs = {{"hades_laboratory:bottle_of_some_bacteries", "hades_laboratory:growth_medium_remains_2"}},
      production_time = 90,
      consumption_step_size = 1,
    });
  for i=2,4 do
    local output_time = 60+20*i*i;
    biomaterial_triple_filter:recipe_register_input( 
			"",
      {
    		inputs = {"hades_laboratory:medium_with_bacteries_"..i, "hades_laboratory:sterilized_glass_bottle"},
        outputs = {{"hades_laboratory:bottle_of_some_bacteries", "hades_laboratory:growth_medium_remains_"..(i+1)}},
        production_time = output_time,
        consumption_step_size = 90/(output_time/i),
      });
  end
  local output_time = 60+20*25;
  biomaterial_triple_filter:recipe_register_input(
    "",
    {
    	inputs = {"hades_laboratory:medium_with_bacteries_5", "hades_laboratory:sterilized_glass_bottle"},
      outputs = {{"hades_laboratory:bottle_of_some_bacteries", "hades_vessels:glass_bottle"}},
      production_time = output_time,
      consumption_step_size = 90/(output_time/5),
    });
end

biomaterial_triple_filter:register_recipes("laboratory_biomaterial_triple_filter", "laboratory_biomaterial_triple_filter_use")

