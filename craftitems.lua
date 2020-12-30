-- craft items

if (laboratory.have_paleotest) then
  -- items
  minetest.register_craftitem(
      "hades_laboratory:water_filter",
      {
        description = "Filter for water filtration.",
        inventory_image = "laboratory_water_filter.png",
        wield_image = "laboratory_water_filter.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:water_filter_dirty",
      {
        description = "Dirty filter for water filtration.",
        _tt_help = "Can be cleaned in sterilizer.",
        inventory_image = "laboratory_water_filter_dirty.png",
        wield_image = "laboratory_water_filter_dirty.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:biomaterial_filter_sterilized",
      {
        description = "Filter for biomaterial filtration.",
        inventory_image = "laboratory_biomaterial_filter_sterilized.png",
        wield_image = "laboratory_biomaterial_filter_sterilized.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:biomaterial_filter_dirty",
      {
        description = "Dirty filter for biomaterial filtration.",
        _tt_help = "Can be cleaned in stelirizer.",
        inventory_image = "laboratory_biomaterial_filter_dirty.png",
        wield_image = "laboratory_biomaterial_filter_dirty.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:sterilized_coal_lump",
      {
        description = "Scoured and sterilized coal lump.",
        _tt_help = "Use sterilizer to scour and sterilize coal lump.",
        inventory_image = "default_coal_lump.png",
        wield_image = "default_coal_lump.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:sterilized_glass_bottle",
      {
        description = "Washed and sterilized glass bottle",
        _tt_help = "Use sterilizr to wash and sterilize glass bottle.",
        inventory_image = "vessels_glass_bottle_inv.png",
        wield_image = "vessels_glass_bottle.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:sterilized_steel_bottle",
      {
        description = "Washed and sterilized steel bottle",
        _tt_help = "Use sterilizr to wash and sterilize steel bottle.",
        inventory_image = "vessels_steel_bottle_inv.png",
        wield_image = "vessels_steel_bottle.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:steel_bottle_of_distilled_water",
      {
        description = "Steel bottle with distilled water",
        inventory_image = "vessels_steel_bottle_inv.png",
        wield_image = "vessels_steel_bottle.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:bottle_of_sugar",
      {
        description = "Bottle of sugar",
        _tt_help = "Use medium mixer to mix it with water and get growth medium.",
        inventory_image = "laboratory_bottle_of_sugar.png",
        wield_image = "laboratory_bottle_of_sugar.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:growth_medium",
      {
        description = "Growth medium for bacteries cultivation",
        inventory_image = "laboratory_growth_medium.png",
        wield_image = "laboratory_growth_medium.png",
        groups = {}
      }
    );
  for i=2,5 do
    minetest.register_craftitem(
        "hades_laboratory:growth_medium_use_"..i,
        {
          description = "Growth medium for bacteries cultivation",
          _tt_help = i..". use",
          inventory_image = "laboratory_growth_medium.png",
          wield_image = "laboratory_growth_medium.png",
          groups = {}
        }
      );
    minetest.register_craftitem(
        "hades_laboratory:growth_medium_remains_"..i,
        {
          description = "Remains of growth medium for bacteries cultivation",
          _tt_help = "Add sugar to it and mix it or wash up it in sterilizer.".."\n"..i..". use",
          inventory_image = "laboratory_growth_medium_remains.png",
          wield_image = "laboratory_growth_medium_remains.png",
          groups = {}
        }
      );
    minetest.register_craftitem(
        "hades_laboratory:growth_medium_complemented_"..i,
        {
          description = "Complemented growth medium for bacteries cultivation",
          _tt_help = "Put in medium mixer to get useful growth medium.".."\n"..i..". use",
          inventory_image = "laboratory_growth_medium_complemented.png",
          wield_image = "laboratory_growth_medium_complemented.png",
          groups = {}
        }
      );
  end
  minetest.register_craftitem(
      "hades_laboratory:medium_with_bacteries",
      {
        description = "Growth medium with cultivated bacteries",
        inventory_image = "laboratory_medium_with_bacteries.png",
        wield_image = "laboratory_medium_with_bacteries.png",
        groups = {}
      }
    );
  for i=2,5 do
    minetest.register_craftitem(
        "hades_laboratory:medium_with_bacteries_"..i,
        {
          description = "Growth medium with cultivated bacteries",
          _tt_help = i..". use",
          inventory_image = "laboratory_medium_with_bacteries.png",
          wield_image = "laboratory_medium_with_bacteries.png",
          groups = {}
        }
      );
  end
  
  minetest.register_craftitem(
      "hades_laboratory:bottle_of_some_bacteries",
      {
        description = "Glass bottle of some bacteries",
        inventory_image = "laboratory_glass_bottle_of_some_bacteries.png",
        wield_image = "laboratory_glass_bottle_of_some_bacteries.png",
        groups = {}
      }
    );
  for i=2,5 do
    minetest.register_craftitem(
        "hades_laboratory:bottle_of_some_bacteries_"..i,
        {
          description = "Glass bottle of some bacteries",
          _tt_help = i..". use",
          inventory_image = "laboratory_glass_bottle_of_some_bacteries.png",
          wield_image = "laboratory_glass_bottle_of_some_bacteries.png",
          groups = {}
        }
      );
  end
  minetest.register_craftitem(
      "hades_laboratory:bottle_of_bacteries",
      {
        description = "Glass bottle of bacteries",
        inventory_image = "laboratory_glass_bottle_of_bacteries.png",
        wield_image = "laboratory_glass_bottle_of_bacteries.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:glass_bottle_of_some_polymerase",
      {
        description = "Glass bottle of some polymerase",
        inventory_image = "laboratory_glass_bottle_of_some_polymerase.png",
        wield_image = "laboratory_glass_bottle_of_some_polymerase.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:glass_bottle_of_polymerase",
      {
        description = "Glass bottle of polymerase",
        inventory_image = "laboratory_glass_bottle_of_polymerase.png",
        wield_image = "laboratory_glass_bottle_of_polymerase.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:steel_bottle_of_polymerase",
      {
        description = "Steel bottle of polymerase",
        inventory_image = "vessels_steel_bottle_inv.png",
        wield_image = "vessels_steel_bottle.png",
        groups = {}
      }
    );
   
  minetest.register_craftitem(
      "hades_laboratory:steel_blade_blunt",
      {
        description = "Steel hunt blade",
        inventory_image = "laboratory_steel_blade.png",
        wield_image = "laboratory_steel_blade.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:steel_blade_sharp",
      {
        description = "Steel sharp blade",
        inventory_image = "laboratory_steel_blade.png",
        wield_image = "laboratory_steel_blade.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:titan_blade_blunt",
      {
        description = "Titan hunt blade",
        inventory_image = "laboratory_titan_blade.png",
        wield_image = "laboratory_titan_blade.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:titan_blade_sharp",
      {
        description = "Titan sharp blade",
        inventory_image = "laboratory_titan_blade.png",
        wield_image = "laboratory_titan_blade.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:diamond_blade_blunt",
      {
        description = "Diamond hunt blade",
        inventory_image = "laboratory_diamond_blade.png",
        wield_image = "laboratory_diamond_blade.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:diamond_blade_sharp",
      {
        description = "Diamond sharp blade",
        inventory_image = "laboratory_diamond_blade.png",
        wield_image = "laboratory_diamond_blade.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:cpu",
      {
        description = "Processor",
        inventory_image = "laboratory_cpu.png",
        wield_image = "laboratory_cpu.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:server_cpu",
      {
        description = "Server processor",
        inventory_image = "laboratory_cpu.png",
        wield_image = "laboratory_cpu.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:server_board_8",
      {
        description = "Server board with 8 processors",
        inventory_image = "laboratory_server_board_8.png",
        wield_image = "laboratory_server_board_8.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:super_computer",
      {
        description = "Super computer",
        inventory_image = "laboratory_super_computer.png",
        wield_image = "laboratory_super_computer.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:crushed_bones_dinosaur",
      {
        description = "Crushed bones",
        inventory_image = "laboratory_crushed_bones.png",
        wield_image = "laboratory_crushed_bones.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:crushed_bones_iceage",
      {
        description = "Crushed bones",
        inventory_image = "laboratory_crushed_bones.png",
        wield_image = "laboratory_crushed_bones.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:crushed_bones_recent",
      {
        description = "Crushed bones",
        inventory_image = "laboratory_crushed_bones.png",
        wield_image = "laboratory_crushed_bones.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:dust_bones_dinosaur",
      {
        description = "Bones dust",
        inventory_image = "laboratory_crushed_bones.png",
        wield_image = "laboratory_crushed_bones.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:dust_bones_iceage",
      {
        description = "Bones dust",
        inventory_image = "laboratory_crushed_bones.png",
        wield_image = "laboratory_crushed_bones.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:dust_bones_recent",
      {
        description = "Bones dust",
        inventory_image = "laboratory_crushed_bones.png",
        wield_image = "laboratory_crushed_bones.png",
        groups = {}
      }
    );
  
  if laboratory.have_paleotest then
    for key, name in pairs(paleotest.dinosaurs) do
      minetest.register_craftitem(
          "hades_laboratory:dna_fragments_"..key,
          {
            description = name.." DNA fragments",
            inventory_image = "laboratory_dna_fragments.png",
            wield_image = "laboratory_dna_fragments.png",
            groups = {}
          }
        );
    end
    for key, name in pairs(paleotest.iceage_animals) do
      minetest.register_craftitem(
          "hades_laboratory:dna_fragments_"..key,
          {
            description = name.." DNA fragments",
            inventory_image = "laboratory_dna_fragments.png",
            wield_image = "laboratory_dna_fragments.png",
            groups = {}
          }
        );
    end
    for key, name in pairs(paleotest.water_dinosaurs) do
      minetest.register_craftitem(
          "hades_laboratory:dna_fragments_"..key,
          {
            description = name.." DNA fragments",
            inventory_image = "laboratory_dna_fragments.png",
            wield_image = "laboratory_dna_fragments.png",
            groups = {}
          }
        );
    end
  end
  
  if laboratory.have_animals then
    for key, name in pairs(paleotest.hades_animals) do
      minetest.register_craftitem(
          "hades_laboratory:dna_fragments_"..key,
          {
            description = name.." DNA fragments",
            inventory_image = "laboratory_dna_fragments.png",
            wield_image = "laboratory_dna_fragments.png",
            groups = {}
          }
        );
    end
  end
  
  if (laboratory.have_villages) then
    for key, name in pairs(paleotest.hades_villages) do
      minetest.register_craftitem(
          "hades_laboratory:dna_fragments_"..key,
          {
            description = name.." DNA fragments",
            inventory_image = "laboratory_dna_fragments.png",
            wield_image = "laboratory_dna_fragments.png",
            groups = {}
          }
        );
    end
  end
end

if laboratory.have_extraores then
  minetest.register_craftitem(
      "hades_laboratory:gas_cylinder",
      {
        description = "Empty gas cylinder",
        inventory_image = "laboratory_gas_cylinder.png",
        wield_image = "laboratory_gas_cylinder.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:gas_cylinder_oxygen",
      {
        description = "Gas cylinder with oxygen",
        inventory_image = "laboratory_gas_cylinder_oxygen.png",
        wield_image = "laboratory_gas_cylinder_oxygen.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:gas_cylinder_hydrogen",
      {
        description = "Gas cylinder with hydrogen",
        inventory_image = "laboratory_gas_cylinder_hydrogen.png",
        wield_image = "laboratory_gas_cylinder_hydrogen.png",
        groups = {}
      }
    );
end
