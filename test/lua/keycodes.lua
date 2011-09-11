-- keycodes.lua
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M

-- TODO: replace these manual glfw key defs with an automated implementation
GLFW_RELEASE = 0
GLFW_PRESS = 1
GLFW_KEY_SPECIAL 		= 256
GLFW_KEY_ESC 				= GLFW_KEY_SPECIAL +  1
GLFW_KEY_LSHIFT 		= GLFW_KEY_SPECIAL + 31
GLFW_KEY_RSHIFT 		= GLFW_KEY_SPECIAL + 32
GLFW_KEY_TAB				= GLFW_KEY_SPECIAL + 37
GLFW_KEY_ENTER      = GLFW_KEY_SPECIAL + 38
GLFW_KEY_BACKSPACE  = GLFW_KEY_SPECIAL + 39

ASC_BS = 8
ASC_TAB = 9
ASC_RET = 13
ASC_ESC = 27

-- maps glfw key code to ascii char
shifted_keycode = {
	['`']='~', ['1']='!', ['2']='@', ['3']='#', ['4']='$', ['5']='%', ['6']='^', ['7']='&', ['8']='*', ['9']='(', ['0']=')', ['-']='_', ['=']='+', 
	['Q']='Q', ['W']='W', ['E']='E', ['R']='R', ['T']='T', ['Y']='Y', ['U']='U', ['I']='I', ['O']='O', ['P']='P', ['[']='{', [']']='}', ['\\']='|',
	['A']='A', ['S']='S', ['D']='D', ['F']='F', ['G']='G', ['H']='H', ['J']='J', ['K']='K', ['L']='L', [';']=':', ["'"]='"', 
	['Z']='Z', ['X']='X', ['C']='C', ['V']='V', ['B']='B', ['N']='N', ['M']='M', [',']='<', ['.']='>', ['/']='?',
	[' ']=' ',
}

unshifted_keycode = {
	['`']='`', ['1']='1', ['2']='2', ['3']='3', ['4']='4', ['5']='5', ['6']='6', ['7']='7', ['8']='8', ['9']='9', ['0']='0', ['-']='-', ['=']='=',
	['Q']='q', ['W']='w', ['E']='e', ['R']='r', ['T']='t', ['Y']='y', ['U']='u', ['I']='i', ['O']='o', ['P']='p', ['[']='[', [']']=']', ['\\']='\\',
	['A']='a', ['S']='s', ['D']='d', ['F']='f', ['G']='g', ['H']='h', ['J']='j', ['K']='k', ['L']='l', [';']=';', ["'"]="'", 
	['Z']='z', ['X']='x', ['C']='c', ['V']='v', ['B']='b', ['N']='n', ['M']='m', [',']=',', ['.']='.', ['/']='/',
	[' ']=' ',
	[GLFW_KEY_ESC] = ASC_ESC,
	[GLFW_KEY_BACKSPACE] = ASC_BS,
	[GLFW_KEY_TAB] = ASC_TAB,
	[GLFW_KEY_ENTER] = ASC_RET,
}


