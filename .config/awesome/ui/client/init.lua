local gears = require("gears")



client.connect_signal("manage", function (c)
    c.shape = gears.shape.rounded_rect
end)
