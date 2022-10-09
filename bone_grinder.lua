------------------
-- Bone Grinder --
------------------
---- Ver 2.0 -----
-----------------------
-- Initial Functions --
-----------------------
local S = laboratory.translator;

laboratory.bone_grinder = appliances.appliance:new(
    {
      node_name_inactive = "hades_laboratory:bone_grinder",
      node_name_active = "hades_laboratory:bone_grinder_active",
      
      node_description = S("Bone grinder"),
    	node_help = S("Connect to power 200 EU (LV) and water.").."\n"..S("Grind bones to small pieces.").."\n"..S("Use blades to grind known bones, to prepare them for cultivation."),
      
      output_stack_size = 2,
    })

local bone_grinder = laboratory.bone_grinder

bone_grinder:power_data_register(
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
bone_grinder:supply_data_register(
  {
    ["water_pipe_liquid"] = {
      },
  })
bone_grinder:item_data_register(
  {
    ["tube_item"] = {
      },
  })

--------------
-- Formspec --
--------------

function bone_grinder:get_formspec(meta, production_percent, consumption_percent)
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
        "laboratory_bone_grinder_top.png",
        "laboratory_bone_grinder_bottom.png",
        "laboratory_bone_grinder_side.png",
        "laboratory_bone_grinder_side.png",
        "laboratory_bone_grinder_side.png",
        "laboratory_bone_grinder_front.png"
    },
  }

local node_active = {
    tiles = {
        "laboratory_bone_grinder_top.png",
        "laboratory_bone_grinder_bottom.png",
        "laboratory_bone_grinder_side.png",
        "laboratory_bone_grinder_side.png",
        "laboratory_bone_grinder_side.png",
        {
          image = "laboratory_bone_grinder_front_active.png",
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

bone_grinder:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("laboratory_bone_grinder", {
    description = S("Grinding"),
    width = 1,
    height = 1,
  })

appliances.register_craft_type("laboratory_bone_grinder_use", {
    description = S("Use for grinding"),
    width = 1,
    height = 1,
  })
  
bone_grinder:recipe_register_usage(
  "hades_laboratory:steel_blade_sharp",
  {
    outputs = {"hades_laboratory:steel_blade_blunt"},
    consumption_time = 45,
    production_step_size = 1, -- 4 per grind bone
  });
bone_grinder:recipe_register_usage(
  "hades_laboratory:titan_blade_sharp",
  {
    outputs = {"hades_laboratory:titan_blade_blunt"},
    consumption_time = 24,
    production_step_size = 2.5, -- 3 per grind bone
  });
bone_grinder:recipe_register_usage(
  "hades_laboratory:tungsten_blade_sharp",
  {
    outputs = {"hades_laboratory:tungsten_blade_blunt"},
    consumption_time = 30,
    production_step_size = 3, -- 2 per grind bone
  });
bone_grinder:recipe_register_usage(
  "hades_laboratory:diamond_blade_sharp",
  {
    outputs = {"hades_laboratory:diamond_blade_blunt"},
    consumption_time = 45,
    production_step_size = 4, -- 1 per grind bone
  });

if laboratory.have_paleotest then
  bone_grinder:recipe_register_input(
    "hades_paleotest:bones_dinosaur",
    {
      inputs = 1,
      outputs = {"hades_laboratory:crushed_bones_dinosaur"},
      production_time = 180,
      consumption_step_size = 1,
    });
  bone_grinder:recipe_register_input(
    "hades_paleotest:bones_iceage",
    {
      inputs = 1,
      outputs = {"hades_laboratory:crushed_bones_iceage"},
      production_time = 180,
      consumption_step_size = 1,
    });
  bone_grinder:recipe_register_input(
    "hades_paleotest:bones_recent",
    {
      inputs = 1,
      outputs = {"hades_laboratory:crushed_bones_recent"},
      production_time = 180,
      consumption_step_size = 1,
    });
  
  bone_grinder:recipe_register_input(
    "hades_laboratory:crushed_bones_dinosaur",
    {
      inputs = 1,
      outputs = {"hades_laboratory:dust_bones_dinosaur"},
      production_time = 180,
      consumption_step_size = 1,
    });
  bone_grinder:recipe_register_input(
    "hades_laboratory:crushed_bones_iceage",
    {
      inputs = 1,
      outputs = {"hades_laboratory:dust_bones_iceage"},
      production_time = 180,
      consumption_step_size = 1,
    });
  bone_grinder:recipe_register_input(
    "hades_laboratory:crushed_bones_recent",
    {
      inputs = 1,
      outputs = {"hades_laboratory:dust_bones_recent"},
      production_time = 180,
      consumption_step_size = 1,
    });
end

bone_grinder:register_recipes("laboratory_bone_grinder", "laboratory_bone_grinder_use")

