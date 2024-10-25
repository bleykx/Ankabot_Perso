AUTO_DELETE = {}
GATHER = {}
MIN_MONSTERS = 1
MAX_MONSTERS = 8
ZoneIncarnam = 1
local haveToWait = true
local needLaine = true
local needPlpp = true
local needCouteau = true

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\PathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\FightPathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Stuff\\StuffManager.lua")

local PathManager = PathManager:new()
local FightPathManager = FightPathManager:new()

function move()
    Wait()
    equipCouteauChasse()

    if (map:currentArea() == "Incarnam") then
        if(job:level(41) < 10) then
            EnoughtForCouteau()
            NeedFarmViande()
            if (needCouteau == true) then
                if (needLaine == false) then
                    ZoneIncarnam = 2
                    if (needPlpp == false) then
                        ZoneIncarnam = 3
                    end
                end
            end
        else
            ZoneIncarnam = 5
        end
    elseif (map:currentArea() == "Astrub") then
        return PathManager:SortirTempleAstrub()
    end

    if ZoneIncarnam == 1 then
        global:printMessage("[Script] Je vais au paturage !")
        return FightPathManager:FarmPaturageIncarnam()

    elseif ZoneIncarnam == 2 then
        global:printMessage("[Script] Je vais aux champs !")
        return FightPathManager:FarmChampsIncarnam()

    elseif ZoneIncarnam == 3 then
        global:printMessage("[Script] Je vais à l'atelier !")
        return PathManager:AtelierForgeronIncarnamFromIncarnam()

    elseif ZoneIncarnam == 4 then
        global:printMessage("[Script] Je vais craft les viandes !")
        return PathManager:AtelierChasseurIncarnamFromIncarnam()

    elseif ZoneIncarnam == 5 then
        global:printMessage("[Script] Je vais à Astrub !")
        return PathManager:IncarnamToAstrub()
    elseif ZoneIncarnam == 6 then
        global:printMessage("[Script] Je vais à la Route des ames !")
        return FightPathManager:FarmRouteDesAmes()
    end
end

function bank()
    if (map:currentArea() == "Incarnam") then
        PathManager:IncarnamToAstrub()
    end
    if(map:currentMapId() == BankMapId) then
        FarmerBotBankManager:PoseInventory()
        global:printMessage("[Bank] Je vais sortir de la banque")
        return PathManager:SortirBanqueAstrub()
    elseif(map:currentMapId() == BankOutdoorMapId) then
            global:printMessage("[Bank] Je vais rentrer dans la banque")
            return PathManager:EntrerBanqueAstrub()
    end
    return PathManager:BankAstrubFromAstrub()
end

function phenix()
    return {
    }
end

function stopped()
end

function banned()
    global:printError("Banned")

end

function mule_lost(bossMapId)
    global:printSuccess(bossMapId)

end

function Wait()
    if haveToWait then
        local totalTime = global:totalTime()
        local hoursToWait = 18
        local secondToWait = hoursToWait * 60 * 60

        if(totalTime < secondToWait) then
            local timeToWait = hoursToWait * 60 * 60 * 1000
            global:delay(timeToWait)
            haveToWait = false

            return {
                global:printColor("#01F4FF", "Le Bot a attendu " ..hoursToWait.. " heures."),
             }
        end
    end

    haveToWait = false
end

function EnoughtForCouteau()
    if(inventory:itemCount(519) >= 3) or (inventory:equipItem(1934, 1) == true) then
        needPlpp = false
        --global:printMessage("Plus besoin de perlinpinpin")
    end
    if(inventory:itemCount(16511) >= 3) or (inventory:equipItem(1934, 1) == true) then
        needLaine = false
        --global:printMessage("Plus besoin de laine")
    end
end

function craftchasseur()
    map:useById(489177, -1)
    global:delay(2148)
	craft:putItem(16511, 3) -- mettre les 3 laine de bouf
	global:delay(1678)
	craft:putItem(519, 3) -- mettre les 3 poudre de perlinpinpin
	global:delay(1728)
	craft:changeQuantityToCraft(1) -- mettre 1 craft
	global:delay(2099)
	craft:ready() -- lancer le craft
    global:delay(1299)
    global:leaveDialog()
    equipCouteauChasse()
    map:moveToCell(313)
end

function craftlesviandes()
    map:useById(489360, -1)
    global:delay(2148)
	craft:putItem(16663, 1) -- mettre 1 viande intengible
	global:delay(1678)
	craft:changeQuantityToCraft(77) -- mettre 77 crafts
	global:delay(2099)
	craft:ready() -- lancer le craft
    global:delay(1299)
    global:leaveDialog()
    ZoneIncarnam = 5
    map:moveToCell(372)
end

function NeedFarmViande()
    if(inventory:itemCount(16663)<= 77 and needCouteau == false) then
        global:printMessage("Je vais chercher de la viande !")
        ChooseRandomArea()
    elseif(needCouteau == false) then
        global:printMessage("J'ai assez de viande !")
        ZoneIncarnam = 4
    end
end

function equipCouteauChasse()
    if(inventory:itemPosition(1934) == 1) then
        needCouteau = false
    end
    if(inventory:equipItem(1934, 1) == true) then
        global:printMessage("Je m'équipe du couteau de Chasse !")
        needCouteau = false
    end
end

function ChooseRandomArea()
    local random = math.random(1, 3)
    if random == 1 then
        ZoneIncarnam = 1
    elseif random == 2 then
        ZoneIncarnam = 2
    elseif random == 3 then
        ZoneIncarnam = 6
    end
end