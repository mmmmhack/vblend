-- cursor.lua

cursor = {
	['saved_pos'] = {[0]=0, [1]=0},
	['inc'] = 
		function (ncols)
			row, col = tflua.get_cursor();
			tflua.set_cursor(row, col + ncols);
		end
	['save_pos'] = 
		function (pos)
			
			
		end
}
