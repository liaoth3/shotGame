local file = io.lines("../../res/test.json")
local str = ""
while true do
    local f = file()
    if f then
        str = str .."\n" .. f
    else
        break;
    end
end
return json.decode(str)