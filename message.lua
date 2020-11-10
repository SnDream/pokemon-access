strings = nil
default_strings = {
["warp"] = "Warp",
["signpost"] = "Signpost",
["object"] = "Object",
["pc"] = "PC",
["connection_to"] = "%1 connection",
["north"] = "North",
["south"] = "South",
["east"] = "East",
["west"] = "West",
["map"] = "Map",
["up"] = "Up",
["down"] = "Down",
["left"] = "Left",
["right"] = "Right",
["now_on"] = "Now on",
["not_map"] = "Not on a map.",
["facing"] = "Facing",
["no_path"] = "No path",
["new_name"] = "New name",
["enter_newname"] = "Enter a new name for",
["names_saved"] = "Names saved.",
["no_bar"] = "No bar found.",
["unknown"] = "Unknown",
["end"] = "End",
["enemy_health"] = "Enemy health",
["ready"] = "Ready",
["trashcan"] = "Trash Can",
["use_hm"] = "Use HMs",
["not_use_hm"] = "Do not use HMs",
["tree"] = "Tree",
["on_way"] = "on way",
["closed_door"] = "Closed Door",
["enter_water"] = "Enter in water",
["exit_water"] = "Exit from water",
["statue"] = "Statue",
["cliff"] = "Cliff",
["quiz"] = "Quiz",
}

function init(string_list)
strings = string_list
end

function translate(id, ...)
local message = ""
if strings ~= nil and strings[id] ~= nil then
message = strings[id]
else
message = default_strings[id]
end
for i = 1, select("#", ...) do
message = string.gsub(message, "%%" .. i, select(i, ...))
end
return message
end

return {
translate = translate,
set_strings = init
}
