



				   
local craftMode = true -- Mettre à true pour activer le mode craft, dans ce cas au retour en banque le bot craftera tous les alliages qu'il peut fabriquer avec les ressources dont il dispose avant de
					   -- repartir récolter.
local minACraft = 0 -- Mettre le nombre d'alliage minimal à craft pour le mode craft, 0 pour le plus possible

					   
					   
-- /!\ NE PAS TOUCHER A CE QUI SUIT /!\

OPEN_BAGS = true

local currentAlliage = {}
local qtAlliage = 0


local step = ""
local path = 1

GATHER = {17, 53, 55, 37, 54, 52, 114, 24, 26, 25, 113, 400}
MAX_PODS = 101

local currentEnergy = character:energyPoints()
local formerEnergy = currentEnergy



local recipes = {
	
	["280"] = {
	
		{ name = "dolomite", ressourceId = 7033, requiredQuantity = 10, pods = 5 },
		{ name = "or", ressourceId = 313, requiredQuantity = 10, pods = 5 },
		{ name = "bauxite", ressourceId = 446, requiredQuantity = 10, pods = 5 },
		{ name = "argent", ressourceId = 350, requiredQuantity = 10, pods = 5 },
		{ name = "étain", ressourceId = 444, requiredQuantity = 10, pods = 5 },
		{ name = "silicate", ressourceId = 7032, requiredQuantity = 10, pods = 5 },
		{ name = "cendrepierre", ressourceId = 27621, requiredQuantity = 10, pods = 5 },
		{ name = "kobalte", ressourceId = 443, requiredQuantity = 10, pods = 5 }
		
	},
	
	["260"] = {
	
		{ name = "or", ressourceId = 313, requiredQuantity = 10, pods = 5 },
		{ name = "bauxite", ressourceId = 446, requiredQuantity = 10, pods = 5 },
		{ name = "argent", ressourceId = 350, requiredQuantity = 10, pods = 5 },
		{ name = "étain", ressourceId = 444, requiredQuantity = 10, pods = 5 },
		{ name = "silicate", ressourceId = 7032, requiredQuantity = 10, pods = 5 },
		{ name = "manganèse", ressourceId = 445, requiredQuantity = 10, pods = 5 },
		{ name = "kobalte", ressourceId = 443, requiredQuantity = 10, pods = 5 }
		
	},
	
	["240"] = {
	
		{ name = "bauxite", ressourceId = 446, requiredQuantity = 10, pods = 5 },
		{ name = "argent", ressourceId = 350, requiredQuantity = 10, pods = 5 },
		{ name = "étain", ressourceId = 444, requiredQuantity = 10, pods = 5 },
		{ name = "silicate", ressourceId = 7032, requiredQuantity = 10, pods = 5 },
		{ name = "manganèse", ressourceId = 445, requiredQuantity = 10, pods = 5 },
		{ name = "kobalte", ressourceId = 443, requiredQuantity = 10, pods = 5 }
		
	},
	
	["220"] = {
	
		{ name = "argent", ressourceId = 350, requiredQuantity = 10, pods = 5 },
		{ name = "étain", ressourceId = 444, requiredQuantity = 10, pods = 5 },
		{ name = "silicate", ressourceId = 7032, requiredQuantity = 10, pods = 5 },
		{ name = "manganèse", ressourceId = 445, requiredQuantity = 10, pods = 5 },
		{ name = "kobalte", ressourceId = 443, requiredQuantity = 10, pods = 5 },
		{ name = "bronze", ressourceId = 442, requiredQuantity = 10, pods = 5 }
		
	},
	
	["200"] = {
	
		{ name = "étain", ressourceId = 444, requiredQuantity = 10, pods = 5 },
		{ name = "silicate", ressourceId = 7032, requiredQuantity = 10, pods = 5 },
		{ name = "manganèse", ressourceId = 445, requiredQuantity = 10, pods = 5 },
		{ name = "kobalte", ressourceId = 443, requiredQuantity = 10, pods = 5 },
		{ name = "bronze", ressourceId = 442, requiredQuantity = 10, pods = 5 }
		
	},
	
	["160"] = {
	
		{ name = "manganèse", ressourceId = 445, requiredQuantity = 10, pods = 5 },
		{ name = "kobalte", ressourceId = 443, requiredQuantity = 10, pods = 5 },
		{ name = "bronze", ressourceId = 442, requiredQuantity = 10, pods = 5 },
		{ name = "cuivre", ressourceId = 441, requiredQuantity = 10, pods = 5 },
		
	},
	
	["120"] = {
	
		{ name = "kobalte", ressourceId = 443, requiredQuantity = 10, pods = 5 },
		{ name = "bronze", ressourceId = 442, requiredQuantity = 10, pods = 5 },
		{ name = "cuivre", ressourceId = 441, requiredQuantity = 10, pods = 5 },
		{ name = "fer", ressourceId = 312, requiredQuantity = 10, pods = 5 }
		
	},
	
	["100"] = {
	
		{ name = "bronze", ressourceId = 442, requiredQuantity = 10, pods = 5 },
		{ name = "cuivre", ressourceId = 441, requiredQuantity = 10, pods = 5 },
		{ name = "fer", ressourceId = 312, requiredQuantity = 10, pods = 5 }
		
	},
	
	["80"] = {
	
		{ name = "cuivre", ressourceId = 441, requiredQuantity = 10, pods = 5 },
		{ name = "fer", ressourceId = 312, requiredQuantity = 10, pods = 5 }
		
	},
	
	["40"] = {
	
		{ name = "frêne", ressourceId = 303, requiredQuantity = 10, pods = 5 },
		{ name = "fer", ressourceId = 312, requiredQuantity = 6, pods = 5 }
	
	}


}


function calculateQuantity(recipe)
	local requiredPods = 0
	for i, ressource in pairs(recipe) do
		requiredPods = requiredPods + ressource.requiredQuantity*ressource.pods
	end
	local quantityToCraft = math.floor((inventory:podsMax() - inventory:pods())/requiredPods)
	for i, ressource in pairs(recipe) do
		local temp = math.floor(exchange:storageItemQuantity(ressource.ressourceId)/ressource.requiredQuantity)
		if temp < quantityToCraft then
			quantityToCraft = temp
		end	
	end
	return quantityToCraft
end


function checkBank()
	step = ""
	npc:npcBank(-1)
	exchange:putAllItems()
	if craftMode then
		for craft, recipe in pairs(recipes) do
			local quantityToCraft = calculateQuantity(recipe)
			if quantityToCraft > minACraft and job:level(24) < tonumber(craft) then
				for i, ressource in pairs(recipe) do
					exchange:getItem(ressource.ressourceId, quantityToCraft*ressource.requiredQuantity)
				end
				currentAlliage = recipe
				qtAlliage = quantityToCraft
				step = "craft"
				break
			end	
		end
	end
	--if step ~= "craft" and exchange:storageItemQuantity(548) > 0 then
		--exchange:getItem(548, 2)
	--end		
	global:leaveDialog()
	map:door(518)
end


local a2 = true

function aiguillage2()
	if a2 then
		a2 = false
		map:changeMap("top")
	else
		a2 = true
		map:changeMap("bottom")
	end
end

local chemins = {
	
	["fer"] = {
	
		{ 	{ map = 162791424, path = "zaap(156240386)" },
			{ map = 156240386, path = "right" }, 
			{ map = "-2,-42", path = "right" }, 
			{ map = 156241410, custom = function() map:door(149) end }, -- Entrée Mine du Lac de Cania
			{ map = 133431302, gather = true, door = "179" }, 
			{ map = 133431300, gather = true, door = "165" },
			{ map = 133431298, gather = true, door = "432" }, 
			{ map = 133432322, gather = true, door = "348" }, 
			{ map = 133433346, gather = true, door = "177" },  
			{ map = 133433344, gather = true, custom = function() path = 2 map:door(515) end } },
			
		{ 	{ map = 133432578, gather = true, custom = function() path = 3 map:door(423) end },
			{ map = 133432320, gather = true, door = "134" }, 
			{ map = 133432322, gather = true, door = "116" }, 
			{ map = 133433346, gather = true, door = "338" } },
			
		{	{ map = 133432320, gather = true, door = "351" },  
			{ map = 133431296, gather = true, custom = function() path = 4 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88213271)" },
			{ map = 88213271, path = "right" }, 
			{ map = "-1,0", path = "right" },
			{ map = 88212247, path = "top" },
			{ map = "0,-1", path = "top" },
			{ map = "0,-2", path = "top" },
			{ map = 88212250, door = "248" }, -- Entrée Mine Yjupe
			{ map = 97255955, gather = true, path = "512" }, 
			{ map = 97256979, gather = true, path = "248" },
			{ map = 97258003, gather = true, path = "228" }, 
			{ map = 97259027, gather = true, path = "194" }, 
			{ map = 97260051, gather = true, custom = function() path = 5 map:changeMap("423") end } },
			
		{	{ map = 97259027, gather = true, path = "267" },  
			{ map = 97261075, gather = true, custom = function() path = 6 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88213271)" },
			{ map = 88213271, path = "bottom" }, 
			{ map = "-2,1", path = "bottom" },
			{ map = "-2,2", path = "bottom" },
			{ map = "-2,3", path = "bottom" },
			{ map = 88213267, door = "236" }, -- Entrée Mine Audérie
			{ map = 97255949, gather = true, path = "376" }, 
			{ map = 97256973, gather = true, path = "122" },
			{ map = 97257997, gather = true, path = "235" }, 
			{ map = 97259021, gather = true, custom = function() path = 7 map:changeMap("323") end } },
			
		{ 	{ map = 97260045, gather = true, path = "254" }, 
			{ map = 97256973, gather = true, path = "537" },
			{ map = 97257997, gather = true, path = "451" }, 
			{ map = 97261069, gather = true, custom = function() path = 8 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88212746)" },
			{ map = 88212746, path = "top" },
			{ map = "-1,12", path = "top" },
			{ map = "-1,11", path = "top" },
			{ map = "-1,10", path = "top" },
			{ map = "-1,9", path = "left" },
			{ map = "-2,9", path = "left" },
			{ map = 88213774, door = "353" }, -- Entrée Mine Istairameur
			{ map = 97259013, gather = true, path = "258" }, 
			{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "284" }, 
			{ map = 97255943, gather = true, custom = function() path = 9 map:changeMap("403") end } },
			
		{	{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "290" }, 
			{ map = 97259015, gather = true, custom = function() path = 10 map:changeMap("451") end } },
			
		{	{ map = 97261061, gather = true, path = "458" }, 
			{ map = 97260037, gather = true, path = "303" },
			{ map = 97257991, gather = true, custom = function() path = 11 map:changeMap("464") end } },
			
		{	{ map = 97260037, gather = true, path = "430" }, --430
			{ map = 97259013, gather = true, path = "276" }, -- 276
			{ map = 97256967, gather = true, path = "194" }, -- 194
			{ map = 97260039, gather = true, path = "241" }, -- 241
			{ map = 97261063, gather = true, path = "296" }, -- 296
			{ map = 97255945, gather = true, path = "213" }, -- 213
			{ map = 97256969, gather = true, custom = function() path = 12 map:changeMap("401") end } }, -- 401
			
		{	{ map = 97255945, gather = true, path = "332" }, -- 332
			{ map = 97260041, gather = true, custom = function() path = 13 map:changeMap("354") end } }, -- 354
			
		
		{	{ map = 97261063, gather = true, path = "331" }, -- 331
			{ map = 97255945, gather = true, path = "416" }, -- 416
			{ map = 97259017, gather = true, custom = function() path = 14 map:changeMap("436") end } }, -- 436
			
		{	{ map = 97256971, gather = true, path = "239" }, -- 239
			{ map = 97255947, gather = true, path = "199" }, -- 199
			{ map = 97261065, gather = true, path = "213" }, -- 213
			{ map = 97257993, path = "122" }, -- 122
			{ map = 97260039, gather = true, path = "262" }, -- 262
			{ map = 97261063, gather = true, path = "459" }, -- 459
			{ map = 97257995, gather = true, custom = function() path = 15 map:changeMap("374") end } }, -- 374
			
		{	{ map = 97256971, gather = true, path = "234" }, -- 234
			{ map = 97261067, gather = true, custom = function() path = 16 map:changeMap("521") end } }, -- 521
			
		{	{ map = 97256971, gather = true, path = "503" }, -- 503
			{ map = 97255947, gather = true, path = "500" }, -- 500
			{ map = 97261065, gather = true, path = "236" }, -- 236
			{ map = 97259019, gather = true, path = "276" }, -- 276
			{ map = 97260043, gather = true, custom = function() path = 17 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88085249)" },
			{ map = 88085249, path = "left" }, 
			{ map = "9,22", path = "left" },
			{ map = "8,22", path = "left" },
			{ map = "7,22", path = "left" },
			{ map = "6,22", path = "left" },
			{ map = "5,22", path = "top" },
			{ map = "5,21", path = "top" },
			{ map = "5,20", path = "top" },
			{ map = 88082692, door = "332" }, -- Entrée Mine Hérale
			{ map = 97260033, gather = true, path = "183" }, -- 183 
			{ map = 97261059, gather = true, custom = function() path = 18 map:changeMap("417") end } }, -- 417
			
		{	{ map = 97260033, gather = true, path = "405" }, -- 405
			{ map = 97261057, gather = true, path = "235" },
			{ map = 97255939, gather = true, path = "446" }, -- 446
			{ map = 97256963, gather = true, path = "492" }, -- 492
			{ map = 97257987, gather = true, path = "492" }, -- 492
			{ map = 97260035, gather = true, custom = function() path = 19 map:changeMap("288") end } }, -- 288
			
		{	{ map = 97261057, gather = true, path = "421" }, -- 421
			{ map = 97257987, gather = true, path = "212" }, -- 212
			{ map = 97259011, gather = true, custom = function() path = 20 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88212481)" },
			{ map = 88212481, path = "right" }, 
			{ map = "0,24", path = "right" },
			{ map = "1,24", path = "right" },
			{ map = "2,24", path = "right" },
			{ map = "3,24", path = "right" },
			{ map = "4,24", path = "bottom" },
			{ map = "4,25", path = "bottom" },
			{ map = "4,26", path = "bottom" },
			{ map = "4,27", path = "bottom" },
			{ map = 88081925, door = "164" }, -- Entrée Mine Plaine Des Scarafeuilles
			{ map = 97255937, gather = true, path = "360" }, -- 360
			{ map = 97256961, gather = true, path = "276" }, -- 276			
			{ map = 97257985, gather = true, custom = function() path = 21 map:changeMap("436") end } }, -- 436
			
		{ 	{ map = 72619522, door = "132" }, -- Entrée Mine Porcos 1
			{ map = 30672658, gather = true, path = "362" }, -- 362
			{ map = 30672655, gather = true, path = "221" }, -- 221			
			{ map = 30672649, gather = true, custom = function() path = 22 map:changeMap("408") end }, -- 408
			{ map = "1,31", path = "bottom" },
			{ map = "2,31", path = "left" },
			{ map = "3,31", path = "left" },
			{ map = "4,31", path = "left" },
			{ map = "4,30", path = "bottom" },
			{ map = "4,29", path = "bottom" },
			{ map = 88081925, path = "bottom" },
			{ map = 97255937, gather = true, custom = function() map:changeMap("436") end },
			{ map = 97256961, gather = true, path = "351" } }, -- 351
			
		{	{ map = 30672655, gather = true, path = "492" }, -- 492			
			{ map = 30672652, gather = true, custom = function() path = 23 map:changeMap("289") end } }, -- 289
			
		{ 	{ map = 72619522, path = "bottom" },
			{ map = 30672658, gather = true, path = "477" }, -- 477
			{ map = 30672655, gather = true, path = "270" }, -- 270			
			{ map = "1,33", path = "left" },
			{ map = "0,33", path = "left" },
			{ map = 72618499, door = "231" }, -- Entrée Mine Porcos 2 231
			{ map = 72222720, gather = true, custom = function() path = 24 map:changeMap("464") end } }, -- 464
			
		{ 	{ map = 72618499, door = "71" }, -- Entrée Mine Porcos 2 71
			{ map = 30671116, gather = true, path = "292" }, -- 292
			{ map = 30671110, gather = true, path = "479" }, -- 479
			{ map = 30671107, gather = true, path = "298" }, -- 298
			{ map = 30670848, gather = true, custom = function() path = 1 map:changeMap("havenbag") end } }

	},
	
	["bronze"] = {
	
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "right" }, 
			{ map = "-24,12", path = "right" }, 
			{ map = "-23,12", path = "bottom" }, 
			{ map = "-23,13", path = "bottom" }, 
			{ map = "-23,14", path = "bottom" }, 
			{ map = "-23,15", path = "bottom" }, 
			{ map = "-23,16", path = "bottom" }, 
			{ map = 173018625, door = "511" }, -- 511
			{ map = 173018626, path = "right" },
			{ map = 173019138, path = "bottom" },
			{ map = "-22,19", path = "left" }, 			
			{ map = "-23,19", path = "bottom" }, 
			{ map = "-23,20", path = "bottom" },  
			{ map = 173018629, door = "82" }, -- Entrée Mine Hipouce 82
			{ map = 178784260, gather = true, door = "421" }, -- p421
			{ map = 178783236, gather = true, door = "309" }, -- 309
			{ map = 178782214, gather = true, door = "507" }, -- 507
			{ map = 178782216, gather = true, door = "422" }, -- p422
			{ map = 178782218, gather = true, door = "476" }, -- 476
			{ map = 178782220, gather = true, custom = function() path = 2 map:door(57) end } }, -- 57
			
		{ 	{ map = 178784256, gather = true, custom = function() path = 3 map:door(505) end }, -- 505
			{ map = 178783232, gather = true, door = "204" }, -- 204
			{ map = 178783236, gather = true, door = "555" }, -- p555
			{ map = 178782214, gather = true, door = "150" }, -- 150
			{ map = 178782216, gather = true, door = "122" }, -- 122
			{ map = 178782218, gather = true, door = "122" } }, -- p122
			
		{	{ map = 178783232, gather = true, door = "403" }, -- p403
			{ map = 178783234, gather = true, door = "281" }, -- 281
			{ map = 178782210, gather = true, door = "185" }, -- 185
			{ map = 178782208, gather = true, custom = function() path = 21 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(156240386)" },
			{ map = 156240386, path = "right" }, 
			{ map = "-2,-42", path = "right" }, 
			{ map = 156241410, custom = function() map:door(149) end }, -- Entrée Mine du Lac de Cania
			{ map = 133431302, gather = true, door = "179" }, 
			{ map = 133431300, gather = true, door = "165" },
			{ map = 133431298, gather = true, door = "432" }, 
			{ map = 133432322, gather = true, door = "348" }, 
			{ map = 133433346, gather = true, door = "177" },  
			{ map = 133433344, gather = true, custom = function() path = 5 map:door(515) end } },
			
		{ 	{ map = 133432578, gather = true, custom = function() path = 6 map:door(423) end },
			{ map = 133432320, gather = true, door = "134" }, 
			{ map = 133432322, gather = true, door = "116" }, 
			{ map = 133433346, gather = true, door = "338" } },
			
		{	{ map = 133432320, gather = true, door = "351" },  
			{ map = 133431296, gather = true, custom = function() path = 7 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88213271)" },
			{ map = 88213271, path = "bottom" }, 
			{ map = "-2,1", path = "bottom" },
			{ map = "-2,2", path = "bottom" },
			{ map = "-2,3", path = "bottom" },
			{ map = 88213267, door = "236" }, -- Entrée Mine Audérie
			{ map = 97255949, gather = true, path = "376" }, 
			{ map = 97256973, gather = true, path = "122" },
			{ map = 97257997, gather = true, path = "235" }, 
			{ map = 97259021, gather = true, custom = function() path = 8 map:changeMap("323") end } },
			
		{ 	{ map = 97260045, gather = true, path = "254" }, 
			{ map = 97256973, gather = true, path = "537" },
			{ map = 97257997, gather = true, path = "451" }, 
			{ map = 97261069, gather = true, custom = function() path = 9 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88212746)" },
			{ map = 88212746, path = "top" },
			{ map = "-1,12", path = "top" },
			{ map = "-1,11", path = "top" },
			{ map = "-1,10", path = "top" },
			{ map = "-1,9", path = "left" },
			{ map = "-2,9", path = "left" },
			{ map = 88213774, door = "353" }, -- Entrée Mine Istairameur
			{ map = 97259013, gather = true, path = "258" }, 
			{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "284" }, 
			{ map = 97255943, gather = true, custom = function() path = 10 map:changeMap("403") end } },
			
		{	{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "290" }, 
			{ map = 97259015, gather = true, custom = function() path = 11 map:changeMap("451") end } },
			
		{	{ map = 97261061, gather = true, path = "458" }, 
			{ map = 97260037, gather = true, path = "303" },
			{ map = 97257991, gather = true, custom = function() path = 12 map:changeMap("464") end } },
			
		{	{ map = 97260037, gather = true, path = "430" },
			{ map = 97259013, gather = true, path = "276" }, 
			{ map = 97256967, gather = true, path = "194" }, 
			{ map = 97260039, gather = true, path = "241" },
			{ map = 97261063, gather = true, path = "296" },
			{ map = 97255945, gather = true, path = "213" },
			{ map = 97256969, gather = true, custom = function() path = 13 map:changeMap("401") end } },
			
		{	{ map = 97255945, gather = true, path = "332" },
			{ map = 97260041, gather = true, custom = function() path = 14 map:changeMap("354") end } },
			
		
		{	{ map = 97261063, gather = true, path = "331" },
			{ map = 97255945, gather = true, path = "416" },
			{ map = 97259017, gather = true, custom = function() path = 15 map:changeMap("436") end } },
			
		{	{ map = 97256971, gather = true, path = "239" },
			{ map = 97255947, gather = true, path = "199" },
			{ map = 97261065, gather = true, path = "213" }, 
			{ map = 97257993, path = "122" }, 
			{ map = 97260039, gather = true, path = "262" },
			{ map = 97261063, gather = true, path = "459" },
			{ map = 97257995, gather = true, custom = function() path = 16 map:changeMap("374") end } },
			
		{	{ map = 97256971, gather = true, path = "234" },
			{ map = 97261067, gather = true, custom = function() path = 17 map:changeMap("521") end } },
			
		{	{ map = 97256971, gather = true, path = "503" },
			{ map = 97255947, gather = true, path = "500" },
			{ map = 97261065, gather = true, path = "236" },
			{ map = 97259019, gather = true, path = "276" },
			{ map = 97260043, gather = true, custom = function() path = 18 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88085249)" },
			{ map = 88085249, path = "left" }, 
			{ map = "9,22", path = "left" },
			{ map = "8,22", path = "left" },
			{ map = "7,22", path = "left" },
			{ map = "6,22", path = "left" },
			{ map = "5,22", path = "top" },
			{ map = "5,21", path = "top" },
			{ map = "5,20", path = "top" },
			{ map = 88082692, door = "332" }, -- Entrée Mine Hérale
			{ map = 97260033, gather = true, path = "183" },  
			{ map = 97261059, gather = true, custom = function() path = 19 map:changeMap("417") end } },
			
		{	{ map = 97260033, gather = true, path = "405" },
			{ map = 97261057, gather = true, path = "235" },
			{ map = 97255939, gather = true, path = "446" },
			{ map = 97256963, gather = true, path = "492" },
			{ map = 97257987, gather = true, path = "492" },
			{ map = 97260035, gather = true, custom = function() path = 20 map:changeMap("288") end } },
			
		{	{ map = 97261057, gather = true, path = "421" },
			{ map = 97257987, gather = true, path = "212" },
			{ map = 97259011, gather = true, custom = function() path = 1 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(212861955)" },
			{ map = 212861955, path = "right" },  
			{ map = "-25,37", path = "bottom" }, 
			{ map = "-25,38", path = "bottom" }, 
			{ map = "-25,39", path = "bottom" }, 
			{ map = "-25,40", path = "left" }, 
			{ map = "-26,41", path = "bottom" }, 
			{ map = "-26,42", path = "bottom" }, 
			{ map = "-26,43", path = "bottom" }, 
			{ map = "-26,44", path = "bottom" }, 
			{ map = "-26,45", path = "right" },
			{ map = 172232208, door = "180" }, -- Entrée Grotte Hâtive
			{ map = 178784266, gather = true, custom = function() path = 4 map:changeMap("havenbag") end } }
	
	},
	
	["kobalte"] = {
	
		{ 	{ map = 162791424, path = "zaap(156240386)" },
			{ map = 156240386, path = "right" }, 
			{ map = "-2,-42", path = "right" }, 
			{ map = 156241410, custom = function() map:door(149) end }, -- Entrée Mine du Lac de Cania
			{ map = 133431302, gather = true, door = "179" }, 
			{ map = 133431300, gather = true, door = "165" },
			{ map = 133431298, gather = true, door = "432" }, 
			{ map = 133432322, gather = true, door = "348" }, 
			{ map = 133433346, gather = true, door = "177" },  
			{ map = 133433344, gather = true, custom = function() path = 2 map:door(515) end } },
			
		{ 	{ map = 133432578, gather = true, custom = function() path = 3 map:door(423) end },
			{ map = 133432320, gather = true, door = "134" }, 
			{ map = 133432322, gather = true, door = "116" }, 
			{ map = 133433346, gather = true, door = "338" } },
			
		{	{ map = 133432320, gather = true, door = "351" },  
			{ map = 133431296, gather = true, custom = function() path = 4 map:changeMap("havenbag") end } },
			
		
		{ 	{ map = 162791424, path = "zaap(147590153)" },
			{ map = 147590153, path = "top" }, 
			{ map = "-17,-48", path = "top" },
			{ map = 147590151, door = "113" }, -- Entrée Mine des Plaines Rocheuses
			{ map = 164758273, gather = true, custom = function() path = 5 map:changeMap("havenbag") end } },
			
			
		{ 	{ map = 162791424, path = "zaap(88213271)" },
			{ map = 88213271, path = "bottom" }, 
			{ map = "-2,1", path = "bottom" },
			{ map = "-2,2", path = "bottom" },
			{ map = "-2,3", path = "bottom" },
			{ map = 88213267, door = "236" }, -- Entrée Mine Audérie
			{ map = 97255949, gather = true, path = "376" }, 
			{ map = 97256973, gather = true, path = "122" },
			{ map = 97257997, gather = true, path = "235" }, 
			{ map = 97259021, gather = true, custom = function() path = 6 map:changeMap("323") end } },
			
		{ 	{ map = 97260045, gather = true, path = "254" }, 
			{ map = 97256973, gather = true, path = "537" },
			{ map = 97257997, gather = true, path = "451" }, 
			{ map = 97261069, gather = true, custom = function() path = 7 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88212746)" },
			{ map = 88212746, path = "top" },
			{ map = "-1,12", path = "top" },
			{ map = "-1,11", path = "top" },
			{ map = "-1,10", path = "top" },
			{ map = "-1,9", path = "left" },
			{ map = "-2,9", path = "left" },
			{ map = 88213774, door = "353" }, -- Entrée Mine Istairameur
			{ map = 97259013, gather = true, path = "258" }, 
			{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "284" }, 
			{ map = 97255943, gather = true, custom = function() path = 8 map:changeMap("403") end } },
			
		{	{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "290" }, 
			{ map = 97259015, gather = true, custom = function() path = 9 map:changeMap("451") end } },
			
		{	{ map = 97261061, gather = true, path = "458" }, 
			{ map = 97260037, gather = true, path = "303" },
			{ map = 97257991, gather = true, custom = function() path = 10 map:changeMap("464") end } },
			
		{	{ map = 97260037, gather = true, path = "430" },
			{ map = 97259013, gather = true, path = "276" }, 
			{ map = 97256967, gather = true, path = "194" }, 
			{ map = 97260039, gather = true, path = "241" },
			{ map = 97261063, gather = true, path = "296" },
			{ map = 97255945, gather = true, path = "213" },
			{ map = 97256969, gather = true, custom = function() path = 11 map:changeMap("401") end } },
			
		{	{ map = 97255945, gather = true, path = "332" },
			{ map = 97260041, gather = true, custom = function() path = 12 map:changeMap("354") end } },
			
		
		{	{ map = 97261063, gather = true, path = "331" },
			{ map = 97255945, gather = true, path = "416" },
			{ map = 97259017, gather = true, custom = function() path = 13 map:changeMap("436") end } },
			
		{	{ map = 97256971, gather = true, path = "239" },
			{ map = 97255947, gather = true, path = "199" },
			{ map = 97261065, gather = true, path = "213" }, 
			{ map = 97257993, path = "122" }, 
			{ map = 97260039, gather = true, path = "262" },
			{ map = 97261063, gather = true, path = "459" },
			{ map = 97257995, gather = true, custom = function() path = 14 map:changeMap("374") end } },
			
		{	{ map = 97256971, gather = true, path = "234" },
			{ map = 97261067, gather = true, custom = function() path = 15 map:changeMap("521") end } },
			
		{	{ map = 97256971, gather = true, path = "503" },
			{ map = 97255947, gather = true, path = "500" },
			{ map = 97261065, gather = true, path = "236" },
			{ map = 97259019, gather = true, path = "276" },
			{ map = 97260043, gather = true, custom = function() path = 16 map:changeMap("havenbag") end } },
			
		{	{ map = 162791424, path = "zaap(88085249)" },
			{ map = 88085249, path = "right" }, 
			{ map = "11,22", path = "right" }, 
			{ map = "12,22", path = "right" }, 
			{ map = "13,22", path = "right" }, 
			{ map = "14,22", path = "top" }, 
			{ map = "14,21", path = "top" }, 
			{ map = "14,20", path = "top" }, 
			{ map = "14,19", path = "top" }, 
			{ map = "14,18", path = "top" }, 
			{ map = "14,17", path = "top" }, 
			{ map = "14,16", path = "top" }, 
			{ map = "14,15", path = "top" }, 
			{ map = 88087305, door = "403" }, -- Tunnel de Kartonpath
			{ map = 117440512, door = "222" }, -- 222
			{ map = 117441536, gather = true, door = "167" }, -- 167
			{ map = 117442560, gather = true, door = "488" }, -- 488
			{ map = 117443584, gather = true, door = "221" }, -- 221
			{ map = 117440514, gather = true, door = "293" }, -- 293
			{ map = 117441538, gather = true, door = "251" }, -- 251
			{ map = 117442562, gather = true, custom = function() path = 17 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "right" }, 
			{ map = "-24,12", path = "right" }, 
			{ map = "-23,12", path = "bottom" }, 
			{ map = "-23,13", path = "bottom" }, 
			{ map = "-23,14", path = "bottom" }, 
			{ map = "-23,15", path = "bottom" }, 
			{ map = "-23,16", path = "bottom" }, 
			{ map = 173018625, door = "511" },
			{ map = 173018626, path = "right" },
			{ map = 173019138, path = "bottom" },
			{ map = "-22,19", path = "left" }, 			
			{ map = "-23,19", path = "bottom" }, 
			{ map = "-23,20", path = "bottom" },  
			{ map = 173018629, door = "82" }, -- Entrée Mine Hipouce
			{ map = 178784260, gather = true, door = "421" },
			{ map = 178783236, gather = true, door = "309" },
			{ map = 178782214, gather = true, door = "507" },
			{ map = 178782216, gather = true, door = "422" },
			{ map = 178782218, gather = true, door = "476" },
			{ map = 178782220, gather = true, custom = function() path = 18 map:door(57) end } },
			
		{ 	{ map = 178784256, gather = true, custom = function() path = 19 map:door(505) end },
			{ map = 178783232, gather = true, door = "204" },
			{ map = 178783236, gather = true, door = "555" },
			{ map = 178782214, gather = true, door = "150" },
			{ map = 178782216, gather = true, door = "122" },
			{ map = 178782218, gather = true, door = "122" } },
			
		{	{ map = 178783232, gather = true, door = "403" },
			{ map = 178783234, gather = true, door = "281" },
			{ map = 178782210, gather = true, door = "185" },
			{ map = 178782208, gather = true, custom = function() path = 1 map:changeMap("havenbag") end } }
			
			
		

	},
	
	["manganèse"] = {
	
		{ 	{ map = 162791424, path = "zaap(156240386)" },
			{ map = 156240386, path = "right" }, 
			{ map = "-2,-42", path = "right" }, 
			{ map = 156241410, custom = function() map:door(149) end }, -- Entrée Mine du Lac de Cania
			{ map = 133431302, gather = true, door = "179" }, 
			{ map = 133431300, gather = true, door = "165" },
			{ map = 133431298, gather = true, door = "432" }, 
			{ map = 133432322, gather = true, door = "348" }, 
			{ map = 133433346, gather = true, door = "177" },  
			{ map = 133433344, gather = true, custom = function() path = 2 map:door(515) end } },
			
		{ 	{ map = 133432578, gather = true, custom = function() path = 3 map:door(423) end },
			{ map = 133432320, gather = true, door = "134" }, 
			{ map = 133432322, gather = true, door = "116" }, 
			{ map = 133433346, gather = true, door = "338" } },
			
		{	{ map = 133432320, gather = true, door = "351" },  
			{ map = 133431296, gather = true, custom = function() path = 4 map:changeMap("havenbag") end } },
			
		
		{ 	{ map = 162791424, path = "zaap(147590153)" },
			{ map = 147590153, path = "top" }, 
			{ map = "-17,-48", path = "top" },
			{ map = 147590151, door = "113" }, -- Entrée Mine des Plaines Rocheuses
			{ map = 164758273, gather = true, custom = function() path = 5 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88213271)" },
			{ map = 88213271, path = "top" }, 
			{ map = "-2,-1", path = "top" },
			{ map = "-2,-2", path = "top" },
			{ map = "-2,-3", path = "top" },
			{ map = "-2,-4", path = "top" },
			{ map = 185862148, door = "367" }, -- Entrée Mine Astirite 367
			{ map = 97255951, path = "203" }, -- 203
			{ map = 97256975, gather = true, path = "323" }, -- 323
			{ map = 97257999, gather = true, path = "247" }, -- 247
			{ map = 97259023, gather = true, custom = function() path = 6 map:changeMap("451") end } }, -- 451
			
		{ 	{ map = 97257999, gather = true, path = "268" }, -- 268
			{ map = 97260047, gather = true, path = "379" }, -- 379
			{ map = 97261071, gather = true, custom = function() path = 7 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88212746)" },
			{ map = 88212746, path = "top" },
			{ map = "-1,12", path = "top" },
			{ map = "-1,11", path = "top" },
			{ map = "-1,10", path = "top" },
			{ map = "-1,9", path = "left" },
			{ map = "-2,9", path = "left" },
			{ map = 88213774, door = "353" }, -- Entrée Mine Istairameur
			{ map = 97259013, gather = true, path = "258" }, 
			{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "284" }, 
			{ map = 97255943, gather = true, custom = function() path = 8 map:changeMap("403") end } },
			
		{	{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "290" }, 
			{ map = 97259015, gather = true, custom = function() path = 9 map:changeMap("451") end } },
			
		{	{ map = 97261061, gather = true, path = "458" }, 
			{ map = 97260037, gather = true, path = "303" },
			{ map = 97257991, gather = true, custom = function() path = 10 map:changeMap("464") end } },
			
		{	{ map = 97260037, gather = true, path = "430" },
			{ map = 97259013, gather = true, path = "276" }, 
			{ map = 97256967, gather = true, path = "194" }, 
			{ map = 97260039, gather = true, path = "241" },
			{ map = 97261063, gather = true, path = "296" },
			{ map = 97255945, gather = true, path = "213" },
			{ map = 97256969, gather = true, custom = function() path = 11 map:changeMap("401") end } },
			
		{	{ map = 97255945, gather = true, path = "332" },
			{ map = 97260041, gather = true, custom = function() path = 12 map:changeMap("354") end } },
			
		
		{	{ map = 97261063, gather = true, path = "331" },
			{ map = 97255945, gather = true, path = "416" },
			{ map = 97259017, gather = true, custom = function() path = 13 map:changeMap("436") end } },
			
		{	{ map = 97256971, gather = true, path = "239" },
			{ map = 97255947, gather = true, path = "199" },
			{ map = 97261065, gather = true, path = "213" }, 
			{ map = 97257993, path = "122" }, 
			{ map = 97260039, gather = true, path = "262" },
			{ map = 97261063, gather = true, path = "459" },
			{ map = 97257995, gather = true, custom = function() path = 14 map:changeMap("374") end } },
			
		{	{ map = 97256971, gather = true, path = "234" },
			{ map = 97261067, gather = true, custom = function() path = 15 map:changeMap("521") end } },
			
		{	{ map = 97256971, gather = true, path = "503" },
			{ map = 97255947, gather = true, path = "500" },
			{ map = 97261065, gather = true, path = "236" },
			{ map = 97259019, gather = true, path = "276" },
			{ map = 97260043, gather = true, custom = function() path = 16 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88085249)" },
			{ map = 88085249, path = "left" }, 
			{ map = "9,22", path = "left" },
			{ map = "8,22", path = "left" },
			{ map = "7,22", path = "left" },
			{ map = "6,22", path = "left" },
			{ map = "5,22", path = "top" },
			{ map = "5,21", path = "top" },
			{ map = "5,20", path = "top" },
			{ map = 88082692, door = "332" }, -- Entrée Mine Hérale
			{ map = 97260033, gather = true, path = "183" },  
			{ map = 97261059, gather = true, custom = function() path = 17 map:changeMap("417") end } },
			
		{	{ map = 97260033, gather = true, path = "405" },
			{ map = 97261057, gather = true, path = "235" },
			{ map = 97255939, gather = true, path = "446" },
			{ map = 97256963, gather = true, path = "492" },
			{ map = 97257987, gather = true, path = "492" },
			{ map = 97260035, gather = true, custom = function() path = 18 map:changeMap("288") end } },
			
		{	{ map = 97261057, gather = true, path = "421" },
			{ map = 97257987, gather = true, path = "212" },
			{ map = 97259011, gather = true, custom = function() path = 19 map:changeMap("havenbag") end } },
			
		{	{ map = 162791424, path = "zaap(88085249)" },
			{ map = 88085249, path = "right" }, 
			{ map = "11,22", path = "right" }, 
			{ map = "12,22", path = "right" }, 
			{ map = "13,22", path = "right" }, 
			{ map = "14,22", path = "top" }, 
			{ map = "14,21", path = "top" }, 
			{ map = "14,20", path = "top" }, 
			{ map = "14,19", path = "top" }, 
			{ map = "14,18", path = "top" }, 
			{ map = "14,17", path = "top" }, 
			{ map = "14,16", path = "top" }, 
			{ map = "14,15", path = "top" }, 
			{ map = 88087305, door = "403" }, -- Tunnel de Kartonpath
			{ map = 117440512, door = "222" },
			{ map = 117441536, gather = true, door = "167" },
			{ map = 117442560, gather = true, door = "488" },
			{ map = 117443584, gather = true, door = "221" },
			{ map = 117440514, gather = true, door = "293" },
			{ map = 117441538, gather = true, door = "251" },
			{ map = 117442562, gather = true, custom = function() path = 20 map:changeMap("havenbag") end } },
			
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "top" }, 
			{ map = "-25,11", path = "top" }, 
			{ map = "-25,10", path = "top" }, 
			{ map = "-25,9", path = "top" }, 
			{ map = "-25,8", path = "top" }, 
			{ map = "-25,7", path = "top" }, 
			{ map = "-25,6", path = "top" }, 
			{ map = "-25,5", path = "left" },   
			{ map = 171966987, door = "397" }, -- Entrée Mine Estrone
			{ map = 178785286, gather = true, door = "99" },
			{ map = 178785288, gather = true, custom = function() path = 21 map:changeMap("havenbag") end } },
			
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "right" }, 
			{ map = "-24,12", path = "right" }, 
			{ map = "-23,12", path = "bottom" }, 
			{ map = "-23,13", path = "bottom" }, 
			{ map = "-23,14", path = "bottom" }, 
			{ map = "-23,15", path = "bottom" }, 
			{ map = "-23,16", path = "bottom" }, 
			{ map = 173018625, door = "511" },
			{ map = 173018626, path = "right" },
			{ map = 173019138, path = "bottom" },
			{ map = "-22,19", path = "left" }, 			
			{ map = "-23,19", path = "bottom" }, 
			{ map = "-23,20", path = "bottom" },  
			{ map = 173018629, door = "82" }, -- Entrée Mine Hipouce
			{ map = 178784260, gather = true, door = "421" },
			{ map = 178783236, gather = true, door = "309" },
			{ map = 178782214, gather = true, door = "507" },
			{ map = 178782216, gather = true, door = "422" },
			{ map = 178782218, gather = true, door = "476" },
			{ map = 178782220, gather = true, custom = function() path = 22 map:door(57) end } },
			
		{ 	{ map = 178784256, gather = true, custom = function() path = 23 map:door(505) end },
			{ map = 178783232, gather = true, door = "204" },
			{ map = 178783236, gather = true, door = "555" },
			{ map = 178782214, gather = true, door = "150" },
			{ map = 178782216, gather = true, door = "122" },
			{ map = 178782218, gather = true, door = "122" } },
			
		{	{ map = 178783232, gather = true, door = "403" },
			{ map = 178783234, gather = true, door = "281" },
			{ map = 178782210, gather = true, door = "185" },
			{ map = 178782208, gather = true, custom = function() path = 1 map:changeMap("havenbag") end } }
			
	
	},
	
	["étain"] = {
				
		{	{ map = 162791424, path = "zaap(88212746)" },
			{ map = 88212746, path = "top" },
			{ map = "-1,12", path = "top" },
			{ map = "-1,11", path = "top" },
			{ map = "-1,10", path = "top" },
			{ map = "-1,9", path = "top" },
			{ map = "-1,8", door = "369" },
			{ map = "-2,8", path = "left" },
			{ map = "-3,8", path = "left" },
			{ map = "-4,8", path = "left" },
			{ map = "-5,8", path = "left" },
			{ map = "-6,8", path = "top" },
			{ map = "-6,7", path = "left" },
			{ map = 104202753, door = "100" }, -- Entrée Mine Bwork non connue 100
			{ map = 104859143, gather = true, path = "160" }, -- 160
			{ map = 104860167, gather = true, path = "205" }, -- 205
			{ map = 104861191, gather = true, custom = function() path = 2 map:changeMap("457") end } }, -- 457
			
		{	{ map = 104860167, gather = true, path = "478" }, -- 478
			{ map = 104859143, gather = true, path = "171" }, -- 171
			{ map = 104862215, gather = true, custom = function() path = 3 map:changeMap("472") end } }, -- 472
			
		{	{ map = 104859143, gather = true, path = "543" }, -- 543
			{ map = 104202753, gather = true, path = "right" },
			{ map = "-6,7", path = "top" },
			{ map = 104071168, door = "213" }, -- Entrée Mine des Bworks 2 213
			{ map = 104860165, gather = true, path = "242" }, -- 242
			{ map = 104861189, path = "451" }, -- 451
			{ map = 104862213, gather = true, path = "376" }, -- 376
			{ map = 104858119, gather = true, custom = function() path = 4 map:changeMap("207") end } }, -- 207
			
		{	{ map = 104071168, path = "top" }, -- Entrée Mine des Bworks 2
			{ map = 104860165, gather = true, path = "444" }, -- 444
			{ map = 104071425, door = "199" }, -- Entrée Mine des Bworks 1 199
			{ map = 104859139, gather = true, custom = function() path = 5 map:changeMap("444") end } }, -- 444
			
		{	{ map = 104071425, path = "right" }, -- Entrée Mine des Bworks 1
			{ map = "-5,5", path = "right" },
			{ map = "-4,5", path = "top" },
			{ map = "-4,4", path = "top" },
			{ map = "-4,3", path = "top" },
			{ map = 104072452, door = "248" }, -- Entrée Mine Campement des Gobelins p248
			{ map = 104858121, gather = true, path = "348" }, -- 348
			{ map = 104860169, gather = true, path = "263" }, -- 263
			{ map = 104861193, gather = true, path = "248" }, -- 248
			{ map = 104862217, gather = true, custom = function() path = 6 map:changeMap("369") end } }, -- 369
			
		{	{ map = 104861193, gather = true, path = "254" }, -- 254
			{ map = 104859145, gather = true, path = "457" }, -- 457
			{ map = 104858121, gather = true, path = "507" }, -- 507
			{ map = 104072452, custom = function() path = 7 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88212481)" },
			{ map = 88212481, path = "right" },
			{ map = 72619522, door = "132" }, -- Entrée Mine Porcos 1
			{ map = 30672658, gather = true, path = "362" },
			{ map = 30672655, gather = true, path = "221" },			
			{ map = 30672649, gather = true, custom = function() path = 8 map:changeMap("408") end }, 
			{ map = "0,24", path = "right" }, 
			{ map = "1,24", path = "bottom" }, 
			{ map = "1,25", path = "bottom" }, 
			{ map = "1,26", path = "bottom" }, 
			{ map = "1,27", path = "bottom" }, 
			{ map = "1,28", path = "bottom" }, 
			{ map = "1,29", path = "bottom" }, 
			{ map = "1,30", path = "bottom" },
			{ map = "1,31", path = "bottom" } },
			
		{	{ map = 30672655, gather = true, path = "492" },			
			{ map = 30672652, gather = true, custom = function() path = 9 map:changeMap("289") end } },
			
		{ 	{ map = 72619522, path = "bottom" },
			{ map = 30672658, gather = true, path = "477" },
			{ map = 30672655, gather = true, path = "270" },			
			{ map = "1,33", path = "left" },
			{ map = "0,33", path = "left" },
			{ map = 72618499, door = "231" }, -- Entrée Mine Porcos 2
			{ map = 72222720, gather = true, custom = function() path = 10 map:changeMap("464") end } },
			
		{ 	{ map = 72618499, door = "71" }, -- Entrée Mine Porcos 2
			{ map = 30671116, gather = true, path = "292" },
			{ map = 30671110, gather = true, path = "479" },
			{ map = 30671107, gather = true, path = "298" },
			{ map = 30670848, gather = true, custom = function() path = 11 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "top" }, 
			{ map = "-25,11", path = "top" }, 
			{ map = "-25,10", path = "top" }, 
			{ map = "-25,9", path = "top" }, 
			{ map = "-25,8", path = "top" }, 
			{ map = "-25,7", path = "top" }, 
			{ map = "-25,6", path = "top" }, 
			{ map = "-25,5", path = "left" },   
			{ map = 171966987, door = "397" }, -- Entrée Mine Estrone
			{ map = 178785286, gather = true, door = "99" },
			{ map = 178785288, gather = true, custom = function() path = 12 map:door(558) end } },
			
		{ 	{ map = 178785286, gather = true, door = "559" },
			{ map = 171966987, path = "top" }, -- Entrée Mine Estrone
			{ map = "-26,4", path = "top" }, 
			{ map = "-26,3", path = "top" }, 
			{ map = "-26,2", path = "top" }, 
			{ map = "-26,1", path = "top" }, 
			{ map = "-26,0", path = "top" }, 
			{ map = "-26,-1", path = "top" }, 
			{ map = "-26,-2", path = "top" }, 
			{ map = "-26,-3", path = "top" }, 
			{ map = "-26,-4", path = "top" }, 
			{ map = "-26,-5", path = "top" }, 
			{ map = "-26,-6", path = "top" }, 
			{ map = "-26,-7", path = "right" }, 
			{ map = "-25,-7", path = "right" }, 
			{ map = "-24,-7", path = "right" }, 
			{ map = "-23,-7", path = "right" }, 
			{ map = "-22,-7", path = "right" }, 
			{ map = 171707908, door = "166" }, 
			{ map = 178784264, gather = true, custom = function() path = 13 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(147590153)" },
			{ map = 147590153, path = "right" }, 
			{ map = "-16,-47", path = "right" }, 
			{ map = "-15,-47", path = "right" }, 
			{ map = "-14,-47", path = "bottom" }, 
			{ map = "-14,-46", path = "bottom" }, 
			{ map = "-14,-45", path = "bottom" }, 
			{ map = "-14,-44", path = "bottom" }, 
			{ map = 139464194, door = "173" }, -- Entrée Mine Pics de Cania 
			{ map = 141820675, gather = true, custom = function() path = 14 map:changeMap("right") end } },
			
		{ 	{ map = 139464194, path = "bottom" }, -- Entrée Mine Pics de Cania 
			{ map = "-14,-42", path = "bottom" }, 
			{ map = "-14,-41", path = "bottom" }, 
			{ map = "-14,-40", path = "left" }, 
			{ map = "-15,-40", path = "left" }, 
			{ map = "-16,-40", path = "left" }, 
			{ map = 139462661, door = "407" },   -- Entrée Mine Plaines de Cania 1
			{ map = 141951745, gather = true, custom = function() path = 15 map:changeMap("havenbag") end } },
			
		{	{ map = 162791424, path = "zaap(207619076)" },
			{ map = 207619076, path = "436"},
			{ map = 206307842, path = "right" },
			{ map = "21,-29", gather = true, path = "right" }, 
			{ map = "22,-29", gather = true, path = "right" }, 
			{ map = "23,-29", gather = true, path = "bottom" }, 
			{ map = "23,-28", gather = true, path = "bottom" }, 
			{ map = "23,-27", gather = true, path = "right" }, 
			{ map = "24,-27", gather = true, path = "right" }, 
			{ map = "25,-27", gather = true, path = "right" }, 
			{ map = "26,-27", gather = true, path = "right" }, 
			{ map = "27,-27", gather = true, custom = aiguillage2 }, 
			{ map = "27,-28", gather = true, path = "bottom" }, 
			{ map = "27,-26", gather = true, path = "left" }, 
			{ map = "26,-26", gather = true, path = "left" }, 
			{ map = "25,-26", gather = true, path = "left" }, 
			{ map = "24,-26", gather = true, path = "left" }, 
			{ map = "23,-26", gather = true, path = "bottom" }, 
			{ map = "23,-25", gather = true, path = "right" }, 
			{ map = "24,-25", gather = true, path = "right" }, 
			{ map = "25,-25", gather = true, path = "right" }, 
			{ map = "26,-25", gather = true, path = "bottom" }, 
			{ map = "26,-24", gather = true, path = "left" }, 
			{ map = "25,-24", gather = true, path = "bottom" }, 
			{ map = "25,-23", gather = true, path = "bottom" }, 
			{ map = 205260292, door = "303" },
			{ map = 207619084, gather = true, door = "220" },
			{ map = 207620108, gather = true, door = "130" },
			{ map = 209456132, gather = true, custom = function() path = 16 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "right" }, 
			{ map = "-24,12", path = "right" }, 
			{ map = "-23,12", path = "bottom" }, 
			{ map = "-23,13", path = "bottom" }, 
			{ map = "-23,14", path = "bottom" }, 
			{ map = "-23,15", path = "bottom" }, 
			{ map = "-23,16", path = "bottom" }, 
			{ map = 173018625, door = "511" },
			{ map = 173018626, path = "right" },
			{ map = 173019138, path = "bottom" },
			{ map = "-22,19", path = "left" }, 			
			{ map = "-23,19", path = "bottom" }, 
			{ map = "-23,20", path = "bottom" },  
			{ map = 173018629, door = "82" }, -- Entrée Mine Hipouce
			{ map = 178784260, gather = true, door = "421" },
			{ map = 178783236, gather = true, door = "309" },
			{ map = 178782214, gather = true, door = "507" },
			{ map = 178782216, gather = true, door = "422" },
			{ map = 178782218, gather = true, door = "476" },
			{ map = 178782220, gather = true, custom = function() path = 17 map:door(57) end } },
			
		{ 	{ map = 178784256, gather = true, custom = function() path = 18 map:door(505) end },
			{ map = 178783232, gather = true, door = "204" },
			{ map = 178783236, gather = true, door = "555" },
			{ map = 178782214, gather = true, door = "150" },
			{ map = 178782216, gather = true, door = "122" },
			{ map = 178782218, gather = true, door = "122" } },
			
		{	{ map = 178783232, gather = true, door = "403" },
			{ map = 178783234, gather = true, door = "281" },
			{ map = 178782210, gather = true, door = "185" },
			{ map = 178782208, gather = true, custom = function() path = 1 map:changeMap("havenbag") end } }
			
			 
	
	},
	
	["argent"] = {
	
		{ 	{ map = 162791424, path = "zaap(88212746)" },
			{ map = 88212746, path = "top" },
			{ map = "-1,12", path = "top" },
			{ map = "-1,11", path = "top" },
			{ map = "-1,10", path = "top" },
			{ map = "-1,9", path = "left" },
			{ map = "-2,9", path = "left" },
			{ map = 88213774, door = "353" }, -- Entrée Mine Istairameur
			{ map = 97259013, gather = true, path = "258" }, 
			{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "284" }, 
			{ map = 97255943, gather = true, custom = function() path = 2 map:changeMap("403") end } },
			
		{	{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "290" }, 
			{ map = 97259015, gather = true, custom = function() path = 3 map:changeMap("451") end } },
			
		{	{ map = 97261061, gather = true, path = "458" }, 
			{ map = 97260037, gather = true, path = "303" },
			{ map = 97257991, gather = true, custom = function() path = 4 map:changeMap("464") end } },
			
		{	{ map = 97260037, gather = true, path = "430" },
			{ map = 97259013, gather = true, path = "276" }, 
			{ map = 97256967, gather = true, path = "194" }, 
			{ map = 97260039, gather = true, path = "241" },
			{ map = 97261063, gather = true, path = "296" },
			{ map = 97255945, gather = true, path = "213" },
			{ map = 97256969, gather = true, custom = function() path = 5 map:changeMap("401") end } },
			
		{	{ map = 97255945, gather = true, path = "332" },
			{ map = 97260041, gather = true, custom = function() path = 6 map:changeMap("354") end } },
			
		
		{	{ map = 97261063, gather = true, path = "331" },
			{ map = 97255945, gather = true, path = "416" },
			{ map = 97259017, gather = true, custom = function() path = 7 map:changeMap("436") end } },
			
		{	{ map = 97256971, gather = true, path = "239" },
			{ map = 97255947, gather = true, path = "199" },
			{ map = 97261065, gather = true, path = "213" }, 
			{ map = 97257993, path = "122" }, 
			{ map = 97260039, gather = true, path = "262" },
			{ map = 97261063, gather = true, path = "459" },
			{ map = 97257995, gather = true, custom = function() path = 8 map:changeMap("374") end } },
			
		{	{ map = 97256971, gather = true, path = "234" },
			{ map = 97261067, gather = true, custom = function() path = 9 map:changeMap("521") end } },
			
		{	{ map = 97256971, gather = true, path = "503" },
			{ map = 97255947, gather = true, path = "500" },
			{ map = 97261065, gather = true, path = "236" },
			{ map = 97259019, gather = true, path = "276" },
			{ map = 97260043, gather = true, custom = function() path = 10 map:changeMap("havenbag") end } },
		
		
		{	{ map = 162791424, path = "zaap(88212746)" },
			{ map = 88212746, path = "top" },
			{ map = "-1,12", path = "top" },
			{ map = "-1,11", path = "top" },
			{ map = "-1,10", path = "top" },
			{ map = "-1,9", path = "top" },
			{ map = "-1,8", door = "369" },
			{ map = "-2,8", path = "left" },
			{ map = "-3,8", path = "left" },
			{ map = "-4,8", path = "left" },
			{ map = "-5,8", path = "left" },
			{ map = "-6,8", path = "top" },
			{ map = "-6,7", path = "left" },
			{ map = 104202753, door = "100" }, -- Entrée Mine Bwork non connue
			{ map = 104859143, gather = true, path = "160" },
			{ map = 104860167, gather = true, path = "205" },
			{ map = 104861191, gather = true, custom = function() path = 11 map:changeMap("457") end } },
			
		{	{ map = 104860167, gather = true, path = "478" },
			{ map = 104859143, gather = true, path = "171" },
			{ map = 104862215, gather = true, custom = function() path = 12 map:changeMap("472") end } },
			
		{	{ map = 104859143, gather = true, path = "543" },
			{ map = 104202753, gather = true, path = "right" },
			{ map = "-6,7", path = "top" },
			{ map = 104071168, door = "213" }, -- Entrée Mine des Bworks 2
			{ map = 104860165, gather = true, path = "242" },
			{ map = 104861189, path = "451" },
			{ map = 104862213, gather = true, path = "376" },
			{ map = 104858119, gather = true, custom = function() path = 13 map:changeMap("207") end } },
			
		{	{ map = 104071168, path = "top" }, -- Entrée Mine des Bworks 2
			{ map = 104860165, gather = true, path = "444" },
			{ map = 104071425, door = "199" }, -- Entrée Mine des Bworks 1
			{ map = 104859139, gather = true, custom = function() path = 14 map:changeMap("444") end } },
			
		{	{ map = 104071425, path = "right" }, -- Entrée Mine des Bworks 1
			{ map = "-5,5", path = "right" },
			{ map = "-4,5", path = "top" },
			{ map = "-4,4", path = "top" },
			{ map = "-4,3", path = "top" },
			{ map = 104072452, door = "248" }, -- Entrée Mine Campement des Gobelins
			{ map = 104858121, gather = true, path = "348" },
			{ map = 104860169, gather = true, path = "263" },
			{ map = 104861193, gather = true, path = "248" },
			{ map = 104862217, gather = true, custom = function() path = 15 map:changeMap("369") end } },
			
		{	{ map = 104861193, gather = true, path = "254" },
			{ map = 104859145, gather = true, path = "457" },
			{ map = 104858121, gather = true, path = "507" },
			{ map = 104072452, custom = function() path = 16 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "right" }, 
			{ map = "-24,12", path = "right" }, 
			{ map = "-23,12", path = "bottom" }, 
			{ map = "-23,13", path = "bottom" }, 
			{ map = "-23,14", path = "bottom" }, 
			{ map = "-23,15", path = "bottom" }, 
			{ map = "-23,16", path = "bottom" }, 
			{ map = 173018625, door = "511" },
			{ map = 173018626, path = "right" },
			{ map = 173019138, path = "bottom" },
			{ map = "-22,19", path = "left" }, 			
			{ map = "-23,19", path = "bottom" }, 
			{ map = "-23,20", path = "bottom" },  
			{ map = 173018629, door = "82" }, -- Entrée Mine Hipouce
			{ map = 178784260, gather = true, door = "421" },
			{ map = 178783236, gather = true, door = "309" },
			{ map = 178782214, gather = true, door = "507" },
			{ map = 178782216, gather = true, door = "422" },
			{ map = 178782218, gather = true, door = "476" },
			{ map = 178782220, gather = true, custom = function() path = 17 map:door(57) end } },
			
		{ 	{ map = 178784256, gather = true, custom = function() path = 18 map:door(505) end },
			{ map = 178783232, gather = true, door = "204" },
			{ map = 178783236, gather = true, door = "555" },
			{ map = 178782214, gather = true, door = "150" },
			{ map = 178782216, gather = true, door = "122" },
			{ map = 178782218, gather = true, door = "122" } },
			
		{	{ map = 178783232, gather = true, door = "403" },
			{ map = 178783234, gather = true, door = "281" },
			{ map = 178782210, gather = true, door = "185" },
			{ map = 178782208, gather = true, door = "421" }, -- 421
			{ map = 173017606, door = "88" }, -- 88
			{ map = 173017605, path = "right" },
			{ map = 173018117, path = "right" },
			{ map = "-23,21", path = "right" },
			{ map = "-22,21", path = "right" }, 
			{ map = "-21,21", path = "right" }, 
			{ map = "-20,21", path = "right" }, 
			{ map = "-19,21", path = "right" }, 
			{ map = "-18,21", path = "right" },   
			{ map = 172491782, door = "373" }, -- Entrée Mine Imale
			{ map = 178783240, gather = true, door = "277" },
			{ map = 178783242, gather = true, custom = function() path = 19 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(164364304)" },
			{ map = 164364304, path = "top" },
			{ map = "-20,-21", path = "top" }, 
			{ map = "-20,-22", path = "top" }, 
			{ map = "-20,-23", path = "top" }, 
			{ map = "-20,-24", path = "top" }, 
			{ map = "-20,-25", path = "top" }, 
			{ map = "-20,-26", path = "top" }, 
			{ map = "-20,-27", path = "left" }, 
			{ map = "-21,-27", path = "left" },    
			{ map = 164496393, door = "200" }, -- Entrée Passage vers Routes Rocailleuses 200
			{ map = 168036352, gather = true, door = "242" }, -- 242
			{ map = 168035328, door = "188" }, -- 188
			{ map = 168034304, door = "184" }, -- 184
			{ map = 168034306, gather = true, path = "340" },
			{ map = 168034308, door = "464" }, -- 464
			{ map = 168034310, gather = true, door = "493" }, -- 493
			{ map = 168034312, gather = true, door = "215" }, -- 215
			{ map = 168167424, door = "289" }, -- 289
			{ map = 164102664, custom = function() path = 20 map:changeMap("havenbag") end } },
			
		{	{ map = 162791424, path = "zaap(207619076)" },
			{ map = 207619076, path = "436"},
			{ map = 206307842, path = "right" },
			{ map = "21,-29", gather = true, path = "right" }, 
			{ map = "22,-29", gather = true, path = "right" }, 
			{ map = "23,-29", gather = true, path = "bottom" }, 
			{ map = "23,-28", gather = true, path = "bottom" }, 
			{ map = "23,-27", gather = true, path = "right" }, 
			{ map = "24,-27", gather = true, path = "right" }, 
			{ map = "25,-27", gather = true, path = "right" }, 
			{ map = "26,-27", gather = true, path = "right" }, 
			{ map = "27,-27", gather = true, custom = aiguillage2 }, 
			{ map = "27,-28", gather = true, path = "bottom" }, 
			{ map = "27,-26", gather = true, path = "left" }, 
			{ map = "26,-26", gather = true, path = "left" }, 
			{ map = "25,-26", gather = true, path = "left" }, 
			{ map = "24,-26", gather = true, path = "left" }, 
			{ map = "23,-26", gather = true, path = "bottom" }, 
			{ map = "23,-25", gather = true, path = "right" }, 
			{ map = "24,-25", gather = true, path = "right" }, 
			{ map = "25,-25", gather = true, path = "right" }, 
			{ map = "26,-25", gather = true, path = "bottom" }, 
			{ map = "26,-24", gather = true, path = "left" }, 
			{ map = "25,-24", gather = true, path = "bottom" }, 
			{ map = "25,-23", gather = true, path = "bottom" }, 
			{ map = 205260292, door = "303" },
			{ map = 207619084, gather = true, door = "220" },
			{ map = 207620108, gather = true, door = "130" },
			{ map = 209456132, gather = true, custom = function() path = 21 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "top" }, 
			{ map = "-25,11", path = "top" }, 
			{ map = "-25,10", path = "top" }, 
			{ map = "-25,9", path = "top" }, 
			{ map = "-25,8", path = "top" }, 
			{ map = "-25,7", path = "top" }, 
			{ map = "-25,6", path = "top" }, 
			{ map = "-25,5", path = "left" },   
			{ map = 171966987, door = "397" }, -- Entrée Mine Estrone
			{ map = 178785286, gather = true, door = "99" },
			{ map = 178785288, gather = true, custom = function() path = 22 map:door(558) end } },
			
		{ 	{ map = 178785286, gather = true, door = "559" },
			{ map = 171966987, path = "top" }, -- Entrée Mine Estrone
			{ map = "-26,4", path = "top" }, 
			{ map = "-26,3", path = "top" }, 
			{ map = "-26,2", path = "top" }, 
			{ map = "-26,1", path = "top" }, 
			{ map = "-26,0", path = "top" }, 
			{ map = "-26,-1", path = "top" }, 
			{ map = "-26,-2", path = "top" }, 
			{ map = "-26,-3", path = "top" }, 
			{ map = "-26,-4", path = "top" }, 
			{ map = "-26,-5", path = "top" }, 
			{ map = "-26,-6", path = "top" }, 
			{ map = "-26,-7", path = "right" }, 
			{ map = "-25,-7", path = "right" }, 
			{ map = "-24,-7", path = "right" }, 
			{ map = "-23,-7", path = "right" }, 
			{ map = "-22,-7", path = "right" }, 
			{ map = 171707908, door = "166" }, 
			{ map = 178784264, gather = true, custom = function() path = 1 map:changeMap("havenbag") end } }
	
	},
	
	["bauxite"] = {
	
		
		{ 	{ map = 162791424, path = "zaap(88212746)" },
			{ map = 88212746, path = "top" },
			{ map = "-1,12", path = "top" },
			{ map = "-1,11", path = "top" },
			{ map = "-1,10", path = "top" },
			{ map = "-1,9", path = "left" },
			{ map = "-2,9", path = "left" },
			{ map = 88213774, door = "353" }, -- Entrée Mine Istairameur
			{ map = 97259013, gather = true, path = "258" }, 
			{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "284" }, 
			{ map = 97255943, gather = true, custom = function() path = 2 map:changeMap("403") end } },
			
		{	{ map = 97260037, gather = true, path = "352" },
			{ map = 97261061, gather = true, path = "290" }, 
			{ map = 97259015, gather = true, custom = function() path = 3 map:changeMap("451") end } },
			
		{	{ map = 97261061, gather = true, path = "458" }, 
			{ map = 97260037, gather = true, path = "303" },
			{ map = 97257991, gather = true, custom = function() path = 4 map:changeMap("464") end } },
			
		{	{ map = 97260037, gather = true, path = "430" },
			{ map = 97259013, gather = true, path = "276" }, 
			{ map = 97256967, gather = true, path = "194" }, 
			{ map = 97260039, gather = true, path = "241" },
			{ map = 97261063, gather = true, path = "296" },
			{ map = 97255945, gather = true, path = "213" },
			{ map = 97256969, gather = true, custom = function() path = 5 map:changeMap("401") end } },
			
		{	{ map = 97255945, gather = true, path = "332" },
			{ map = 97260041, gather = true, custom = function() path = 6 map:changeMap("354") end } },
			
		
		{	{ map = 97261063, gather = true, path = "331" },
			{ map = 97255945, gather = true, path = "416" },
			{ map = 97259017, gather = true, custom = function() path = 7 map:changeMap("436") end } },
			
		{	{ map = 97256971, gather = true, path = "239" },
			{ map = 97255947, gather = true, path = "199" },
			{ map = 97261065, gather = true, path = "213" }, 
			{ map = 97257993, path = "122" }, 
			{ map = 97260039, gather = true, path = "262" },
			{ map = 97261063, gather = true, path = "459" },
			{ map = 97257995, gather = true, custom = function() path = 8 map:changeMap("374") end } },
			
		{	{ map = 97256971, gather = true, path = "234" },
			{ map = 97261067, gather = true, custom = function() path = 9 map:changeMap("521") end } },
			
		{	{ map = 97256971, gather = true, path = "503" },
			{ map = 97255947, gather = true, path = "500" },
			{ map = 97261065, gather = true, path = "236" },
			{ map = 97259019, gather = true, path = "276" },
			{ map = 97260043, gather = true, custom = function() path = 10 map:changeMap("havenbag") end } },
		
		
		{	{ map = 162791424, path = "zaap(88212746)" },
			{ map = 88212746, path = "top" },
			{ map = "-1,12", path = "top" },
			{ map = "-1,11", path = "top" },
			{ map = "-1,10", path = "top" },
			{ map = "-1,9", path = "top" },
			{ map = "-1,8", door = "369" },
			{ map = "-2,8", path = "left" },
			{ map = "-3,8", path = "left" },
			{ map = "-4,8", path = "left" },
			{ map = "-5,8", path = "left" },
			{ map = "-6,8", path = "top" },
			{ map = "-6,7", path = "left" },
			{ map = 104202753, door = "100" }, -- Entrée Mine Bwork non connue
			{ map = 104859143, gather = true, path = "160" },
			{ map = 104860167, gather = true, path = "205" },
			{ map = 104861191, gather = true, custom = function() path = 11 map:changeMap("457") end } },
			
		{	{ map = 104860167, gather = true, path = "478" },
			{ map = 104859143, gather = true, path = "171" },
			{ map = 104862215, gather = true, custom = function() path = 12 map:changeMap("472") end } },
			
		{	{ map = 104859143, gather = true, path = "543" },
			{ map = 104202753, gather = true, path = "right" },
			{ map = "-6,7", path = "top" },
			{ map = 104071168, door = "213" }, -- Entrée Mine des Bworks 2
			{ map = 104860165, gather = true, path = "242" },
			{ map = 104861189, path = "451" },
			{ map = 104862213, gather = true, path = "376" },
			{ map = 104858119, gather = true, custom = function() path = 13 map:changeMap("207") end } },
			
		{	{ map = 104071168, path = "top" }, -- Entrée Mine des Bworks 2
			{ map = 104860165, gather = true, path = "444" },
			{ map = 104071425, door = "199" }, -- Entrée Mine des Bworks 1
			{ map = 104859139, gather = true, custom = function() path = 14 map:changeMap("444") end } },
			
		{	{ map = 104071425, path = "right" }, -- Entrée Mine des Bworks 1
			{ map = "-5,5", path = "right" },
			{ map = "-4,5", path = "top" },
			{ map = "-4,4", path = "top" },
			{ map = "-4,3", path = "top" },
			{ map = 104072452, door = "248" }, -- Entrée Mine Campement des Gobelins
			{ map = 104858121, gather = true, path = "348" },
			{ map = 104860169, gather = true, path = "263" },
			{ map = 104861193, gather = true, path = "248" },
			{ map = 104862217, gather = true, custom = function() path = 15 map:changeMap("369") end } },
			
		{	{ map = 104861193, gather = true, path = "254" },
			{ map = 104859145, gather = true, path = "457" },
			{ map = 104858121, gather = true, path = "507" },
			{ map = 104072452, custom = function() path = 16 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "right" }, 
			{ map = "-24,12", path = "right" }, 
			{ map = "-23,12", path = "bottom" }, 
			{ map = "-23,13", path = "bottom" }, 
			{ map = "-23,14", path = "bottom" }, 
			{ map = "-23,15", path = "bottom" }, 
			{ map = "-23,16", path = "bottom" }, 
			{ map = 173018625, door = "511" },
			{ map = 173018626, path = "right" },
			{ map = 173019138, path = "bottom" },
			{ map = "-22,19", path = "left" }, 			
			{ map = "-23,19", path = "bottom" }, 
			{ map = "-23,20", path = "bottom" },  
			{ map = 173018629, door = "82" }, -- Entrée Mine Hipouce
			{ map = 178784260, gather = true, door = "421" },
			{ map = 178783236, gather = true, door = "309" },
			{ map = 178782214, gather = true, door = "507" },
			{ map = 178782216, gather = true, door = "422" },
			{ map = 178782218, gather = true, door = "476" },
			{ map = 178782220, gather = true, custom = function() path = 17 map:door(57) end } },
			
		{ 	{ map = 178784256, gather = true, custom = function() path = 18 map:door(505) end },
			{ map = 178783232, gather = true, door = "204" },
			{ map = 178783236, gather = true, door = "555" },
			{ map = 178782214, gather = true, door = "150" },
			{ map = 178782216, gather = true, door = "122" },
			{ map = 178782218, gather = true, door = "122" } },
			
		{	{ map = 178783232, gather = true, door = "403" },
			{ map = 178783234, gather = true, door = "281" },
			{ map = 178782210, gather = true, door = "185" },
			{ map = 178782208, gather = true, door = "421" }, -- 421
			{ map = 173017606, door = "88" }, -- 88
			{ map = 173017605, path = "right" },
			{ map = 173018117, path = "right" },
			{ map = "-23,21", path = "right" },
			{ map = "-22,21", path = "right" }, 
			{ map = "-21,21", path = "right" }, 
			{ map = "-20,21", path = "right" }, 
			{ map = "-19,21", path = "right" }, 
			{ map = "-18,21", path = "right" },   
			{ map = 172491782, door = "373" }, -- Entrée Mine Imale
			{ map = 178783240, gather = true, door = "277" },
			{ map = 178783242, gather = true, custom = function() path = 19 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(164364304)" },
			{ map = 164364304, path = "top" },
			{ map = "-20,-21", path = "top" }, 
			{ map = "-20,-22", path = "top" }, 
			{ map = "-20,-23", path = "top" }, 
			{ map = "-20,-24", path = "top" }, 
			{ map = "-20,-25", path = "top" }, 
			{ map = "-20,-26", path = "top" }, 
			{ map = "-20,-27", path = "left" }, 
			{ map = "-21,-27", path = "left" },    
			{ map = 164496393, door = "200" }, -- Entrée Passage vers Routes Rocailleuses
			{ map = 168036352, gather = true, door = "242" },
			{ map = 168035328, door = "188" },
			{ map = 168034304, door = "184" },
			{ map = 168034306, gather = true, path = "340" },
			{ map = 168034308, door = "464" },
			{ map = 168034310, gather = true, door = "493" },
			{ map = 168034312, gather = true, door = "215" },
			{ map = 168167424, door = "289" },
			{ map = 164102664, custom = function() path = 20 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(173278210)" },
			{ map = 173278210, path = "top" },
			{ map = "15,-58", path = "top" }, 
			{ map = "15,-59", path = "top" }, 
			{ map = "15,-60", path = "right" },    
			{ map = 173278720, door = "133" }, -- Entrée Mine Himum
			{ map = 173935364, gather = true, door = "297" },
			{ map = 173936388, gather = true, door = "450" },
			{ map = 173937412, gather = true, door = "382" },
			{ map = 173938436, gather = true, door = "367" },
			{ map = 173939460, gather = true, custom = function() path = 21 map:changeMap("havenbag") end } },
			
		{	{ map = 162791424, path = "zaap(207619076)" },
			{ map = 207619076, path = "436"},
			{ map = 206307842, path = "right" },
			{ map = "21,-29", gather = true, path = "right" }, 
			{ map = "22,-29", gather = true, path = "right" }, 
			{ map = "23,-29", gather = true, path = "bottom" }, 
			{ map = "23,-28", gather = true, path = "bottom" }, 
			{ map = "23,-27", gather = true, path = "right" }, 
			{ map = "24,-27", gather = true, path = "right" }, 
			{ map = "25,-27", gather = true, path = "right" }, 
			{ map = "26,-27", gather = true, path = "right" }, 
			{ map = "27,-27", gather = true, custom = aiguillage2 }, 
			{ map = "27,-28", gather = true, path = "bottom" }, 
			{ map = "27,-26", gather = true, path = "left" }, 
			{ map = "26,-26", gather = true, path = "left" }, 
			{ map = "25,-26", gather = true, path = "left" }, 
			{ map = "24,-26", gather = true, path = "left" }, 
			{ map = "23,-26", gather = true, path = "bottom" }, 
			{ map = "23,-25", gather = true, path = "right" }, 
			{ map = "24,-25", gather = true, path = "right" }, 
			{ map = "25,-25", gather = true, path = "right" }, 
			{ map = "26,-25", gather = true, path = "bottom" }, 
			{ map = "26,-24", gather = true, path = "left" }, 
			{ map = "25,-24", gather = true, path = "bottom" }, 
			{ map = "25,-23", gather = true, path = "bottom" }, 
			{ map = 205260292, door = "303" },
			{ map = 207619084, gather = true, door = "220" },
			{ map = 207620108, gather = true, door = "130" },
			{ map = 209456132, gather = true, custom = function() path = 22 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "top" }, 
			{ map = "-25,11", path = "top" }, 
			{ map = "-25,10", path = "top" }, 
			{ map = "-25,9", path = "top" }, 
			{ map = "-25,8", path = "top" }, 
			{ map = "-25,7", path = "top" }, 
			{ map = "-25,6", path = "top" }, 
			{ map = "-25,5", path = "left" },   
			{ map = 171966987, door = "397" }, -- Entrée Mine Estrone
			{ map = 178785286, gather = true, door = "99" },
			{ map = 178785288, gather = true, custom = function() path = 23 map:door(558) end } },
			
		{ 	{ map = 178785286, gather = true, door = "559" },
			{ map = 171966987, path = "top" }, -- Entrée Mine Estrone
			{ map = "-26,4", path = "top" }, 
			{ map = "-26,3", path = "top" }, 
			{ map = "-26,2", path = "top" }, 
			{ map = "-26,1", path = "top" }, 
			{ map = "-26,0", path = "top" }, 
			{ map = "-26,-1", path = "top" }, 
			{ map = "-26,-2", path = "top" }, 
			{ map = "-26,-3", path = "top" }, 
			{ map = "-26,-4", path = "top" }, 
			{ map = "-26,-5", path = "top" }, 
			{ map = "-26,-6", path = "top" }, 
			{ map = "-26,-7", path = "right" }, 
			{ map = "-25,-7", path = "right" }, 
			{ map = "-24,-7", path = "right" }, 
			{ map = "-23,-7", path = "right" }, 
			{ map = "-22,-7", path = "right" }, 
			{ map = 171707908, door = "166" }, 
			{ map = 178784264, gather = true, custom = function() path = 1 map:changeMap("havenbag") end } }
			
		
	
	},
	
	["or"] = {
		
		{ 	{ map = 162791424, path = "zaap(147590153)" },
			{ map = 147590153, path = "top" }, 
			{ map = "-17,-48", path = "top" },
			{ map = 147590151, door = "113" }, -- Entrée Mine des Plaines Rocheuses
			{ map = 164758273, gather = true, custom = function() path = 2 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(173278210)" },
			{ map = 173278210, path = "top" },
			{ map = "15,-58", path = "top" }, 
			{ map = "15,-59", path = "top" }, 
			{ map = "15,-60", path = "right" },    
			{ map = 173278720, door = "133" }, -- Entrée Mine Himum
			{ map = 173935364, gather = true, door = "297" },
			{ map = 173936388, gather = true, door = "450" },
			{ map = 173937412, gather = true, door = "382" },
			{ map = 173938436, gather = true, door = "367" },
			{ map = 173939460, gather = true, custom = function() path = 3 map:changeMap("havenbag") end } },
			
		{	{ map = 162791424, path = "zaap(207619076)" },
			{ map = 207619076, path = "436"},
			{ map = 206307842, path = "right" },
			{ map = "21,-29", gather = true, path = "right" }, 
			{ map = "22,-29", gather = true, path = "right" }, 
			{ map = "23,-29", gather = true, path = "bottom" }, 
			{ map = "23,-28", gather = true, path = "bottom" }, 
			{ map = "23,-27", gather = true, path = "right" }, 
			{ map = "24,-27", gather = true, path = "right" }, 
			{ map = "25,-27", gather = true, path = "right" }, 
			{ map = "26,-27", gather = true, path = "right" }, 
			{ map = "27,-27", gather = true, custom = aiguillage2 }, 
			{ map = "27,-28", gather = true, path = "bottom" }, 
			{ map = "27,-26", gather = true, path = "left" }, 
			{ map = "26,-26", gather = true, path = "left" }, 
			{ map = "25,-26", gather = true, path = "left" }, 
			{ map = "24,-26", gather = true, path = "left" }, 
			{ map = "23,-26", gather = true, path = "bottom" }, 
			{ map = "23,-25", gather = true, path = "right" }, 
			{ map = "24,-25", gather = true, path = "right" }, 
			{ map = "25,-25", gather = true, path = "right" }, 
			{ map = "26,-25", gather = true, path = "bottom" }, 
			{ map = "26,-24", gather = true, path = "left" }, 
			{ map = "25,-24", gather = true, path = "bottom" }, 
			{ map = "25,-23", gather = true, path = "bottom" }, 
			{ map = 205260292, door = "303" },
			{ map = 207619084, gather = true, door = "220" },
			{ map = 207620108, gather = true, door = "130" },
			{ map = 209456132, gather = true, custom = function() path = 4 map:changeMap("havenbag") end } },
			
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "top" }, 
			{ map = "-25,11", path = "top" }, 
			{ map = "-25,10", path = "top" }, 
			{ map = "-25,9", path = "top" }, 
			{ map = "-25,8", path = "top" }, 
			{ map = "-25,7", path = "top" }, 
			{ map = "-25,6", path = "top" }, 
			{ map = "-25,5", path = "left" },   
			{ map = 171966987, door = "397" }, -- Entrée Mine Estrone
			{ map = 178785286, gather = true, door = "99" },
			{ map = 178785288, gather = true, custom = function() path = 5 map:door(558) end } },
			
		{ 	{ map = 178785286, gather = true, door = "559" },
			{ map = 171966987, path = "top" }, -- Entrée Mine Estrone
			{ map = "-26,4", path = "top" }, 
			{ map = "-26,3", path = "top" }, 
			{ map = "-26,2", path = "top" }, 
			{ map = "-26,1", path = "top" }, 
			{ map = "-26,0", path = "top" }, 
			{ map = "-26,-1", path = "top" }, 
			{ map = "-26,-2", path = "top" }, 
			{ map = "-26,-3", path = "top" }, 
			{ map = "-26,-4", path = "top" }, 
			{ map = "-26,-5", path = "top" }, 
			{ map = "-26,-6", path = "top" }, 
			{ map = "-26,-7", path = "right" }, 
			{ map = "-25,-7", path = "right" }, 
			{ map = "-24,-7", path = "right" }, 
			{ map = "-23,-7", path = "right" }, 
			{ map = "-22,-7", path = "right" }, 
			{ map = 171707908, door = "166" }, 
			{ map = 178784264, gather = true, custom = function() path = 6 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88085249)" },
			{ map = 88085249, path = "left" }, 
			{ map = "9,22", path = "left" },
			{ map = "8,22", path = "left" },
			{ map = "7,22", path = "left" },
			{ map = "6,22", path = "left" },
			{ map = "5,22", path = "top" },
			{ map = "5,21", path = "top" },
			{ map = "5,20", path = "top" },
			{ map = 88082692, door = "332" }, -- Entrée Mine Hérale
			{ map = 97260033, gather = true, path = "183" },  
			{ map = 97261059, gather = true, custom = function() path = 7 map:changeMap("417") end } },
			
		{	{ map = 97260033, gather = true, path = "405" },
			{ map = 97261057, gather = true, path = "235" },
			{ map = 97255939, gather = true, path = "446" },
			{ map = 97256963, gather = true, path = "492" },
			{ map = 97257987, gather = true, path = "492" },
			{ map = 97260035, gather = true, custom = function() path = 8 map:changeMap("288") end } },
			
		{	{ map = 97261057, gather = true, path = "421" },
			{ map = 97257987, gather = true, path = "212" },
			{ map = 97259011, gather = true, custom = function() path = 9 map:changeMap("havenbag") end } },
			
		{	{ map = 162791424, path = "zaap(88085249)" },
			{ map = 88085249, path = "right" }, 
			{ map = "11,22", path = "right" }, 
			{ map = "12,22", path = "right" }, 
			{ map = "13,22", path = "right" }, 
			{ map = "14,22", path = "top" }, 
			{ map = "14,21", path = "top" }, 
			{ map = "14,20", path = "top" }, 
			{ map = "14,19", path = "top" }, 
			{ map = "14,18", path = "top" }, 
			{ map = "14,17", path = "top" }, 
			{ map = "14,16", path = "top" }, 
			{ map = "14,15", path = "top" }, 
			{ map = 88087305, door = "403" }, -- Tunnel de Kartonpath
			{ map = 117440512, door = "222" },
			{ map = 117441536, gather = true, door = "167" },
			{ map = 117442560, gather = true, door = "488" },
			{ map = 117443584, gather = true, door = "221" },
			{ map = 117440514, gather = true, door = "293" },
			{ map = 117441538, gather = true, door = "251" },
			{ map = 117442562, gather = true, custom = function() path = 10 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88213271)" },
			{ map = 88213271, path = "top" }, 
			{ map = "-2,-1", path = "top" },
			{ map = "-2,-2", path = "top" },
			{ map = "-2,-3", path = "top" },
			{ map = "-2,-4", path = "top" },
			{ map = 185862148, door = "367" }, -- Entrée Mine Astirite
			{ map = 97255951, path = "203" }, 
			{ map = 97256975, gather = true, path = "323" },
			{ map = 97257999, gather = true, path = "247" }, 
			{ map = 97259023, gather = true, custom = function() path = 11 map:changeMap("451") end } },
			
		{ 	{ map = 97257999, gather = true, path = "268" }, 
			{ map = 97260047, gather = true, path = "379" }, 
			{ map = 97261071, gather = true, custom = function() path = 12 map:changeMap("havenbag") end } },
			
		
		
		{	{ map = 162791424, path = "zaap(88212746)" },
			{ map = 88212746, path = "top" },
			{ map = "-1,12", path = "top" },
			{ map = "-1,11", path = "top" },
			{ map = "-1,10", path = "top" },
			{ map = "-1,9", path = "top" },
			{ map = "-1,8", door = "369" },
			{ map = "-2,8", path = "left" },
			{ map = "-3,8", path = "left" },
			{ map = "-4,8", path = "left" },
			{ map = "-5,8", path = "left" },
			{ map = "-6,8", path = "top" },
			{ map = "-6,7", path = "left" },
			{ map = 104202753, door = "100" }, -- Entrée Mine Bwork non connue
			{ map = 104859143, gather = true, path = "160" },
			{ map = 104860167, gather = true, path = "205" },
			{ map = 104861191, gather = true, custom = function() path = 13 map:changeMap("457") end } },
			
		{	{ map = 104860167, gather = true, path = "478" },
			{ map = 104859143, gather = true, path = "171" },
			{ map = 104862215, gather = true, custom = function() path = 14 map:changeMap("472") end } },
			
		{	{ map = 104859143, gather = true, path = "543" },
			{ map = 104202753, gather = true, path = "right" },
			{ map = "-6,7", path = "top" },
			{ map = 104071168, door = "213" }, -- Entrée Mine des Bworks 2
			{ map = 104860165, gather = true, path = "242" },
			{ map = 104861189, path = "451" },
			{ map = 104862213, gather = true, path = "376" },
			{ map = 104858119, gather = true, custom = function() path = 15 map:changeMap("207") end } },
			
		{	{ map = 104071168, path = "top" }, -- Entrée Mine des Bworks 2
			{ map = 104860165, gather = true, path = "444" },
			{ map = 104071425, door = "199" }, -- Entrée Mine des Bworks 1
			{ map = 104859139, gather = true, custom = function() path = 16 map:changeMap("444") end } },
			
		{	{ map = 104071425, path = "right" }, -- Entrée Mine des Bworks 1
			{ map = "-5,5", path = "right" },
			{ map = "-4,5", path = "top" },
			{ map = "-4,4", path = "top" },
			{ map = "-4,3", path = "top" },
			{ map = 104072452, door = "248" }, -- Entrée Mine Campement des Gobelins
			{ map = 104858121, gather = true, path = "348" },
			{ map = 104860169, gather = true, path = "263" },
			{ map = 104861193, gather = true, path = "248" },
			{ map = 104862217, gather = true, custom = function() path = 17 map:changeMap("369") end } },
			
		{	{ map = 104861193, gather = true, path = "254" },
			{ map = 104859145, gather = true, path = "457" },
			{ map = 104858121, gather = true, path = "507" },
			{ map = 104072452, custom = function() path = 18 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "right" }, 
			{ map = "-24,12", path = "right" }, 
			{ map = "-23,12", path = "bottom" }, 
			{ map = "-23,13", path = "bottom" }, 
			{ map = "-23,14", path = "bottom" }, 
			{ map = "-23,15", path = "bottom" }, 
			{ map = "-23,16", path = "bottom" }, 
			{ map = 173018625, door = "511" },
			{ map = 173018626, path = "right" },
			{ map = 173019138, path = "bottom" },
			{ map = "-22,19", path = "left" }, 			
			{ map = "-23,19", path = "bottom" }, 
			{ map = "-23,20", path = "bottom" },  
			{ map = 173018629, door = "82" }, -- Entrée Mine Hipouce
			{ map = 178784260, gather = true, door = "421" },
			{ map = 178783236, gather = true, door = "309" },
			{ map = 178782214, gather = true, door = "507" },
			{ map = 178782216, gather = true, door = "422" },
			{ map = 178782218, gather = true, door = "476" },
			{ map = 178782220, gather = true, custom = function() path = 19 map:door(57) end } },
			
		{ 	{ map = 178784256, gather = true, custom = function() path = 20 map:door(505) end },
			{ map = 178783232, gather = true, door = "204" },
			{ map = 178783236, gather = true, door = "555" },
			{ map = 178782214, gather = true, door = "150" },
			{ map = 178782216, gather = true, door = "122" },
			{ map = 178782218, gather = true, door = "122" } },
			
		{	{ map = 178783232, gather = true, door = "403" },
			{ map = 178783234, gather = true, door = "281" },
			{ map = 178782210, gather = true, door = "185" },
			{ map = 178782208, gather = true, door = "421" }, -- 421
			{ map = 173017606, door = "88" }, -- 88
			{ map = 173017605, path = "right" },
			{ map = 173018117, path = "right" },
			{ map = "-23,21", path = "right" },
			{ map = "-22,21", path = "right" }, 
			{ map = "-21,21", path = "right" }, 
			{ map = "-20,21", path = "right" }, 
			{ map = "-19,21", path = "right" }, 
			{ map = "-18,21", path = "right" },   
			{ map = 172491782, door = "373" }, -- Entrée Mine Imale
			{ map = 178783240, gather = true, door = "277" },
			{ map = 178783242, gather = true, custom = function() path = 21 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88212481)" },
			{ map = 88212481, path = "right" },
			{ map = 72619522, door = "132" }, -- Entrée Mine Porcos 1
			{ map = 30672658, gather = true, path = "362" },
			{ map = 30672655, gather = true, path = "221" },			
			{ map = 30672649, gather = true, custom = function() path = 22 map:changeMap("408") end }, 
			{ map = "0,24", path = "right" }, 
			{ map = "1,24", path = "bottom" }, 
			{ map = "1,25", path = "bottom" }, 
			{ map = "1,26", path = "bottom" }, 
			{ map = "1,27", path = "bottom" }, 
			{ map = "1,28", path = "bottom" }, 
			{ map = "1,29", path = "bottom" }, 
			{ map = "1,30", path = "bottom" },
			{ map = "1,31", path = "bottom" } },
			
		{	{ map = 30672655, gather = true, path = "492" },			
			{ map = 30672652, gather = true, custom = function() path = 23 map:changeMap("289") end } },
			
		{ 	{ map = 72619522, path = "bottom" },
			{ map = 30672658, gather = true, path = "477" },
			{ map = 30672655, gather = true, path = "270" },			
			{ map = "1,33", path = "left" },
			{ map = "0,33", path = "left" },
			{ map = 72618499, door = "231" }, -- Entrée Mine Porcos 2
			{ map = 72222720, gather = true, custom = function() path = 24 map:changeMap("464") end } },
			
		{ 	{ map = 72618499, door = "71" }, -- Entrée Mine Porcos 2
			{ map = 30671116, gather = true, path = "292" },
			{ map = 30671110, gather = true, path = "479" },
			{ map = 30671107, gather = true, path = "298" },
			{ map = 30670848, gather = true, custom = function() path = 25 map:changeMap("havenbag") end } },
			
			
		{ 	{ map = 162791424, path = "zaap(164364304)" },
			{ map = 164364304, path = "top" },
			{ map = "-20,-21", path = "top" }, 
			{ map = "-20,-22", path = "top" }, 
			{ map = "-20,-23", path = "top" }, 
			{ map = "-20,-24", path = "top" }, 
			{ map = "-20,-25", path = "top" }, 
			{ map = "-20,-26", path = "top" }, 
			{ map = "-20,-27", path = "left" }, 
			{ map = "-21,-27", path = "left" },    
			{ map = 164496393, door = "200" }, -- Entrée Passage vers Routes Rocailleuses
			{ map = 168036352, gather = true, door = "242" },
			{ map = 168035328, door = "188" },
			{ map = 168034304, door = "184" },
			{ map = 168034306, gather = true, path = "340" },
			{ map = 168034308, door = "464" },
			{ map = 168034310, gather = true, door = "493" },
			{ map = 168034312, gather = true, door = "215" },
			{ map = 168167424, door = "289" },
			{ map = 164102664, custom = function() path = 1 map:changeMap("havenbag") end } }
			
	
	},
	
	["dolomite"] = {
	
	
		{	{ map = "162791424", path = "zaap(68419587)" },
			{ map = "7,-4", path = "bottom" },
			{ map = "7,-3", path = "right" },
			{ map = "8,-3", path = "right" },
			{ map = "9,-3", path = "right" },
			{ map = "10,-3", custom = function() npc:npc(6801, 3) npc:reply(-3) end },
			{ map = "37,-76", path = "left" },
			{ map = "36,-76", custom = function() npc:npc(6883, 3) npc:reply(-1) end },
			{ map = "227278848", gather = true, path = "right" },
			{ map = "227279106", gather = true, path = "top" },
			{ map = "227279108", gather = true, path = "left" },			
			{ map = "223085059", gather = true, path = "left" },			
			{ map = "223216131", gather = true, path = "top" },		
			{ map = "223216129", gather = true, path = "top" },			
			{ map = "223216385", gather = true, path = "right" },			
			{ map = "223085313", gather = true, path = "right" },			
			{ map = "223086337", gather = true, door = "511" },			
			{ map = "223086086", gather = true, path = "bottom" },			
			{ map = "223086088", gather = true, path = "right" },			
			{ map = "223087112", gather = true, path = "bottom" },			
			{ map = "223087114", gather = true, path = "left" },			
			{ map = "223086090", gather = true, path = "left" },			
			{ map = "223085066", gather = true, path = "top" },			
			{ map = "223085064", gather = true, path = "left" },			
			{ map = "223216136", gather = true, path = "top" },			
			{ map = "223216134", gather = true, path = "havenbag", custom = function() path = 2 end } },
			
		{	{ map = "162791424", path = "zaap(207619076)" },
			{ map = "207619076", path = "436"},
			{ map = "206307842", path = "bottom" },
			{ map = "20,-28", path = "bottom" }, 
			{ map = "20,-27", path = "right" }, 
			{ map = "21,-27", path = "right" }, 
			{ map = "22,-27", gather = true, path = "bottom" }, 
			{ map = "22,-26", gather = true, path = "right" }, 
			{ map = "23,-26", gather = true, path = "right" }, 
			{ map = "24,-26", gather = true, path = "bottom" }, 
			{ map = "24,-25", gather = true, path = "bottom" }, 
			{ map = "24,-24", gather = true, path = "bottom" }, 
			{ map = "24,-23", gather = true, path = "bottom" }, 
			{ map = "24,-22", gather = true, path = "right" }, 
			{ map = "205260292", door = "303" },
			{ map = "207619084", gather = true, door = "220" },
			{ map = "207620108", gather = true, path = "right" },
			{ map = "207621132", gather = true, path = "havenbag", custom = function() path = 3 end } },
			
		{ 	{ map = 162791424, path = "zaap(147590153)" },
			{ map = 147590153, path = "top" }, 
			{ map = "-17,-48", path = "top" },
			{ map = 147590151, door = "113" }, -- Entrée Mine des Plaines Rocheuses
			{ map = 164758273, gather = true, custom = function() path = 4 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(173278210)" },
			{ map = 173278210, path = "top" },
			{ map = "15,-58", path = "top" }, 
			{ map = "15,-59", path = "top" }, 
			{ map = "15,-60", path = "right" },    
			{ map = 173278720, door = "133" }, -- Entrée Mine Himum
			{ map = 173935364, gather = true, door = "297" },
			{ map = 173936388, gather = true, door = "450" },
			{ map = 173937412, gather = true, door = "382" },
			{ map = 173938436, gather = true, door = "367" },
			{ map = 173939460, gather = true, custom = function() path = 5 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(171967506)" },
			{ map = 171967506, path = "top" }, 
			{ map = "-25,11", path = "top" }, 
			{ map = "-25,10", path = "top" }, 
			{ map = "-25,9", path = "top" }, 
			{ map = "-25,8", path = "top" }, 
			{ map = "-25,7", path = "top" }, 
			{ map = "-25,6", path = "top" }, 
			{ map = "-25,5", path = "left" },   
			{ map = 171966987, door = "397" }, -- Entrée Mine Estrone
			{ map = 178785286, gather = true, door = "99" },
			{ map = 178785288, gather = true, custom = function() path = 6 map:door(558) end } },
			
		{ 	{ map = 178785286, gather = true, door = "559" },
			{ map = 171966987, path = "top" }, -- Entrée Mine Estrone
			{ map = "-26,4", path = "top" }, 
			{ map = "-26,3", path = "top" }, 
			{ map = "-26,2", path = "top" }, 
			{ map = "-26,1", path = "top" }, 
			{ map = "-26,0", path = "top" }, 
			{ map = "-26,-1", path = "top" }, 
			{ map = "-26,-2", path = "top" }, 
			{ map = "-26,-3", path = "top" }, 
			{ map = "-26,-4", path = "top" }, 
			{ map = "-26,-5", path = "top" }, 
			{ map = "-26,-6", path = "top" }, 
			{ map = "-26,-7", path = "right" }, 
			{ map = "-25,-7", path = "right" }, 
			{ map = "-24,-7", path = "right" }, 
			{ map = "-23,-7", path = "right" }, 
			{ map = "-22,-7", path = "right" }, 
			{ map = 171707908, door = "166" }, 
			{ map = 178784264, gather = true, custom = function() path = 7 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88085249)" },
			{ map = 88085249, path = "left" }, 
			{ map = "9,22", path = "left" },
			{ map = "8,22", path = "left" },
			{ map = "7,22", path = "left" },
			{ map = "6,22", path = "left" },
			{ map = "5,22", path = "top" },
			{ map = "5,21", path = "top" },
			{ map = "5,20", path = "top" },
			{ map = 88082692, door = "332" }, -- Entrée Mine Hérale
			{ map = 97260033, gather = true, path = "183" },  
			{ map = 97261059, gather = true, custom = function() path = 8 map:changeMap("417") end } },
			
		{	{ map = 97260033, gather = true, path = "405" },
			{ map = 97261057, gather = true, path = "235" },
			{ map = 97255939, gather = true, path = "446" },
			{ map = 97256963, gather = true, path = "492" },
			{ map = 97257987, gather = true, path = "492" },
			{ map = 97260035, gather = true, custom = function() path = 9 map:changeMap("288") end } },
			
		{	{ map = 97261057, gather = true, path = "421" },
			{ map = 97257987, gather = true, path = "212" },
			{ map = 97259011, gather = true, custom = function() path = 10 map:changeMap("havenbag") end } },
			
		{	{ map = 162791424, path = "zaap(88085249)" },
			{ map = 88085249, path = "right" }, 
			{ map = "11,22", path = "right" }, 
			{ map = "12,22", path = "right" }, 
			{ map = "13,22", path = "right" }, 
			{ map = "14,22", path = "top" }, 
			{ map = "14,21", path = "top" }, 
			{ map = "14,20", path = "top" }, 
			{ map = "14,19", path = "top" }, 
			{ map = "14,18", path = "top" }, 
			{ map = "14,17", path = "top" }, 
			{ map = "14,16", path = "top" }, 
			{ map = "14,15", path = "top" }, 
			{ map = 88087305, door = "403" }, -- Tunnel de Kartonpath
			{ map = 117440512, door = "222" },
			{ map = 117441536, gather = true, door = "167" },
			{ map = 117442560, gather = true, door = "488" },
			{ map = 117443584, gather = true, door = "221" },
			{ map = 117440514, gather = true, door = "293" },
			{ map = 117441538, gather = true, door = "251" },
			{ map = 117442562, gather = true, custom = function() path = 11 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88213271)" },
			{ map = 88213271, path = "top" }, 
			{ map = "-2,-1", path = "top" },
			{ map = "-2,-2", path = "top" },
			{ map = "-2,-3", path = "top" },
			{ map = "-2,-4", path = "top" },
			{ map = 185862148, door = "367" }, -- Entrée Mine Astirite
			{ map = 97255951, path = "203" }, 
			{ map = 97256975, gather = true, path = "323" },
			{ map = 97257999, gather = true, path = "247" }, 
			{ map = 97259023, gather = true, custom = function() path = 12 map:changeMap("451") end } },
			
		{ 	{ map = 97257999, gather = true, path = "268" }, 
			{ map = 97260047, gather = true, path = "379" }, 
			{ map = 97261071, gather = true, custom = function() path = 13 map:changeMap("havenbag") end } },
			
		
		
		{	{ map = 162791424, path = "zaap(88212746)" },
			{ map = 88212746, path = "top" },
			{ map = "-1,12", path = "top" },
			{ map = "-1,11", path = "top" },
			{ map = "-1,10", path = "top" },
			{ map = "-1,9", path = "top" },
			{ map = "-1,8", door = "369" },
			{ map = "-2,8", path = "left" },
			{ map = "-3,8", path = "left" },
			{ map = "-4,8", path = "left" },
			{ map = "-5,8", path = "left" },
			{ map = "-6,8", path = "top" },
			{ map = "-6,7", path = "left" },
			{ map = 104202753, door = "100" }, -- Entrée Mine Bwork non connue
			{ map = 104859143, gather = true, path = "160" },
			{ map = 104860167, gather = true, path = "205" },
			{ map = 104861191, gather = true, custom = function() path = 14 map:changeMap("457") end } },
			
		{	{ map = 104860167, gather = true, path = "478" },
			{ map = 104859143, gather = true, path = "171" },
			{ map = 104862215, gather = true, custom = function() path = 15 map:changeMap("472") end } },
			
		{	{ map = 104859143, gather = true, path = "543" },
			{ map = 104202753, gather = true, path = "right" },
			{ map = "-6,7", path = "top" },
			{ map = 104071168, door = "213" }, -- Entrée Mine des Bworks 2
			{ map = 104860165, gather = true, path = "242" },
			{ map = 104861189, path = "451" },
			{ map = 104862213, gather = true, path = "376" },
			{ map = 104858119, gather = true, custom = function() path = 16 map:changeMap("207") end } },
			
		{	{ map = 104071168, path = "top" }, -- Entrée Mine des Bworks 2
			{ map = 104860165, gather = true, path = "444" },
			{ map = 104071425, door = "199" }, -- Entrée Mine des Bworks 1
			{ map = 104859139, gather = true, custom = function() path = 17 map:changeMap("444") end } },
			
		{	{ map = 104071425, path = "right" }, -- Entrée Mine des Bworks 1
			{ map = "-5,5", path = "right" },
			{ map = "-4,5", path = "top" },
			{ map = "-4,4", path = "top" },
			{ map = "-4,3", path = "top" },
			{ map = 104072452, door = "248" }, -- Entrée Mine Campement des Gobelins
			{ map = 104858121, gather = true, path = "348" },
			{ map = 104860169, gather = true, path = "263" },
			{ map = 104861193, gather = true, path = "248" },
			{ map = 104862217, gather = true, custom = function() path = 18 map:changeMap("369") end } },
			
		{	{ map = 104861193, gather = true, path = "254" },
			{ map = 104859145, gather = true, path = "457" },
			{ map = 104858121, gather = true, path = "507" },
			{ map = 104072452, custom = function() path = 19 map:changeMap("havenbag") end } },
			
			
		{ 	{ map = 178784256, gather = true, custom = function() path = 20 map:door(505) end },
			{ map = 178783232, gather = true, door = "204" },
			{ map = 178783236, gather = true, door = "555" },
			{ map = 178782214, gather = true, door = "150" },
			{ map = 178782216, gather = true, door = "122" },
			{ map = 178782218, gather = true, door = "122" } },
			
		{	{ map = 178783232, gather = true, door = "403" },
			{ map = 178783234, gather = true, door = "281" },
			{ map = 178782210, gather = true, door = "185" },
			{ map = 178782208, gather = true, door = "421" }, -- 421
			{ map = 173017606, door = "88" }, -- 88
			{ map = 173017605, path = "right" },
			{ map = 173018117, path = "right" },
			{ map = "-23,21", path = "right" },
			{ map = "-22,21", path = "right" }, 
			{ map = "-21,21", path = "right" }, 
			{ map = "-20,21", path = "right" }, 
			{ map = "-19,21", path = "right" }, 
			{ map = "-18,21", path = "right" },   
			{ map = 172491782, door = "373" }, -- Entrée Mine Imale
			{ map = 178783240, gather = true, door = "277" },
			{ map = 178783242, gather = true, custom = function() path = 21 map:changeMap("havenbag") end } },
			
		{ 	{ map = 162791424, path = "zaap(88212481)" },
			{ map = 88212481, path = "right" },
			{ map = 72619522, door = "132" }, -- Entrée Mine Porcos 1
			{ map = 30672658, gather = true, path = "362" },
			{ map = 30672655, gather = true, path = "221" },			
			{ map = 30672649, gather = true, custom = function() path = 22 map:changeMap("408") end }, 
			{ map = "0,24", path = "right" }, 
			{ map = "1,24", path = "bottom" }, 
			{ map = "1,25", path = "bottom" }, 
			{ map = "1,26", path = "bottom" }, 
			{ map = "1,27", path = "bottom" }, 
			{ map = "1,28", path = "bottom" }, 
			{ map = "1,29", path = "bottom" }, 
			{ map = "1,30", path = "bottom" },
			{ map = "1,31", path = "bottom" } },
			
		{	{ map = 30672655, gather = true, path = "492" },			
			{ map = 30672652, gather = true, custom = function() path = 23 map:changeMap("289") end } },
			
		{ 	{ map = 72619522, path = "bottom" },
			{ map = 30672658, gather = true, path = "477" },
			{ map = 30672655, gather = true, path = "270" },			
			{ map = "1,33", path = "left" },
			{ map = "0,33", path = "left" },
			{ map = 72618499, door = "231" }, -- Entrée Mine Porcos 2
			{ map = 72222720, gather = true, custom = function() path = 24 map:changeMap("464") end } },
			
		{ 	{ map = 72618499, door = "71" }, -- Entrée Mine Porcos 2
			{ map = 30671116, gather = true, path = "292" },
			{ map = 30671110, gather = true, path = "479" },
			{ map = 30671107, gather = true, path = "298" },
			{ map = 30670848, gather = true, custom = function() path = 25 map:changeMap("havenbag") end } },
			
			
		{ 	{ map = 162791424, path = "zaap(164364304)" },
			{ map = 164364304, path = "top" },
			{ map = "-20,-21", path = "top" }, 
			{ map = "-20,-22", path = "top" }, 
			{ map = "-20,-23", path = "top" }, 
			{ map = "-20,-24", path = "top" }, 
			{ map = "-20,-25", path = "top" }, 
			{ map = "-20,-26", path = "top" }, 
			{ map = "-20,-27", path = "left" }, 
			{ map = "-21,-27", path = "left" },    
			{ map = 164496393, door = "200" }, -- Entrée Passage vers Routes Rocailleuses
			{ map = 168036352, gather = true, door = "242" },
			{ map = 168035328, door = "188" },
			{ map = 168034304, door = "184" },
			{ map = 168034306, gather = true, path = "340" },
			{ map = 168034308, door = "464" },
			{ map = 168034310, gather = true, door = "493" },
			{ map = 168034312, gather = true, door = "215" },
			{ map = 168167424, door = "289" },
			{ map = 164102664, custom = function() path = 1 map:changeMap("havenbag") end } }
			
	
	}

}

function setPath()
	local newStep = ""
	if job:level(24) < 40 then
		newStep = "fer"
	elseif job:level(24) >= 40 and job:level(24) < 60 then
		newStep = "bronze"
	elseif job:level(24) >= 60 and job:level(24) < 80 then
		newStep = "kobalte"
	elseif job:level(24) >= 80 and job:level(24) < 100 then
		newStep = "manganèse"
	elseif job:level(24) >= 100 and job:level(24) < 120 then
		newStep = "étain"
	elseif job:level(24) >= 120 and job:level(24) < 140 then
		newStep = "argent"
	elseif job:level(24) >= 140 and job:level(24) < 160 then
		newStep = "bauxite"
	elseif job:level(24) >= 160 and job:level(24) < 180 then
		newStep = "or"
	else
		newStep = "dolomite"
	end
	if newStep ~= step then
		local formerStep = step
		local formerPath = path
		global:printMessage("[Information] Nouvelle étape en cours : "..newStep)
		step = newStep
		path = 1
		notSetStep = false
		if map:currentMapId() ~= 162791424 then
			map:changeMap("havenbag")
			notSetStep = true
			step = formerStep
			path = formerPath
			return move()
		else
			return move()
		end
	end
end




function craftAlliage()
	map:door(230)
	for i, ressource in pairs(currentAlliage) do
		craft:putItem(ressource.ressourceId, ressource.requiredQuantity)
	end
	craft:changeQuantityToCraft(qtAlliage)
	craft:ready()
	global:leaveDialog()
	step = "bank"
	map:changeMap("havenbag")
end

function deathDetection()
	formerEnergy = currentEnergy
	currentEnergy = character:energyPoints()
	if currentEnergy < formerEnergy then
		path = 1
		global:printMessage("Le bot est mort en combat, téléportation dans le havre-sac")
		map:changeMap("havenbag")
	end
end



function move()
	deathDetection()
	if step == "bank" then
		return bank()
	elseif step == "craft" then
		local path = {
			{ map = 217059328, path = "518" },
			{ map = 212600322, path = "zaapi(212602886)" },
			{ map = 212602886, door = "345" },
			{ map = 217060356, custom = craftAlliage }
		}
		for k,v in pairs(path) do
			if map:currentMapId() == v.map then
				return {v}
			end
		end
	else
	    if inventory:podsP() >= 95 and map:currentMapId() == 162791424 then
	        step = "bank"
	        return bank()
	    elseif inventory:podsP() >= 95 and map:currentMapId() ~= 162791424 then
			map:changeMap("havenbag")
			global:printMessage("Impossible d'accèder au havre-sac depuis cette map, le bot continue son chemin jusqu'à trouver une map où il peut se tp")
		end
		setPath()
		return chemins[step][path]
	end
end



function bank()
	local path = {
		{ map = 162791424, path = "zaap(212600323)" },
		{ map = 212600323, path = "top" },
		{ map = 212600322, door = "468" },
		{ map = 217059328, custom = checkBank }
	}
	for k,v in pairs(path) do
		if map:currentMapId() == v.map then
			return {v}
		end
	end
end

