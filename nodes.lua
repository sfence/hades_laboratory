
if laboratory.have_paleotest then
  minetest.register_node(
      "hades_laboratory:sterilized_sand",
      {
        description = "Scoured and sterilized sand.",
        tiles = {"laboratory_sterilized_sand.png"},
        groups = {crumbly=3, falling_node=1, sand=1, porous=1},
        sounds = hades_sounds.node_sound_sand_defaults(),
      }
    );
end
  
