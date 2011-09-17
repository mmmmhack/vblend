function t2()
	print("t2()")
	fart()
end

function t1()
	t2()
end

function test_pcall()
	print("in test_pcall.lua.test_pcall(): howdy")
	t1()
end

function traceback()
	print(debug.traceback())
end
