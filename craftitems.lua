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
        inventory_image = "laboratory_biomaterial_filter_dirty.png",
        wield_image = "laboratory_biomaterial_filter_dirty.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:sterilized_coal_lump",
      {
        description = "Scoutred and sterilized coal lump.",
        inventory_image = "default_coal_lump.png",
        wield_image = "default_coal_lump.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:sterilized_glass_bottle",
      {
        description = "Sterilized glass bottle",
        inventory_image = "vessels_glass_bottle_inv.png",
        wield_image = "vessels_glass_bottle.png",
        groups = {}
      }
    );
  minetest.register_craftitem(
      "hades_laboratory:sterilized_steel_bottle",
      {
        description = "Sterilized steel bottle",
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
  minetest.register_craftitem(
      "hades_laboratory:medium_with_bacteries",
      {
        description = "Growth medium with cultivated bacteries",
        inventory_image = "laboratory_medium_with_bacteries.png",
        wield_image = "laboratory_medium_with_bacteries.png",
        groups = {}
      }
    );
  
  minetest.register_craftitem(
      "hades_laboratory:bottle_of_some_bacteries",
      {
        description = "Glass bottle of some bacteries",
        inventory_image = "laboratory_glass_bottle_of_some_bacteries.png",
        wield_image = "laboratory_glass_bottle_of_some_bacteries.png",
        groups = {}
      }
    );
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
            description = name.."i DNA fragments",
            inventory_image = "laboratory_dna_fragments.png",
            wield_image = "laboratory_dna_fragments.png",
            groups = {}
          }
        );
    end
  end
end

