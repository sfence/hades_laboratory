-- crafting recipes

if (laboratory.have_paleotest) then
  -- machines
  minetest.register_craft(
      {
        output = "hades_laboratory:sterilizer",
        recipe = {
            {"hades_core:steel_ingot", "glowcrystals:glowcrystal_block", "hades_core:steel_ingot"},
            {"hades_core:gold_ingot", "pipeworks:valve_off_empty", "hades_core:gold_ingot"},
            {"hades_core:steel_ingot", "hades_furniture:sink", "hades_core:steel_ingot"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:distiller",
        recipe = {
            {"hades_core:steel_ingot", "pipeworks:storage_tank_0", "hades_core:steel_ingot"},
            {"hades_core:goldblock", "pipeworks:valve_off_empty", "hades_core:goldblock"},
            {"hades_core:steel_ingot", "pipeworks:mese_filter", "hades_core:steel_ingot"},
          },
      }
    );
  
  minetest.register_craft(
      {
        output = "hades_laboratory:medium_mixer",
        recipe = {
            {"hades_core:steel_ingot", "pipeworks:storage_tank_0", "hades_core:steel_ingot"},
            {"hades_core:bronze_ingot", "pipeworks:valve_off_empty", "hades_core:bronze_ingot"},
            {"hades_core:steel_ingot", "mesecons_hydroturbine:hydro_turbine_off", "hades_core:steel_ingot"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:bacterium_cultivator",
        recipe = {
            {"hades_core:steel_ingot", "glowcrystals:glowglass", "hades_core:steel_ingot"},
            {"hades_core:goldblock", "pipeworks:valve_off_empty", "hades_core:goldblock"},
            {"hades_core:steel_ingot", "pipeworks:storage_tank_0", "hades_core:steel_ingot"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:biomaterial_filter",
        recipe = {
            {"hades_core:steel_ingot", "pipeworks:storage_tank_0", "hades_core:steel_ingot"},
            {"hades_core:goldblock", "pipeworks:valve_off_empty", "hades_core:goldblock"},
            {"hades_core:steel_ingot", "pipeworks:mese_filter", "hades_core:steel_ingot"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:biomaterial_triple_filter",
        recipe = {
            {"hades_core:steelblock", "pipeworks:storage_tank_0", "hades_core:steelblock"},
            {"hades_laboratory:biomaterial_filter", "hades_laboratory:biomaterial_filter", "hades_laboratory:biomaterial_filter"},
            {"hades_core:goldblock", "pipeworks:valve_off_empty", "hades_core:goldblock"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:polymerase_extractor",
        recipe = {
            {"pipeworks:storage_tank_0", "pipeworks:valve_off_empty", "pipeworks:storage_tank_0"},
            {"hades_core:goldblock", "mesecons_pistons:piston_normal_off", "hades_core:goldblock"},
            {"hades_core:steelblock", "pipeworks:mese_filter", "hades_core:steelblock"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:dna_duplicator",
        recipe = {
            {"pipeworks:autocrafter", "pipeworks:storage_tank_0", "pipeworks:autocrafter"},
            {"hades_core:goldblock", "pipeworks:valve_off_empty", "hades_core:goldblock"},
            {"hades_core:steelblock", "pipeworks:storage_tank_0", "hades_core:steelblock"},
          },
      }
    );

  minetest.register_craft(
      {
        output = "hades_laboratory:blade_sharpen",
        recipe = {
            {"hades_core:steel_ingot", "pipeworks:storage_tank_0", "hades_core:steel_ingot"},
            {"hades_core:diamond", "pipeworks:valve_off_empty", "hades_core:diamond"},
            {"hades_core:steel_ingot", "pipeworks:autocrafter", "hades_core:steel_ingot"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:bone_grinder",
        recipe = {
            {"hades_core:steelblock", "pipeworks:storage_tank_0", "hades_core:steelblock"},
            {"mesecons_pistons:piston_normal_off", "pipeworks:valve_off_empty", "mesecons_pistons:piston_normal_off"},
            {"hades_core:steel_ingot", "hades_core:obsidian_block", "hades_core:steel_ingot"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:deoxyribonucleic_cultivator",
        recipe = {
            {"hades_core:steel_ingot", "pipeworks:storage_tank_0", "hades_core:steel_ingot"},
            {"hades_core:goldblock", "pipeworks:valve_off_empty", "hades_core:goldblock"},
            {"hades_core:steel_ingot", "hades_core:mese", "hades_core:steel_ingot"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:deoxyribonucleic_merger",
        recipe = {
            {"hades_core:bronzeblock", "pipeworks:deployer_off", "hades_core:bronzeblock"},
            {"hades_core:goldblock", "hades_laboratory:super_computer", "hades_core:goldblock"},
            {"hades_core:steelblock", "hades_core:mese", "hades_core:steelblock"},
          },
      }
    );
end

if (laboratory.have_paleotest) then
  --  items
  minetest.register_craft(
      {
        output = "hades_laboratory:bottle_of_sugar",
        recipe = {
            {"hades_core:sugar", "hades_core:sugar", "hades_core:sugar"},
            {"hades_core:sugar", "hades_core:sugar", "hades_core:sugar"},
            {"", "hades_laboratory:sterilized_glass_bottle", ""},
          },
      }
    );
  
  minetest.register_craft(
      {
        output = "hades_laboratory:water_filter_dirty",
        recipe = {
            {"hades_core:obsidian_glass", "hades_core:fertile_sand", "hades_core:coal_lump"},
            {"hades_core:gravel", "hades_core:fertile_sand", "hades_core:coal_lump"},
            {"hades_core:obsidian_glass", "hades_core:fertile_sand", "hades_core:coal_lump"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:biomaterial_filter_dirty",
        recipe = {
            {"hades_core:obsidian_glass", "hades_laboratory:sterilized_sand", "hades_laboratory:sterilized_coal_lump"},
            {"hades_core:gold_ingot", "hades_laboratory:sterilized_sand", "hades_laboratory:sterilized_coal_lump"},
            {"hades_core:obsidian_glass", "hades_laboratory:sterilized_sand", "hades_laboratory:sterilized_coal_lump"},
          },
      }
    );
  
  minetest.register_craft(
      {
        type = "fuel",
        recipe = "hades_laboratory:sterilized_coal_lump",
        burntime = 30,
      }
    );
  
  for i=2,5 do
    minetest.register_craft(
        {
          type = "shapeless",
          output = "hades_laboratory:growth_medium_complemented_"..i,
          recipe = { "hades_core:sugar", 
                     "hades_laboratory:growth_medium_remains_"..i,
                  },
        }
      );
  end
  
  minetest.register_craft(
      {
        output = "hades_laboratory:bottle_of_bacteries",
        recipe = {
            {"hades_laboratory:bottle_of_some_bacteries", "hades_laboratory:bottle_of_some_bacteries", "hades_laboratory:bottle_of_some_bacteries"},
            {"hades_laboratory:bottle_of_some_bacteries", "hades_laboratory:bottle_of_some_bacteries", "hades_laboratory:bottle_of_some_bacteries"},
            {"", "hades_laboratory:sterilized_glass_bottle", ""},
          },
        replacements = {{"hades_laboratory:","vessels:glass_bottle"}},
      }
    );
  
  minetest.register_craft(
      {
        output = "hades_laboratory:glass_bottle_of_polymerase",
        recipe = {
            {"hades_laboratory:glass_bottle_of_some_polymerase", "hades_laboratory:glass_bottle_of_some_polymerase", "hades_laboratory:glass_bottle_of_some_polymerase"},
            {"hades_laboratory:glass_bottle_of_some_polymerase", "hades_laboratory:glass_bottle_of_some_polymerase", "hades_laboratory:glass_bottle_of_some_polymerase"},
            {"", "hades_laboratory:sterilized_glass_bottle", ""},
          },
        replacements = {{"hades_laboratory:","vessels:glass_bottle"}},
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:steel_bottle_of_polymerase",
        recipe = {
            {"hades_laboratory:glass_bottle_of_polymerase", "hades_laboratory:glass_bottle_of_polymerase", "hades_laboratory:glass_bottle_of_polymerase"},
            {"hades_laboratory:glass_bottle_of_polymerase", "hades_laboratory:glass_bottle_of_polymerase", "hades_laboratory:glass_bottle_of_polymerase"},
            {"", "hades_laboratory:sterilized_steel_bottle", ""},
          },
        replacements = {{"hades_laboratory:glass_bottle_of_polymerase","vessels:glass_bottle"}},
      }
    );
  
  minetest.register_craft(
      {
        output = "hades_laboratory:steel_blade_blunt",
        recipe = {
            {"hades_core:steel_ingot", "hades_core:steel_ingot", "hades_core:steel_ingot"},
            {"", "hades_core:steel_ingot", ""},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:diamond_blade_sharp",
        recipe = {
            {"hades_core:steel_ingot", "hades_core:steel_ingot", "hades_core:steel_ingot"},
            {"", "hades_core:diamond", ""},
          },
      }
    );
  
  
  minetest.register_craft(
      {
        output = "hades_laboratory:cpu",
        recipe = {
            {"mesecons_microcontroller:microcontroller0000", "mesecons_microcontroller:microcontroller0000", "mesecons_microcontroller:microcontroller0000"},
            {"mesecons_microcontroller:microcontroller0000", "mesecons_microcontroller:microcontroller0000", "mesecons_microcontroller:microcontroller0000"},
            {"mesecons_microcontroller:microcontroller0000", "mesecons_microcontroller:microcontroller0000", "mesecons_microcontroller:microcontroller0000"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:server_cpu",
        recipe = {
            {"hades_laboratory:cpu", "hades_laboratory:cpu", "hades_laboratory:cpu"},
            {"hades_laboratory:cpu", "hades_laboratory:cpu", "hades_laboratory:cpu"},
            {"hades_laboratory:cpu", "hades_laboratory:cpu", "hades_laboratory:cpu"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:server_board_8",
        recipe = {
            {"hades_laboratory:server_cpu", "hades_laboratory:server_cpu", "hades_laboratory:server_cpu"},
            {"hades_laboratory:server_cpu", "hades_core:copper_ingot", "hades_laboratory:server_cpu"},
            {"hades_laboratory:server_cpu", "hades_laboratory:server_cpu", "hades_laboratory:server_cpu"},
          },
      }
    );
  minetest.register_craft(
      {
        output = "hades_laboratory:super_computer",
        recipe = {
            {"hades_laboratory:server_board_8", "hades_laboratory:server_board_8", "hades_laboratory:server_board_8"},
            {"hades_core:goldblock", "hades_core:tinblock", "hades_core:copperblock"},
            {"hades_core:steel_ingot", "hades_materials:plastic_sheeting", "hades_core:steel_ingot"},
          },
      }
    );
end
