------------------------------
-- Deoxyribonucleic Merger --
------------------------------
----------- Ver 1.0 ----------
-----------------------
-- Initial Functions --
-----------------------

laboratory.deoxyribonucleic_merger = {}

local deoxyribonucleic_merger = laboratory.deoxyribonucleic_merger

deoxyribonucleic_merger.recipes = {}

function deoxyribonucleic_merger.register_recipe(input, output)
    deoxyribonucleic_merger.recipes[input] = output
end

--------------
-- Formspec --
--------------

local deoxyribonucleic_merger_fs = "formspec_version[3]" .. "size[12.75,8.5]" ..
                              "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]" ..
                              "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[transformR270]]" ..
                              "list[current_player;main;1.5,3;8,4;]" ..
                              "list[context;input;2,0.25;1,1;]" ..
                              "list[context;water_in;2,1.5;1,1;]" ..
                              "list[context;output;9.75,0.25;1,1;]" ..
                              "list[context;water_out;9.75,1.5;1,1;]" ..
                              "listring[current_player;main]" ..
                              "listring[context;input]" ..
                              "listring[current_player;main]" ..
                              "listring[context;output]" ..
                              "listring[current_player;main]"

local function get_active_deoxyribonucleic_merger_fs(item_percent, output_name)
    local form = {
        "formspec_version[3]", "size[12.75,8.5]",
        "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]",
        "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[lowpart:" ..
            (item_percent) ..
            ":laboratory_progress_bar_full.png^[transformR270]]",
        "list[current_player;main;1.5,3;8,4;]",
        "list[context;input;2,0.25;1,1;]",
        "list[context;water_in;2,1.5;1,1;]",
        "list[context;output;9.75,0.25;1,1;]",
        "list[context;water_out;9.75,1.5;1,1;]",
        "label[0.5,2.75;"..minetest.colorize("#000000", "Calculating "..output_name).."]",
        "listring[current_player;main]",
        "listring[context;input]", "listring[current_player;main]",
        "listring[context;output]", "listring[current_player;main]"
    }
    return table.concat(form, "")
end

local function update_formspec(progress, goal, label, meta)
    local formspec

    if progress > 0 and progress <= goal then
        local item_percent = math.floor(progress / goal * 100)
        formspec = get_active_deoxyribonucleic_merger_fs(item_percent, label)
    else
        formspec = deoxyribonucleic_merger_fs
    end

    meta:set_string("formspec", formspec)
end

---------------
-- Cultivate --
---------------

local function cultivate(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local input_item = inv:get_stack("input", 1)
    --local water_item = inv:get_stack("water", 1)
    local output_item = deoxyribonucleic_merger.recipes[input_item:get_name()].output
    input_item:set_count(1)

    if not deoxyribonucleic_merger.recipes[input_item:get_name()] or
        not inv:room_for_item("output", output_item) then
        minetest.get_node_timer(pos):stop()
        update_formspec(0, 3, meta)
    else
        inv:remove_item("input", input_item)
        inv:add_item("output", output_item)
    end
end

----------
-- Node --
----------

local def_desc = "Deoxyribonucleic Merger";

minetest.register_node("hades_laboratory:deoxyribonucleic_merger", {
    description = def_desc,
    _tt_help = "Connect to power".."\n".."Calculate how to join DNA fragments together and do it".."\n".."Use steel bottles of distilated water.",
    tiles = {
        "laboratory_deoxyribonucleic_merger_top.png",
        "laboratory_deoxyribonucleic_merger_bottom.png",
        "laboratory_deoxyribonucleic_merger_side.png",
        "laboratory_deoxyribonucleic_merger_side.png",
        "laboratory_deoxyribonucleic_merger_side.png",
        "laboratory_deoxyribonucleic_merger_front.png"
    },
    paramtype2 = "facedir",
    groups = {cracky = 2, tubedevice = 1, tubedevice_receiver = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = hades_sounds.node_sound_stone_defaults(),
    drawtype = "node",
    
    -- mssecon action
    mesecons = {
      effector = {
        action_on = function(pos, node)
          minetest.get_meta(pos):set_int("is_powered", 1);
        end,
        action_off = function(pos, node)
          minetest.get_meta(pos):set_int("is_powered", 0);
        end,
      },
    },
    
    can_dig = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        return inv:is_empty("input") and inv:is_empty("water_in") and inv:is_empty("output") and inv:is_empty("water_out")
    end,

    on_timer = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        local water_in = inv:get_stack("water_in", 1)
        local water_out = inv:get_stack("water_out", 1)
        if not deoxyribonucleic_merger.recipes[stack:get_name()] then return false end
        
        local cultivating_time = meta:get_int("cultivating_time") or 0
        local cultivating_input = meta:get_string("cultivating_input") or ""
        
        -- check good input
        if (cultivating_input~="") then 
          if (stack:get_name()~=cultivating_input) then
            return true;
          end
        end
        -- check if node is powered
        local is_powered = minetest.get_meta(pos):get_int("is_powered");
        if (is_powered==0) then
          return true;
        end
        -- check for water
        if (water_in:get_count()==0) then
          return true;
        end
        -- check for free space of water
        if (water_out:get_free_space()==0) then
          return true;
        end
      
        local recipe = deoxyribonucleic_merger.recipes[stack:get_name()]
        local output_item = recipe.output;
        local output_time = 3600;
        --local output_time = 27;
        cultivating_time = cultivating_time + 1
        if ((cultivating_time%10)==0) then
          water_in:take_item(1);
          inv:set_stack("water_in", 1, water_in);
          inv:add_item("water_out", ItemStack("vessels:steel_bottle"));
        end
        if ((cultivating_time%(output_time/9))==0) and ((cultivating_time % output_time)~=0) then
          local input_item = inv:get_stack("input", 1)
          input_item:set_count(1)
          inv:remove_item("input", input_item)
        end
        if not inv:room_for_item("output", output_item) then return true end
        if cultivating_time % output_time == 0 then
          cultivate(pos)
          meta:set_string("cultivating_input", "")
        end
        update_formspec(cultivating_time % output_time, output_time, recipe.label, meta)
        meta:set_int("cultivating_time", cultivating_time)
        meta:set_string("cultivating_input", stack:get_name())

        if (not stack:is_empty()) then
            return true
        else
            meta:set_int("cultivating_time", 0)
            meta:set_string("cultivating_input", "")
            update_formspec(0, 3, "", meta)
            return false
        end
    end,

    allow_metadata_inventory_put = function(pos, listname, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end
        if listname == "input" then
            local meta = minetest.get_meta(pos);
            local cultivating_input = meta:get_string("cultivating_input") or "";
            if (cultivating_input~="") and (cultivating_input~=stack:get_name()) then return 0; end
            return deoxyribonucleic_merger.recipes[stack:get_name()] and
                       stack:get_count() or 0
        end
        if listname == "water_in" then
            return stack:get_name()=="hades_laboratory:steel_bottle_of_distilled_water" and
                       stack:get_count() or 0
        end
        return 0
    end,

    allow_metadata_inventory_move = function() return 0 end,

    allow_metadata_inventory_take = function(pos, listname, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end
        
        if (listname=="input") then
          local meta = minetest.get_meta(pos);
          local cultivating_time = meta:get_int("cultivating_time") or 0
          if (cultivating_time>0) then
            local count = stack:get_count();
            if (count > 0) then return count-1; end
            return 0;
          end
        end
        
        return stack:get_count()
    end,

    on_metadata_inventory_put = function(pos)
        local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        local water_in = inv:get_stack("water_in", 1)
        local output_item = deoxyribonucleic_merger.recipes[stack:get_name()]
        local cultivating_time = meta:get_int("cultivating_time") or 0
        if not deoxyribonucleic_merger.recipes[stack:get_name()] then
            timer:stop()
            meta:set_string("formspec", deoxyribonucleic_merger_fs)
            return
        end
        if water_in:get_count()==0 then
            timer:stop()
            meta:set_string("formspec", deoxyribonucleic_merger_fs)
            return
        end
        if not inv:room_for_item("output", output_item) then
            --timer:stop()
            return
        else
            if cultivating_time < 1 then update_formspec(0, 3, "", meta) end
            timer:start(1)
        end
    end,

    on_metadata_inventory_take = function(pos)
        local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        local cultivating_time = meta:get_int("cultivating_time") or 0
        if not deoxyribonucleic_merger.recipes[stack:get_name()] then
            timer:stop()
            meta:set_string("formspec", deoxyribonucleic_merger_fs)
            if cultivating_time > 0 then
                meta:set_int("cultivating_time", 0)
                meta:set_string("cultivating_input", "")
            end
            return
        end
        timer:stop()
        if cultivating_time < 1 then update_formspec(0, 3, meta) end
        timer:start(1)
    end,

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", deoxyribonucleic_merger_fs)
        meta:set_string("infotext", def_desc)
        local inv = meta:get_inventory()
        inv:set_size("input", 1)
        inv:set_size("water_in", 1)
        inv:set_size("output", 1)
        inv:set_size("water_out", 1)
    end,
    on_blast = function(pos)
        local drops = {}
        default.get_inventory_drops(pos, "input", drops)
        default.get_inventory_drops(pos, "output", drops)
        table.insert(drops, "hades_laboratory:steel_bottle_of_distilled_water")
        minetest.remove_node(pos)
        return drops
    end,
    
    after_place_node = function(pos)
      pipeworks.scan_for_pipe_objects(pos);
      if (not minetest.global_exists("mesecon")) then
        minetest.get_meta(pos):set_int("is_powered", 1);
      end
    end,
})

-------------------------
-- Recipe Registration --
-------------------------

if laboratory.have_paleotest then
  for key, name in pairs(paleotest.dinosaurs) do
      deoxyribonucleic_merger.register_recipe("hades_laboratory:dna_fragments_"..key,
                                 {output="hades_paleotest:dna_part_"..key,
                                  label="DNA part of "..name});
  end
  for key, name in pairs(paleotest.iceage_animals) do
      deoxyribonucleic_merger.register_recipe("hades_laboratory:dna_fragments_"..key,
                                 {output="hades_paleotest:dna_part_"..key,
                                  label="DNA part of "..name});
  end
  for key, name in pairs(paleotest.water_dinosaurs) do
      deoxyribonucleic_merger.register_recipe("hades_laboratory:dna_fragments_"..key,
                                 {output="hades_paleotest:dna_part_"..key,
                                  label="DNA part of "..name});
  end
  
  if laboratory.have_animals then
    for key, name in pairs(paleotest.hades_animals) do
      deoxyribonucleic_merger.register_recipe("hades_laboratory:dna_fragments_"..key,
                                 {output="hades_paleotest:dna_part_"..key,
                                  label="DNA part of "..name});
    end
  end
  
  if (laboratory.have_villages) then
    for key, name in pairs(paleotest.hades_villages) do
      deoxyribonucleic_merger.register_recipe("hades_laboratory:dna_fragments_"..key,
                                 {output="hades_paleotest:dna_part_"..key,
                                  label="DNA part of "..name});
    end
  end
end


