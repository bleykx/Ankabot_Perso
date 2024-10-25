-- ================================================================================
-- = Script           : [ALCHIMISTE][NO-ABO] Potions de Souvenir Click'n Go ! =
-- = Author           : @Dampen59#4187                                            =
-- = Version          : 1.2                                                       =
-- = Creation Date    : 28/05/2020                                                =
-- = Last Update Date : 29/05/2020                                                =
-- ================================================================================

-- ========================= --
-- <CONFIGURATION DU SCRIPT> --
-- ========================= --

-- Définit le niveau minimum à atteindre avant de quitter Incarnam (Défaut : 12)
MinLevelToLeaveIncarnam = 12

-- Définit si le bot doit obtenir une panoplie de l'aventurier complète avant de quitter Incarnam (Défaut : true)
DropSetRequiredToLeaveIncarnam = true

-- Définit si le bot doit vendre les [Potion de Souvenir] par lot de 100 en hôtel de vente (Défaut : false)
-- /!\ Attention : nécessite des Kamas pour payer les taxes
SellMode = false

-- Définit le prix minimum pour la mise en vente des lots de 100 [Potion de Souvenir] (Défaut : 50000)
MinPrice = 50000

-- Définit si le prix doit être baissé d'un kamas lors de la vente (Défaut : false)
-- Notez qu'en activant ceci, vous mettez en péril la rentabilité de ce script
-- Mais si vous êtes un rat, ce qui n'est pas à exclure vu la mentalité des personnes
-- de SnowBot, alors activez cette option et niquez les prix, allez-y
DropPriceByOneKamas = false

-- Définit si le bot doit actualiser les prix de tout les lots après avoir mis les lots en hôtel de vente (Défaut : false)
-- /!\ Peut demander énormément de Kamas (taxes)
-- /!\ La sécurité "MinPrice" n'est pas prise en compte
-- /!\ Activez à vos risques et périls (un petit malin peut mettre un lot à 2kamas et votre bot les actualisera tous à 1kamas)
UpdateLots = false

-- Définit le nombre minimal de monstres à affronter (Défaut : 1)
MIN_MONSTERS = 1

-- Définit le nombre maximal de monstres à affronter (Défaut : 4)
MAX_MONSTERS = 4

-- Définit si le bot doit ouvrir les sacs de récolte (Défaut : false)
-- Note : Le bot ne recevra pas de sacs si il n'est pas abonné
OPEN_BAGS = true

-- ========================== --
-- </CONFIGURATION DU SCRIPT> --
-- ========================== --

-- =========== --
-- <VARIABLES> --
-- =========== --
-- Ne pas modifier pour le bon fonctionnement du script

ZoneIncarnam = 0
ChapeauAventurier = false
AmuletteAventurier = false
CapeAventurier = false
AnneauAventurier = false
CeintureAventurier = false
BottesAventurier = false
NeedToCraft = false
NeedToReturnBank = false
NeedToSell = false
NbOrties = 0
NbSauges = 0
CraftQuantity = 0

-- ============ --
-- </VARIABLES> --
-- ============ --

-- ========= --
-- <STARTUP> --
-- ========= --

global:printMessage("Bonjour " .. character:name() .. " !")
global:printMessage("Script réalisé par Ta mere.")
global:printSuccess("Partagé gratuitement sur le Forum de Snowbot -> https://forum.snowbot.eu/")

-- ========== --
-- </STARTUP> --
-- ========== --


dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Bank\\FarmerBotBankManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\PathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\GatherPathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\CraftPathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Craft\\CraftManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Models\\Path.lua")

local BotBank = false
local Server = character:server()

local FarmerBotBankManager = FarmerBotBankManager:new(BotBank, Server)
local PathManager = PathManager:new()
local GatherPathManager = GatherPathManager:new()
local CraftManager = CraftManager:new()
local CraftPathManager = CraftPathManager:new()

local BankMapId = 192415750  -- Astrub
local BankOutdoorMapId = 191104002
BotBanque = true

function move()

	-- Récupérer la date et l'heure actuelles
    local date_actuelle = os.date("*t")
    local timestamp_actuel = os.time(date_actuelle)
    global:printMessage("la sécurité ANTI DECO MAJ est activé")

    -- Définition des zones de drop de la panoplie et des conditions
    if character:lifePointsP() <= 80 then
        global:printMessage("Le personnage à ".. character:lifePointsP() .." % de points de vie")
        global:printMessage("On att 1 minute que le bot se régen")
        global:delay(60000)
    end

    if (map:currentArea() == "Incarnam") then
        PathManager:IncarnamToAstrub()
    end

    if (map:currentArea() == "Astrub") then
        if (map:currentMapId() == 192416776 or map:currentMapId() == 191106048) then
            return {
                {map = "192416776", path = "bottom"}, -- Map portail Astrub intérieur
                {map = "191106048", path = "left"}, -- Map portail Astrub extérieur
            }
        end

        if (NeedToCraft) then
            CraftPathManager:AtelierAlchiFromBankAstrub()
        end

        if (NeedToReturnBank) then
            CraftPathManager:BankAstrubFromAtelierAlchi()
        end

        if (NeedToSell) then
            return {
                {map = "191104002", path = "bottom"}, -- Map extérieure de la banque d'Astrub
                {map = "191104004", custom = ProcessSell}, -- Map HDV ressouces Astrub
            }
        end

        if (map:currentMapId() == 191104002 and not NeedToCraft and not NeedToReturnBank) then
            return {
                {map = "191104002", path = "right"},
            }
        end

        -- Définition du chemin à suivre en fonction du niveau du métier Alchimiste
        if (job:level(26) < 20) then
            GATHER = {254, 255, 1, 8, 28, 29, 30, 31, 32, 33, 34, 35, 39, 42, 43, 44, 45, 46, 47, 61, 66, 67, 68, 74, 76, 77, 78, 79, 80, 81, 98, 99, 101, 108,109, 110, 111, 112}
            return GatherPathManager:GatherOrtieAstrub()
        elseif (job:level(26) >= 20) then
            GATHER = {254, 255, 1, 8, 28, 29, 30, 31, 32, 33, 34, 35, 39, 42, 43, 44, 45, 46, 47, 61, 66, 67, 68, 74, 76, 77, 78, 79, 80, 81, 98, 99, 101, 108,109, 110, 111, 112}
            return GatherPathManager:GatherOrtieAndSaugeAstrub()
        end
    end
end

function bank()
    if (NeedToCraft) then
        return {
            {map = "191104002", path = "top"}, -- Map extérieure de la banque d'Astrub
            {map = "4,-19", path = "top"},
            {map = "4,-20", path = "top"},
            {map = "4,-21", path = "left"},
            {map = "188744705", door = "412"}, -- Map extérieure Atelier Alchimiste Astrub
            {map = "192937988", custom = ProcessCraft}, -- Map intérieur Atelier Alchimiste Astrub
        }
    end

    if (NeedToReturnBank) then
        return {
            {map = "188744705", path = "right"}, -- Map extérieure Atelier Alchimiste Astrub
            {map = "4,-21", path = "bottom"},
            {map = "4,-20", path = "bottom"},
            {map = "4,-19", path = "bottom"},
            {map = "191104002", custom = ProcessBank}, -- Map extérieure de la banque d'Astrub
        }
    end

    if (NeedToSell) then
        return {
            {map = "191104002", path = "bottom"}, -- Map extérieure de la banque d'Astrub
            {map = "191104004", custom = ProcessSell}, -- Map HDV ressouces Astrub
        }
    end

    if(map:currentMapId() == BankMapId) then
        ProcessBank()
        global:printMessage("[Bank] Je vais sortir de la banque")
        return PathManager:SortirBanqueAstrub()
    elseif(map:currentMapId() == BankOutdoorMapId) then
            global:printMessage("[Bank] Je vais rentrer dans la banque")
            return PathManager:EntrerBanqueAstrub()
    end

    return PathManager:BankAstrubFromAstrub()
end

function ProcessBank()
    -- implementer notre logique
    FarmerBotBankManager:ToNPCBank()
    global:delay(2457)

    if (NeedToReturnBank) then
        NeedToReturnBank = false

        if (SellMode) then
            global:printSuccess("[Info] Le mode vente est activé, je vérifies combien de lots je peux vendre !")
            local nombreLotsPotions = math.floor(exchange:storageItemQuantity(7652) / 100)
            global:printSuccess("[Info] Je peux vendre " .. nombreLotsPotions .. " lots de [Potion de Souvenir] !")
            exchange:getItem(7652, nombreLotsPotions * 100)
            NeedToSell = true
            global:delay(2146)
        end

    else
        NbOrties = exchange:storageItemQuantity(421)
        NbSauges = exchange:storageItemQuantity(428)

        global:printSuccess("[Banque] : " .. NbOrties .. " [Ortie].")
        global:printSuccess("[Banque] : " .. NbSauges .. " [Sauge].")

        if (job:level(26) >= 30) then
            global:printSuccess("[Info] Le niveau de votre métier Alchimiste vous permet de fabriquer des [Potion de Souvenir] !")
            local nbLotsOrties = math.floor(NbOrties / 20)
            local nbLotsSauges = math.floor(NbSauges / 10)


            if (nbLotsOrties < 1) then
                global:printError("[Info] Pas assez d'[Ortie] disponibles en banque pour fabriquer des [Potion de Souvenir]")
            elseif (nbLotsSauges < 1) then
                global:printError("[Info] Pas assez de [Sauge] disponibles en banque pour fabriquer des [Potion de Souvenir]")
            else

                local podsAvailable = inventory:podsMax() - inventory:pods()

                local quantiteMaxOrtiesAPrendre = math.floor((podsAvailable / 3) * 2)
                local quantiteMaxSaugesAPrendre = podsAvailable - quantiteMaxOrtiesAPrendre

                if (nbLotsOrties > nbLotsSauges) then
                    CraftQuantity = nbLotsSauges
                elseif (nbLotsOrties < nbLotsSauges) then
                    CraftQuantity = nbLotsOrties
                end

                if (nbLotsOrties * 20 > quantiteMaxOrtiesAPrendre) then
                    CraftQuantity = math.floor(quantiteMaxOrtiesAPrendre / 20)
                elseif (nbLotsSauges * 10 > quantiteMaxSaugesAPrendre) then
                    CraftQuantity = math.floor(quantiteMaxSaugesAPrendre / 10)
                end

                global:printSuccess("[Info] Possibilité de création de " .. CraftQuantity .. "x [Potion de Souvenir]")
                global:printSuccess("[Info] Quantités à retirer de [Ortie] : " .. CraftQuantity * 20 .. "")
                global:printSuccess("[Info] Quantités à retirer de [Sauge] : " .. CraftQuantity * 10 .. "")

                exchange:getItem(421, CraftQuantity * 20)
                global:delay(2647)
                exchange:getItem(428, CraftQuantity * 10)
                NeedToCraft = true
            end
        else
            global:printSuccess("[Info] Vous n'avez pas encore atteint le niveau d'Alchimiste nécessaire à la fabrication de [Potion de Souvenir] !")
        end
    end

    global:leaveDialog()
    global:delay(1547)
    map:moveToCell(409)
    global:delay(1394)
end

function ProcessCraft()
    CraftManager:CraftPotionSouvenirAstrub(CraftQuantity)
    NeedToCraft = false
    NeedToReturnBank = true
end

function ProcessSell()
    global:delay(1358)
    npc:npc(515220, 5)

    nbPot = inventory:itemCount(7652)

    if (DropPriceByOneKamas) then
        priceToSell = sale:getPriceItem(7652, 3) - 1
    else
        priceToSell = sale:getPriceItem(7652, 3)
    end

    if (priceToSell < MinPrice) then
        priceToSell = MinPrice
    end

    if (nbPot >= 100) then
        nbIterations = math.floor(nbPot / 100);
        for i = 1, nbIterations do
            if (sale:availableSpace() > 0) then
                sale:sellItem(7652, 100, priceToSell)
            end
        end
    end

    if (UpdateLots) then
        sale:updateAllItems()
    end

    NeedToSell = false
    global:delay(1736)
    global:leaveDialog()
    global:delay(1842)
    map:changeMap("right")
    global:delay(1778)
end