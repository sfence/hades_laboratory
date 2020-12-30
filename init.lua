
laboratory = {};

local modpath = minetest.get_modpath(minetest.get_current_modname());

laboratory.have_paleotest = minetest.get_modpath("hades_paleotest")~=nil;
laboratory.have_animals = minetest.get_modpath("hades_animals")~=nil;
laboratory.have_petz = minetest.get_modpath("hades_petz")~=nil;
laboratory.have_villages = minetest.get_modpath("hades_villages")~=nil;
laboratory.have_skeleton = minetest.get_modpath("hades_skeleton")~=nil;

laboratory.have_extraores = minetest.get_modpath("hades_extraores")~=nil;
laboratory.have_technic_worldgen = minetest.get_modpath("hades_technic_worldgen")~=nil;
laboratory.have_technic = minetest.get_modpath("hades_technic")~=nil;

  
dofile(modpath.."/functions.lua");

dofile(modpath.."/sterilizer_cleaner.lua");
dofile(modpath.."/distiller.lua");

if (laboratory.have_paleotest) then  
  -- dna duplicate
  dofile(modpath.."/medium_mixer.lua");
  dofile(modpath.."/bacterium_cultivator.lua");
  dofile(modpath.."/biomaterial_filter.lua");
  dofile(modpath.."/biomaterial_triple_filter.lua");
  dofile(modpath.."/polymerase_extractor.lua");
  dofile(modpath.."/dna_duplicator.lua");
  
  if (laboratory.have_skeleton) then
    dofile(modpath.."/bone_classifier.lua");
    dofile(modpath.."/bone_modeler.lua");
  end
  
  dofile(modpath.."/blade_sharpen.lua");
  dofile(modpath.."/bone_grinder.lua");
  dofile(modpath.."/deoxyribonucleic_cultivator.lua");
  dofile(modpath.."/deoxyribonucleic_merger.lua")
end

if (laboratory.have_extraores) then
  dofile(modpath.."/water_electrolysis.lua")
  --dofile(modpath.."/lump_grinder.lua");
  --dofile(modpath.."/oxygen_furnace.lua")
  --dofile(modpath.."/hydrogen_furnace.lua")
  --dofile(modpath.."/nitrogen_furnace.lua")
end

dofile(modpath.."/craftitems.lua");
dofile(modpath.."/nodes.lua");
dofile(modpath.."/crafting.lua");


