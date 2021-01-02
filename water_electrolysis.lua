------------------------
-- Water Electrolysis --
------------------------
------- Ver 1.0 --------
-----------------------
-- Initial Functions --
-----------------------

laboratory.water_electrolysis = {}

local water_electrolysis = laboratory.water_electrolysis

--------------
-- Formspec --
--------------

local water_electrolysis_fs = "formspec_version[3]" .. "size[12.75,8.5]" ..
                              "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]" ..
                              "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[transformR270]]" ..
                              "list[current_player;main;1.5,3;8,4;]" ..
                              "list[context;input;2,0.25;1,1;]" ..
                              "list[context;water_in;2,1.5;1,1;]" ..
                              "list[context;output;9.75,0.25;2,1;]" ..
                              "list[context;water_out;9.75,1.5;1,1;]" ..
                              "listring[current_player;main]" ..
                              "listring[context;input]" ..
                              "listring[current_player;main]" ..
                              "listring[context;output]" ..
                              "listring[current_player;main]"

local function get_active_water_electrolysis_fs(item_percent)
    local form = {
        "formspec_version[3]", "size[12.75,8.5]",
        "background[-1.25,-1.25;15,10;laboratory_machine_formspec.png]",
        "image[3.6,0.5;5.5,1.5;laboratory_progress_bar.png^[lowpart:" ..
            (item_percent) ..
            ":laboratory_progress_bar_full.png^[transformR270]]",
        "list[current_player;main;1.5,3;8,4;]",
        "list[context;input;2,0.25;1,1;]",
        "list[context;water_in;2,1.5;1,1;]",
        "list[context;output;9.75,0.25;2,1;]",
        "list[context;water_out;9.75,1.5;1,1;]",
        "listring[current_player;main]",
        "listring[context;input]", "listring[current_player;main]",
        "listring[context;output]", "listring[current_player;main]"
    }
    return table.concat(form, "")
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

---------------------
-- Inactive/Active --
---------------------

local LV_EU_demand = 2000;
local MV_EU_demand = 2000;
local HV_EU_demand = 2000;
local LV_EU_demand = 100;

local function activate(pos, meta)
  minetest.get_node_timer(pos):start(1)
  --laboratory.swap_node(pos, "hades_laboratory:water_electrolysis_active");
  meta:set_int("LV_EU_demand", LV_EU_demand)
end

local function deactivate(pos, meta)
  minetest.get_node_timer(pos):stop()
  update_formspec(0, 3, meta)
  laboratory.swap_node(pos, "hades_laboratory:water_electrolysis");
  meta:set_int("LV_EU_demand", 0)
end
local function running(pos, meta)
  laboratory.swap_node(pos, "hades_laboratory:water_electrolysis_active");
  meta:set_int("LV_EU_demand", LV_EU_demand)
end
local function waiting(pos, meta)
  laboratory.swap_node(pos, "hades_laboratory:water_electrolysis");
  meta:set_int("LV_EU_demand", 0)
end
local function no_power(pos, meta)
  laboratory.swap_node(pos, "hades_laboratory:water_electrolysis");
  meta:set_int("LV_EU_demand", LV_EU_demand)
end

---------------
-- Cultivate --
---------------

local function cultivate(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local input_item = inv:get_stack("input", 1)
    --local water_item = inv:get_stack("water", 1)
    local output_oxygen = "hades_laboratory:gas_cylinder_oxygen"
    local output_hydrogen = "hades_laboratory:gas_cylinder_hydrogen"
    
    if (not inv:room_for_item("output", output_oxygen))
        or (not inv:room_for_item("output", output_hydrogen))
        or (input_item:get_count()<2) then
        deactivate(pos, meta);
    else
        input_item:set_count(2)
        inv:remove_item("input", input_item)
        inv:add_item("output", output_oxygen)
        inv:add_item("output", output_hydrogen)
    end
end

--------------------
-- Node callbacks --
--------------------

    -- mssecon action
local mesecons_action =
  {
    effector = {
      action_on = function(pos, node)
        minetest.get_meta(pos):set_int("is_powered", 1);
      end,
      action_off = function(pos, node)
        minetest.get_meta(pos):set_int("is_powered", 0);
      end,
    }
  };

local can_dig = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      return inv:is_empty("input") and inv:is_empty("water_in") and inv:is_empty("output") and inv:is_empty("water_out")
  end

local on_timer = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local stack = inv:get_stack("input", 1)
      local water_in = inv:get_stack("water_in", 1)
      local water_out = inv:get_stack("water_out", 1)
      
      local cultivating_time = meta:get_int("cultivating_time") or 0
      
      -- check for empty gas cylinders
      if (stack:get_count()<2) then
        waiting(pos, meta);
        return true;
      end
      -- check for water
      if (water_in:get_count()==0) then
        waiting(pos, meta);
        return true;
      end
      -- check for free space of water
      if (water_out:get_free_space()==0) then
        waiting(pos, meta);
        return true;
      end
      -- check if node is powered
      local is_powered = meta:get_int("is_powered");
      if (is_powered==0) then
        waiting(pos, meta);
        return true;
      end
      -- check if node is powered LV
      local eu_input = meta:get_int("LV_EU_input")
;
      if (eu_input<LV_EU_demand) then
        no_power(pos, meta);
        return true;
      end
    
      local output_time = 330;
      local output_time = 10;
      cultivating_time = cultivating_time + 1
      if ((cultivating_time%output_time)==0) then
        water_in:take_item(1);
        inv:set_stack("water_in", 1, water_in);
        inv:add_item("water_out", "vessels:steel_bottle");
      end
      if not inv:room_for_item("output", "hades_laboratory:gas_cylinder_oxygen") then return true end
      if not inv:room_for_item("output", "hades_laboratory:gas_cylinder_hydrogen") then return true end
      if cultivating_time % output_time == 0 then 
        cultivate(pos)
        cultivating_time = 0;
      end
      update_formspec(cultivating_time % output_time, output_time, meta)
      meta:set_int("cultivating_time", cultivating_time)

      if (not stack:is_empty()) then
          running(pos, meta);
          return true
      else
          meta:set_int("cultivating_time", 0)
          deactivate(pos, meta)
          return false
      end
  end

local allow_metadata_inventory_put = function(pos, listname, _, stack, player)
      if minetest.is_protected(pos, player:get_player_name()) then
          return 0
      end
      if listname == "input" then
          return (stack:get_name()=="hades_laboratory:gas_cylinder") and
                     stack:get_count() or 0
      end
      if listname == "water_in" then
          return (stack:get_name()=="hades_laboratory:steel_bottle_of_distilled_water") 
                  and stack:get_count() or 0
      end
      return 0
  end

local allow_metadata_inventory_move = function() return 0 end

local allow_metadata_inventory_take = function(pos, listname, _, stack, player)
      if minetest.is_protected(pos, player:get_player_name()) then
          return 0
      end
      
      if (listname=="input") then
        local meta = minetest.get_meta(pos);
        local cultivating_time = meta:get_int("cultivating_time") or 0
        if (cultivating_time>0) then
          local count = stack:get_count();
          if (count > 1) then return count-2; end
          return 0;
        end
      end
      
      return stack:get_count()
  end

local on_metadata_inventory_put = function(pos)
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      local stack = inv:get_stack("input", 1)
      local water_in = inv:get_stack("water_in", 1)
      local cultivating_time = meta:get_int("cultivating_time") or 0
      if not stack:get_name()=="hades_laboratory:gas_cylinder" then
          deactivate(pos, meta)
          return
      end
      if water_in:get_count()==0 then
          deactivate(pos, meta)
          return
      end
      if (not inv:room_for_item("output", "hades_laboratory:gas_cylinder_oxygen"))
         or (not inv:room_for_item("output", "hades_laboratory:gas_cylinder_hydrogen")) then
          --deactivate(pos, meta)
          return
      else
          if cultivating_time < 1 then update_formspec(0, 3, meta) end
          activate(pos, meta)
      end
  end

local on_metadata_inventory_take = function(pos)
      local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
      local inv = meta:get_inventory()
      local stack = inv:get_stack("input", 1)
      local cultivating_time = meta:get_int("cultivating_time") or 0
      if not stack:get_name()=="hades_laboratory:gas_cylinder" then
          deactivate(pos, meta)
          if cultivating_time > 0 then
            meta:set_int("cultivating_time", 0)
          end
          return
      end
      timer:stop()
      if cultivating_time < 1 then update_formspec(0, 3, meta) end
      laboratory.swap_node(pos, "hades_laboratory:water_electrolysis_active");
      timer:start(1)
  end
    
on_blast = function(pos)
      local drops = {}
      default.get_inventory_drops(pos, "input", drops)
      default.get_inventory_drops(pos, "water_in", drops)
      default.get_inventory_drops(pos, "output", drops)
      default.get_inventory_drops(pos, "water_out", drops)
      table.insert(drops, "hades_laboratory:water_electrolysis")
      minetest.remove_node(pos)
      return drops
  end


----------
-- Node --
----------
local def_desc = "Water Electrolysis";

minetest.register_node("hades_laboratory:water_electrolysis", {
    description = def_desc,
    _tt_help = "Connect to power".."\n".."Change water to oxygen and hydrogen..".."\n".."Fill gas cylinders.".."\n",
    tiles = {
        "laboratory_water_electrolysis_top.png",
        "laboratory_water_electrolysis_bottom.png",
        "laboratory_water_electrolysis_side.png",
        "laboratory_water_electrolysis_side.png",
        "laboratory_water_electrolysis_side.png",
        "laboratory_water_electrolysis_front.png"
    },
    paramtype2 = "facedir",
    groups = {cracky = 2, tubedevice = 1, tubedevice_receiver = 1, technic_machine = 1, technic_lv = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = hades_sounds.node_sound_stone_defaults(),
    drawtype = "node",
    
    -- power connect
    connect_sides = {"back"}, 
    
    -- tube connect
    tube = {
      connect_sides = {left = 1, right = 1}, 
    },
    
    -- pipe connect
    pipe_connections = { top = true },
    
    -- mssecon action
    mesecons = mesecons_action,
    
    can_dig = can_dig,

    on_timer = on_timer,

    allow_metadata_inventory_put = allow_metadata_inventory_put,

    allow_metadata_inventory_move = allow_metadata_inventory_move,

    allow_metadata_inventory_take = allow_metadata_inventory_take,
    on_metadata_inventory_put = on_metadata_inventory_put,
    on_metadata_inventory_take = on_metadata_inventory_take,
    
    on_blast = on_blast,

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", water_electrolysis_fs)
        meta:set_string("infotext", def_desc)
        local inv = meta:get_inventory()
        inv:set_size("input", 1)
        inv:set_size("water_in", 1)
        inv:set_size("output", 2)
        inv:set_size("water_out", 1)
    end,
    
    after_place_node = function(pos)
      pipeworks.scan_for_pipe_objects(pos);
      if (not minetest.global_exists("mesecon")) then
        minetest.get_meta(pos):set_int("is_powered", 1);
      end
    end,
})
minetest.register_node("hades_laboratory:water_electrolysis_active", {
    description = def_desc,
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
            length = 1.5
          }
        }
    },
    drop = "hades_laboratory:water_electrolysis",
    paramtype2 = "facedir",
    groups = {cracky = 2, tubedevice = 1, tubedevice_receiver = 1, technic_machine = 1, technic_lv = 1, not_in_creative_inventory = 1},
    connect_sides = {"back", "left", "right"}, 
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = hades_sounds.node_sound_stone_defaults(),
    drawtype = "node",
    
    -- mssecon action
    mesecons = mesecons_action,
    
    can_dig = can_dig,

    on_timer = on_timer,

    allow_metadata_inventory_put = allow_metadata_inventory_put,

    allow_metadata_inventory_move = allow_metadata_inventory_move,

    allow_metadata_inventory_take = allow_metadata_inventory_take,
    on_metadata_inventory_put = on_metadata_inventory_put,
    on_metadata_inventory_take = on_metadata_inventory_take,
  
    on_blast = on_blast,
})

if laboratory.have_technic then
  technic.register_machine("LV", "hades_laboratory:water_electrolysis",        technic.receiver)
  technic.register_machine("LV", "hades_laboratory:water_electrolysis", technic.receiver)
end

