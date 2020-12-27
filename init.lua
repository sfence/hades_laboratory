
laboratory = {};

local modpath = minetest.get_modpath(minetest.get_current_modname());

laboratory.have_paleotest = minetest.get_modpath("hades_paleotest")~=nil;
laboratory.have_animals = minetest.get_modpath("hades_animals")~=nil;
laboratory.have_petz = minetest.get_modpath("hades_petz")~=nil;
laboratory.have_villages = minetest.get_modpath("hades_villages")~=nil;
laboratory.have_skeleton = minetest.get_modpath("hades_skeleton")~=nil;
laboratory.have_archeology = minetest.get_modpath("hades_archeology")~=nil;


if (laboratory.have_paleotest) then
  dofile(modpath.."/sterilizer_cleaner.lua");
  dofile(modpath.."/distiller.lua");
  
  -- dna duplicate
  dofile(modpath.."/medium_mixer.lua");
  dofile(modpath.."/bacterium_cultivator.lua");
  dofile(modpath.."/biomaterial_filter.lua");
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
  
  if (laboratory.have_archeology) then
    dofile(modpath.."/dna_rewriter.lua");
  end
end

dofile(modpath.."/craftitems.lua");
dofile(modpath.."/nodes.lua");
dofile(modpath.."/crafting.lua");


