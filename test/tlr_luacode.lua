require("tlr")

function get_drink()
	return tlr.get_coffee()
end

d = get_drink()
print("drink: " .. d)
