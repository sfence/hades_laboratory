

function laboratory.swap_node(pos, name)
  local node = minetest.get_node(pos);
  if (node.name == name) then 
    return
  end
  node.name = name;
  minetest.swap_node(pos, node);
end

local pipeworks_pipe_loaded = {
  ["pipeworks:pipe_1_loaded"] = true,
  ["pipeworks:pipe_2_loaded"] = true,
  ["pipeworks:pipe_3_loaded"] = true,
  ["pipeworks:pipe_4_loaded"] = true,
  ["pipeworks:pipe_5_loaded"] = true,
  ["pipeworks:pipe_6_loaded"] = true,
  ["pipeworks:pipe_7_loaded"] = true,
  ["pipeworks:pipe_8_loaded"] = true,
  ["pipeworks:pipe_9_loaded"] = true,
  ["pipeworks:pipe_10_loaded"] = true,
};
local pipeworks_pipe_with_facedir_loaded = {
  ["pipeworks:valve_on_loaded"] = true,
  ["pipeworks:entry_panel_loaded"] = true,
  ["pipeworks:flow_sensor_loaded"] = true,
  ["pipeworks:straight_pipe_loaded"] = true,
};

function laboratory.is_pipe_over_loaded(pos)
  local node = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z});
  if node then
    if (pipeworks_pipe_loaded[node.name]) then
      return true;
    end
    if (pipeworks_pipe_with_facedir_loaded[node.name]) then
      if (minetest.facedir_to_dir(node.param2).y~=0) then
        return true;
      end
    end
  end
  return false;
end

--[[
local power_data = {
  ["LV"] = {
      demand = 100,
      run_speed = 1,
    },
  ["no_technic"] = {
      run_speed = 1,
    },
}
--]]

if laboratory.have_technic then
  laboratory.is_powered = function (meta, data)
      -- check if node is powered LV
      local eu_data = data["LV"];
      if (eu_data~=nil) then
        local eu_demand = eu_data.demand;
        local eu_input = meta:get_int("LV_EU_input");
        if (eu_input>=eu_demand) then
          return eu_data.run_speed;
        end
      end
      -- check if node is powered MV
      local eu_data = data["MV"];
      if (eu_data~=nil) then
        local eu_demand = eu_data.demand;
        local eu_input = meta:get_int("MV_EU_input");
        if (eu_input>=eu_demand) then
          return eu_data.run_speed;
        end
      end
      -- check if node is powered HV
      local eu_data = data["HV"];
      if (eu_data~=nil) then
        local eu_demand = eu_data.demand;
        local eu_input = meta:get_int("HV_EU_input");
        if (eu_input>=eu_demand) then
          return eu_data.run_speed;
        end
      end
      -- mesecon powered
      local eu_data = data["mesecon"];
      if (eu_data~=nil) then
        local is_powered = meta:get_int("is_powered");
        if (is_powered~=0) then
          return eu_data.run_speed;
        end
      end
      return 0;
    end
else
  laboratory.is_powered = function (meta, data)
      -- mesecon powered
      local is_powered = meta:get_int("is_powered");
      if (is_powered~=0) then
        local eu_data = data["no_technic"];
        if (eu_data~=nil) then
          return eu_data.run_speed;
        end
        return 1;
      end
      return 0;
    end
end

function laboratory.power_need(meta, data)
  local eu_data = data["LV"];
  if (eu_data~=nil) then
    meta:set_int("LV_EU_demand", eu_data.demand)
  end
  local eu_data = data["MV"];
  if (eu_data~=nil) then
    meta:set_int("MV_EU_demand", eu_data.demand)
  end
  local eu_data = data["HV"];
  if (eu_data~=nil) then
    meta:set_int("HV_EU_demand", eu_data.demand)
  end
end
function laboratory.power_idle(meta, data)
  local eu_data = data["LV"];
  if (eu_data~=nil) then
    meta:set_int("LV_EU_demand", 0)
  end
  local eu_data = data["MV"];
  if (eu_data~=nil) then
    meta:set_int("MV_EU_demand", 0)
  end
  local eu_data = data["HV"];
  if (eu_data~=nil) then
    meta:set_int("HV_EU_demand", 0)
  end
end

-- recipe format
--[[
local recipes = {
  inputs = { -- record for every aviable input item
      ["input_item"] = {
          inputs = 1,
          outputs = {"output_item", {"multi_output1", "multi_output2"}}, -- list of one or more outputs, if more outputs, one record is selected
          require_usage = {["item"]=true}, -- nil, if every usage item can be used
          production_time = 160, -- time to product outputs
          consumption_step_size = 1,
        },
    },
  usages = {
      ["usage_item"] = {
          outputs = {"output_item", {"multi_output1", "multi_output2"}},
          consumption_time = 60, -- time to change usage item to outputs
          production_step_size = 1, -- speed of production output
        },
    }
}
--]] 
laboratory.random = PcgRandom(os.time());
-- recipes automatizations

function laboratory.get_empty_recipe()
  return {
      inputs = {},
      usages = {},
    }
end

function laboratory.recipe_register_input(recipes, input_name, input_def)
  recipes.inputs[input_name] = input_def;
end
function laboratory.recipe_register_usage(recipes, usage_name, usage_def)
  recipes.usages[usage_name] = usage_def;
end

function laboratory.recipe_aviable_input(recipes, inventory)
  local input_stack = inventory:get_stack("input", 1)
  local input_name = input_stack:get_name();
  local input = recipes.inputs[input_name];
  if (input==nil) then
    return nil, nil
  end
  if (input_stack:get_count()<input.inputs) then
    return nil, nil
  end
  
  local usage_stack = inventory:get_stack("use_in", 1)
  local usage_name = usage_stack:get_name();
  
  if (input.require_usage~=nil) then
    if (not input.require_usage[usage_name]) then
      return nil, nil
    end
  end
  
  local usage = recipes.usages[usage_name];
  if (usage==nil) then
    return nil, nil
  end
  
  return input, usage;
end

function laboratory.recipe_select_output(outputs)
  local selection = {};
  if (#outputs>1) then
    selection = outputs[laboratory.random.next(1, #outputs)];
  else
    selection = outputs[1];
  end
  
  if type(selection)=="table" then
    return selection;
  end
  
  return {selection};
end

function laboratory.recipe_room_for_output(inventory, output)
  if #output>1 then
    local inv_list = table.copy(inventory:get_list("output"));
    for index = 1,#output do
      if (inventory:room_for_item("output", output[index])~=true) then
        inventory:set_list("output", inv_list);
        return false;
      end
      inventory:add_item("output", output[index]);
    end
    inventory:set_list("output", inv_list);
  else
    if (inventory:room_for_item("output", output[1])~=true) then
      return false;
    end
  end
  
  return true;
end

function laboratory.recipe_output_to_stack(inventory, output)
  for index = 1,#output do
    inventory:add_item("output", output[index]);
  end
end

function laboratory.recipe_input_from_stack(inventory, input)
  local remove_stack = inventory:get_stack("input", 1);
  remove_stack:set_count(input.inputs);
  inventory:remove_item("input", remove_stack);
end

function laboratory.recipe_usage_from_stack(inventory, usage)
  local remove_stack = inventory:get_stack("use_in", 1);
  remove_stack:set_count(1);
  inventory:remove_item("use_in", remove_stack);
end

function laboratory.recipe_step_size(step_size)
  local int_step_size = math.floor(step_size);
  local rem_step_size = (step_size - int_step_size)*100;
  if (rem_step_size>=1) then
    if (rem_step_size<laboratory.random:next(0,99)) then
      int_step_size = int_step_size + 1;
    end
  end
  return int_step_size;
end

function laboratory.recipe_inventory_can_put(pos, listname, index, stack, player, recipes)
  if player then
    if minetest.is_protected(pos, player:get_player_name()) then
      return 0
    end
  end
  
  if listname == "input" then
    return recipes.inputs[stack:get_name()] and
                 stack:get_count() or 0
  end
  if listname == "use_in" then
    return recipes.usages[stack:get_name()] and
                 stack:get_count() or 0
  end
  return 0
end

function laboratory.recipe_inventory_can_take(pos, listname, index, stack, player, recipes)
  if player then
    if minetest.is_protected(pos, player:get_player_name()) then
      return 0
    end
  end
  local count = stack:get_count();
  local meta = minetest.get_meta(pos);
  if (listname=="input") then
    local production_time = meta:get_int("production_time") or 0
    if (production_time>0) then
      local input = recipes.inputs[stack:get_name()];
      if input then
        count = count-input.inputs;
        if (count<0) then count = 0; end
      else
        minetest.log("error", "Input item missing in recipes list.")
      end
    end
  elseif (listname=="use_in") then
    local consumption_time = meta:get_int("consumption_time") or 0
    if (consumption_time>0) then
      count = count - 1;
      if (count<0) then count = 0; end;
    end
  end
  
  return count;
end

-- tube can insert
function laboratory.tube_can_insert (pos, node, stack, direction, owner, recipes)
  if recipes then
    local input = recipes.inputs[stack:get_name()];
    if input then
      return laboratory.recipe_inventory_can_put(pos, "input", 1, stack, nil, recipes);
    end
    local usage = recipes.usages[stack:get_name()];
    if usage then
      return laboratory.recipe_inventory_can_put(pos, "use_in", 1, stack, nil, recipes);
    end
  end
  return false;
end
function laboratory.tube_insert (pos, node, stack, direction, owner, recipes)
  if recipes then
    local meta = minetest.get_meta(pos);
    local inv = meta:get_inventory();
    
    local input = recipes.inputs[stack:get_name()];
    if input then
      return inv:add_item("input", stack);
    end
    local usages = recipes.usages[stack:get_name()];
    if usages then
      return inv:add_item("use_in", stack);
    end
  end
  
  minetest.log("error", "Unexpected call of tube_insert function. Stack "..stack:to_string().." cannot be added to inventory.")
  
  return stack;
end
