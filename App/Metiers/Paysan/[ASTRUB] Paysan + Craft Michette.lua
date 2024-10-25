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

-- Définit si le bot doit vendre les [Michette] par lot de 100 en hôtel de vente (Défaut : false)
-- /!\ Attention : nécessite des Kamas pour payer les taxes
SellMode = false

-- Définit le prix minimum pour la mise en vente des lots de 100 [Michette] (Défaut : 50000)
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
NbBle = 0
CraftQuantity = 0

-- ============ --
-- </VARIABLES> --
-- ============ --

-- ========= --
-- <STARTUP> --
-- ========= --

global:printMessage("Bonjour " .. character:name() .. " !")
global:printMessage("Script réalisé par nous.")
global:printSuccess("Partagé gratuitement sur le Forum de ta mere")

-- ========== --
-- </STARTUP> --
-- ========== --


function move()

	-- Récupérer la date et l'heure actuelles
    local date_actuelle = os.date("*t")
    local timestamp_actuel = os.time(date_actuelle)
    
    -- Vérifier si l'heure actuelle est 7h00 et qu'il est un mardi
    if date_actuelle.wday == 3 and date_actuelle.hour == 7 then
    global:printMessage("Il est 7h00 du matin et nous sommes un mardi !")
    global:disconnect()
    end

    -- Définition des zones de drop de la panoplie et des conditions
    if character:lifePointsP() <= 80 then
        global:printMessage("Le personnage à ".. character:lifePointsP() .." % de points de vie")
        global:printMessage("On att 1 minute que le bot se régénaire")
        global:delay(60000)
    end

    if (map:currentArea() == "Incarnam") then
        if character:level() >= 3 then
            if (inventory:itemCount(2473) >= 1) or (DropSetRequiredToLeaveIncarnam == false) then
                ZoneIncarnam = 1
                if (inventory:itemCount(2478) >= 1) or (DropSetRequiredToLeaveIncarnam == false) then
                    ZoneIncarnam = 2
                    if (inventory:itemCount(2477) >= 1) or (DropSetRequiredToLeaveIncarnam == false) then
                        ZoneIncarnam = 3
                        if (inventory:itemCount(2475) >= 1) or (DropSetRequiredToLeaveIncarnam == false) then
                            ZoneIncarnam = 4
                            if (inventory:itemCount(2476) >= 1) or (DropSetRequiredToLeaveIncarnam == false) then
                                ZoneIncarnam = 5
                                if (ChapeauAventurier == true and character:level() >= MinLevelToLeaveIncarnam) or (DropSetRequiredToLeaveIncarnam == false and character:level() >= MinLevelToLeaveIncarnam) then
                                    ZoneIncarnam = 6
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Gestion de l'équipement en fonction du niveau du personnage
        if character:level() >= 7 and AmuletteAventurier == false then
            if inventory:equipItem(2478, 0) == true then
                global:printMessage("Je m'équipe de l'Amulette de l'Aventurier !")
                AmuletteAventurier = true
            end
        end

        if character:level() >= 8 and AnneauAventurier == false then
            if inventory:equipItem(2475, 2) == true then
                global:printMessage("Je m'équipe de l'Anneau de l'Aventurier !")
                AnneauAventurier = true
            end
        end

        if character:level() >= 9 and CapeAventurier == false then
            if inventory:equipItem(2473, 7) == true then
                global:printMessage("Je m'équipe de la Cape de l'Aventurier !")
                CapeAventurier = true
            end
        end

        if character:level() >= 10 and CeintureAventurier == false then
            if inventory:equipItem(2477, 3) == true then
                global:printMessage("Je m'équipe de la Ceinture de l'Aventurier !")
                CeintureAventurier = true
            end
        end

        if character:level() >= 11 and BottesAventurier == false then
            if inventory:equipItem(2476, 5) == true then
                global:printMessage("Je m'équipe des Bottes de l'Aventurier !")
                BottesAventurier = true
            end
        end

        if character:level() >= 12 and ChapeauAventurier == false then
            if inventory:equipItem(2474, 6) == true then
                global:printMessage("Je m'équipe du Chapeau de l'Aventurier !")
                ChapeauAventurier = true
            end
        end

        -- On définit le chemin que le personnage doit emprunter
        if ZoneIncarnam == 0 then
            return RouteDesAmes()
        elseif ZoneIncarnam == 1 then
            return ChampsIncarnam()
        elseif ZoneIncarnam == 2 then
            return LacIncarnam()
        elseif ZoneIncarnam == 3 then
            return ForetIncarnam()
        elseif ZoneIncarnam == 4 then
            return PaturageIncarnam()
        elseif ZoneIncarnam == 5 then
            return CimetiereIncarnam()
        elseif ZoneIncarnam == 6 then
            return GoToAstrub()
        end
    end

    if (map:currentArea() == "Astrub") then
        if (map:currentMapId() == 192416776 or map:currentMapId() == 191106048) then
            return {
                {map = "192416776", path = "bottom"}, -- Map portail Astrub intérieur
                {map = "191106048", path = "left"}, -- Map portail Astrub extérieur
            }
        end

        if (NeedToCraft) then
            map:moveToward(192937992) -- mapid atelier paysan
            return {
                {map = "192937992", custom = ProcessCraft}, -- mapid interieur atelier paysan
            }
        end

        if (NeedToReturnBank) then -- modif par bryan pour le retour en banque
            map:moveToward(192415750)
            return {
                {map = "192415750", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
            }
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

            GATHER = {38, 39, 42, 43, 44, 45, 46, 47, 82, 84} -- ressources à récolter
            return DeplacementsCereale() -- déplacement pour récolter les céréales
    end
end

function bank()
    if (NeedToCraft) then
        map:moveToward(192937992) -- mapid atelier paysan
        return {
            {map = "192937992", custom = ProcessCraft}, -- mapid interieur atelier paysan
        }
    end


    if (NeedToReturnBank) then -- modif par bryan pour le retour en banque
        map:moveToward(192415750) -- mapid banque astrub
        return {
            {map = "192415750", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
        }
    end

    if (NeedToSell) then
        return {
            {map = "191104002", path = "bottom"}, -- Map extérieure de la banque d'Astrub
            {map = "191104004", custom = ProcessSell}, -- Map HDV ressouces Astrub
        }
    end

    return {
        { map = "5,-29", path = "bottom" }, 
        { map = "3,-18", path = "right" },  
        { map = "2,-18", path = "right" },  
        { map = "1,-18", path = "right" },  
        { map = "0,-18", path = "right" },  
        { map = "-1,-18", path = "right" },  
        { map = "-2,-18", path = "right" },  
        { map = "-3,-18", path = "right" },  
        { map = "5,-18", path = "left" },  
        { map = "6,-18", path = "left" },  
        { map = "7,-18", path = "left" },  
        { map = "8,-18", path = "left" },  
        { map = "9,-18", path = "left" },  
        { map = "10,-18", path = "left" },  
        { map = "11,-18", path = "left" },  
        { map = "12,-18", path = "left" },  
        { map = "4,-19", path = "bottom" },  
        { map = "4,-20", path = "bottom" },  
        { map = "4,-21", path = "bottom" },  
        { map = "4,-23", path = "bottom" },  
        { map = "4,-22", path = "bottom" },  
        { map = "4,-24", path = "bottom" },  
        { map = "4,-25", path = "bottom" },  
        { map = "4,-26", path = "bottom" },  
        { map = "4,-27", path = "bottom" },  
        { map = "4,-28", path = "bottom" },  
        { map = "4,-29", path = "bottom" },  
        { map = "4,-30", path = "bottom" },  
        { map = "4,-31", path = "bottom" },  
        { map = "4,-32", path = "bottom" },  
        { map = "4,-33", path = "bottom" },  
        { map = "5,-33", path = "bottom" },  
        { map = "5,-32", path = "bottom" },  
        { map = "5,-31", path = "bottom" },  
        { map = "5,-30", path = "bottom" },  
        { map = "6,-30", path = "bottom" },  
        { map = "6,-29", path = "bottom" },  
        { map = "7,-28", path = "bottom" },  
        { map = "6,-28", path = "bottom" },  
        { map = "5,-28", path = "bottom" },  
        { map = "5,-27", path = "bottom" },  
        { map = "6,-27", path = "bottom" },  
        { map = "7,-27", path = "bottom" },  
        { map = "7,-26", path = "bottom" },  
        { map = "6,-26", path = "bottom" },  
        { map = "5,-25", path = "bottom" },  
        { map = "5,-26", path = "bottom" },  
        { map = "6,-25", path = "bottom" },  
        { map = "7,-25", path = "bottom" },  
        { map = "189794311", path = "bottom" },  -- map exterieur atelier paysan
        { map = "192937992", path = "424" },  -- map interieur atelier paysan
        { map = "6,-24", path = "bottom" },  
        { map = "5,-24", path = "bottom" },  
        { map = "3,-24", path = "bottom" },  
        { map = "3,-25", path = "bottom" },  
        { map = "3,-26", path = "bottom" },  
        { map = "3,-27", path = "bottom" },  
        { map = "3,-28", path = "bottom" },  
        { map = "3,-29", path = "bottom" },  
        { map = "3,-30", path = "bottom" },  
        { map = "3,-31", path = "bottom" },  
        { map = "3,-32", path = "bottom" },  
        { map = "3,-33", path = "bottom" },  
        { map = "2,-30", path = "bottom" },  
        { map = "2,-29", path = "bottom" },  
        { map = "2,-28", path = "bottom" },  
        { map = "2,-27", path = "bottom" },  
        { map = "2,-26", path = "bottom" },  
        { map = "2,-25", path = "bottom" },  
        { map = "2,-24", path = "bottom" },  
        { map = "2,-23", path = "bottom" },  
        { map = "3,-23", path = "bottom" },  
        { map = "5,-23", path = "bottom" },  
        { map = "6,-23", path = "bottom" },  
        { map = "7,-23", path = "bottom" },  
        { map = "8,-23", path = "bottom" },  
        { map = "8,-24", path = "bottom" },  
        { map = "9,-24", path = "bottom" },  
        { map = "9,-23", path = "bottom" },  
        { map = "9,-25", path = "bottom" },  
        { map = "9,-26", path = "bottom" },  
        { map = "9,-28", path = "bottom" },  
        { map = "9,-29", path = "bottom" },  
        { map = "11,-21", path = "bottom" },  
        { map = "11,-22", path = "bottom" },  
        { map = "11,-23", path = "bottom" },  
        { map = "11,-25", path = "bottom" },  
        { map = "11,-24", path = "bottom" },  
        { map = "11,-27", path = "bottom" },  
        { map = "11,-28", path = "bottom" },  
        { map = "11,-26", path = "bottom" },  
        { map = "11,-20", path = "bottom" },  
        { map = "11,-19", path = "bottom" },  
        { map = "4,-17", path = "top" },  
        { map = "5,-17", path = "left" },  
        { map = "5,-16", path = "top" },  
        { map = "5,-15", path = "top" },  
        { map = "5,-14", path = "top" },  
        { map = "5,-13", path = "top" },  
        { map = "4,-13", path = "top" },  
        { map = "4,-14", path = "top" },  
        { map = "3,-14", path = "top" },  
        { map = "3,-13", path = "top" },  
        { map = "2,-13", path = "top" },  
        { map = "2,-14", path = "top" },  
        { map = "1,-14", path = "top" },  
        { map = "1,-13", path = "top" },  
        { map = "0,-14", path = "top" },  
        { map = "0,-13", path = "top" },  
        { map = "-1,-14", path = "top" },  
        { map = "-2,-14", path = "top" },  
        { map = "-3,-14", path = "top" },  
        { map = "-3,-13", path = "top" },  
        { map = "-2,-13", path = "top" },  
        { map = "-1,-13", path = "top" },  
        { map = "6,-14", path = "top" },  
        { map = "6,-13", path = "top" },  
        { map = "7,-14", path = "top" },  
        { map = "7,-13", path = "top" },  
        { map = "8,-14", path = "top" },  
        { map = "8,-13", path = "top" },  
        { map = "9,-14", path = "top" },  
        { map = "9,-13", path = "top" },  
        { map = "10,-14", path = "top" },  
        { map = "10,-13", path = "top" },  
        { map = "11,-14", path = "top" },  
        { map = "11,-13", path = "top" },  
        { map = "12,-15", path = "left" },  
        { map = "12,-16", path = "left" },  
        { map = "12,-17", path = "left" },  
        { map = "11,-17", path = "left" },  
        { map = "12,-19", path = "left" },  
        { map = "12,-20", path = "left" },  
        { map = "11,-16", path = "left" },  
        { map = "11,-15", path = "left" },  
        { map = "10,-15", path = "left" },  
        { map = "10,-16", path = "left" },  
        { map = "10,-17", path = "left" },  
        { map = "9,-17", path = "left" },  
        { map = "9,-16", path = "left" },  
        { map = "9,-15", path = "left" },  
        { map = "8,-15", path = "left" },  
        { map = "8,-16", path = "left" },  
        { map = "7,-16", path = "left" },  
        { map = "7,-15", path = "left" },  
        { map = "6,-16", path = "left" },  
        { map = "6,-15", path = "left" },  
        { map = "8,-17", path = "top" },  
        { map = "7,-17", path = "top" },  
        { map = "5,-22", path = "bottom" },  
        { map = "6,-22", path = "bottom" },  
        { map = "7,-22", path = "bottom" },  
        { map = "8,-22", path = "bottom" },  
        { map = "9,-22", path = "bottom" },  
        { map = "10,-21", path = "left" },  
        { map = "9,-21", path = "left" },  
        { map = "8,-21", path = "left" },  
        { map = "7,-21", path = "left" },  
        { map = "6,-21", path = "left" },  
        { map = "5,-21", path = "left" },  
        { map = "5,-20", path = "left" },  
        { map = "6,-20", path = "left" },  
        { map = "7,-20", path = "left" },  
        { map = "8,-20", path = "left" },  
        { map = "8,-19", path = "left" },  
        { map = "5,-19", path = "left" },  
        { map = "6,-19", path = "left" },  
        { map = "9,-19", path = "left" },  
        { map = "9,-20", path = "left" },  
        { map = "10,-20", path = "left" },  
        { map = "10,-19", path = "left" },  
        { map = "7,-19", path = "top" },  
        { map = "10,-22", path = "top" },  
        { map = "12,-22", path = "top" },  
        { map = "12,-23", path = "left" },  
        { map = "12,-24", path = "left" },  
        { map = "12,-25", path = "left" },  
        { map = "12,-26", path = "left" },  
        { map = "13,-26", path = "left" },  
        { map = "13,-27", path = "left" },  
        { map = "12,-27", path = "left" },  
        { map = "12,-28", path = "left" },  
        { map = "13,-28", path = "left" },  
        { map = "8,-29", path = "right" },  
        { map = "8,-28", path = "right" },  
        { map = "8,-27", path = "right" },  
        { map = "8,-26", path = "right" },  
        { map = "8,-25", path = "right" },  
        { map = "9,-27", path = "bottom" },  
        { map = "10,-28", path = "left" },  
        { map = "10,-29", path = "left" },  
        { map = "10,-27", path = "left" },  
        { map = "10,-26", path = "left" },  
        { map = "10,-25", path = "left" },  
        { map = "10,-24", path = "bottom" },  
        { map = "2,-32", path = "right" },  
        { map = "1,-32", path = "right" },  
        { map = "0,-32", path = "right" },  
        { map = "-1,-32", path = "right" },  
        { map = "-2,-32", path = "right" },  
        { map = "-2,-29", path = "bottom" },  
        { map = "-2,-30", path = "bottom" },  
        { map = "-2,-31", path = "bottom" },  
        { map = "-2,-28", path = "bottom" },  
        { map = "-1,-28", path = "bottom" },  
        { map = "0,-28", path = "bottom" },  
        { map = "1,-28", path = "bottom" },  
        { map = "1,-29", path = "top" },  
        { map = "0,-29", path = "top" },  
        { map = "-1,-29", path = "top" },  
        { map = "1,-30", path = "left" },  
        { map = "0,-30", path = "left" },  
        { map = "-1,-30", path = "left" },  
        { map = "2,-31", path = "left" },  
        { map = "1,-31", path = "left" },  
        { map = "0,-31", path = "left" },  
        { map = "-1,-31", path = "left" },  
        { map = "-1,-33", path = "bottom" },  
        { map = "0,-33", path = "bottom" },  
        { map = "0,-34", path = "bottom" },  
        { map = "1,-34", path = "bottom" },  
        { map = "1,-33", path = "bottom" },  
        { map = "2,-34", path = "bottom" },  
        { map = "2,-33", path = "bottom" },  
        { map = "-3,-32", path = "bottom" },  
        { map = "-4,-32", path = "bottom" },  
        { map = "-4,-31", path = "bottom" },  
        { map = "-3,-31", path = "bottom" },  
        { map = "-3,-30", path = "bottom" },  
        { map = "-4,-30", path = "bottom" },  
        { map = "-4,-29", path = "bottom" },  
        { map = "-3,-29", path = "bottom" },  
        { map = "-3,-28", path = "bottom" },  
        { map = "-4,-28", path = "bottom" },  
        { map = "-4,-27", path = "bottom" },  
        { map = "-3,-27", path = "bottom" },  
        { map = "-2,-27", path = "bottom" },  
        { map = "-1,-27", path = "bottom" },  
        { map = "0,-27", path = "bottom" },  
        { map = "1,-27", path = "bottom" },  
        { map = "1,-26", path = "bottom" },  
        { map = "1,-25", path = "bottom" },  
        { map = "0,-25", path = "bottom" },  
        { map = "0,-26", path = "bottom" },  
        { map = "-1,-26", path = "bottom" },  
        { map = "-1,-25", path = "bottom" },  
        { map = "-2,-25", path = "bottom" },  
        { map = "-2,-26", path = "bottom" },  
        { map = "-3,-26", path = "bottom" },  
        { map = "-4,-26", path = "bottom" },  
        { map = "-4,-25", path = "right" },  
        { map = "-3,-25", path = "right" },  
        { map = "-4,-24", path = "bottom" },  
        { map = "-3,-24", path = "bottom" },  
        { map = "-2,-24", path = "bottom" },  
        { map = "-1,-24", path = "bottom" },  
        { map = "0,-24", path = "bottom" },  
        { map = "1,-24", path = "bottom" },  
        { map = "1,-23", path = "bottom" },  
        { map = "0,-23", path = "bottom" },  
        { map = "-1,-23", path = "bottom" },  
        { map = "-2,-23", path = "bottom" },  
        { map = "-3,-23", path = "bottom" },  
        { map = "-4,-23", path = "bottom" },  
        { map = "-4,-22", path = "right" },  
        { map = "-3,-22", path = "right" },  
        { map = "-4,-21", path = "right" },  
        { map = "-3,-21", path = "right" },  
        { map = "-4,-20", path = "right" },  
        { map = "-3,-20", path = "right" },  
        { map = "-4,-19", path = "right" },  
        { map = "-3,-19", path = "right" },  
        { map = "-4,-18", path = "right" },  
        { map = "-4,-16", path = "right" },  
        { map = "-4,-15", path = "right" },  
        { map = "-4,-13", path = "right" },  
        { map = "-4,-14", path = "right" },  
        { map = "-4,-12", path = "right" },  
        { map = "-4,-11", path = "right" },  
        { map = "-4,-10", path = "right" },  
        { map = "-3,-10", path = "right" },  
        { map = "-3,-11", path = "right" },  
        { map = "-3,-12", path = "right" },  
        { map = "-2,-12", path = "right" },  
        { map = "-2,-11", path = "right" },  
        { map = "-2,-10", path = "right" },  
        { map = "-1,-10", path = "right" },  
        { map = "-1,-11", path = "right" },  
        { map = "-1,-12", path = "right" },  
        { map = "0,-12", path = "right" },  
        { map = "0,-11", path = "right" },  
        { map = "0,-10", path = "right" },  
        { map = "0,-9", path = "right" },  
        { map = "1,-9", path = "right" },  
        { map = "1,-10", path = "right" },  
        { map = "1,-11", path = "right" },  
        { map = "1,-12", path = "right" },  
        { map = "-4,-17", path = "right" },  
        { map = "-2,-19", path = "right" },  
        { map = "-2,-20", path = "right" },  
        { map = "-2,-22", path = "right" },  
        { map = "-2,-21", path = "right" },  
        { map = "-1,-22", path = "right" },  
        { map = "0,-22", path = "right" },  
        { map = "1,-22", path = "right" },  
        { map = "2,-22", path = "right" },  
        { map = "3,-22", path = "right" },  
        { map = "3,-21", path = "right" },  
        { map = "3,-20", path = "right" },  
        { map = "2,-20", path = "right" },  
        { map = "2,-21", path = "right" },  
        { map = "1,-21", path = "right" },  
        { map = "1,-20", path = "right" },  
        { map = "0,-20", path = "right" },  
        { map = "0,-21", path = "right" },  
        { map = "-1,-21", path = "right" },  
        { map = "-1,-20", path = "right" },  
        { map = "-1,-19", path = "right" },  
        { map = "0,-19", path = "right" },  
        { map = "1,-19", path = "right" },  
        { map = "2,-19", path = "bottom" },  
        { map = "-3,-17", path = "top" },  
        { map = "-3,-16", path = "top" },  
        { map = "-3,-15", path = "top" },  
        { map = "-2,-17", path = "top" },  
        { map = "-2,-16", path = "top" },  
        { map = "-2,-15", path = "top" },  
        { map = "-1,-17", path = "top" },  
        { map = "-1,-16", path = "top" },  
        { map = "-1,-15", path = "top" },  
        { map = "0,-17", path = "top" },  
        { map = "0,-16", path = "top" },  
        { map = "0,-15", path = "top" },  
        { map = "1,-17", path = "top" },  
        { map = "1,-16", path = "top" },  
        { map = "1,-15", path = "top" },  
        { map = "2,-17", path = "top" },  
        { map = "2,-16", path = "top" },  
        { map = "2,-15", path = "top" },  
        { map = "3,-17", path = "right" },  
        { map = "3,-16", path = "right" },  
        { map = "4,-16", path = "right" },  
        { map = "4,-15", path = "right" },  
        { map = "3,-15", path = "right" },  
        { map = "6,-17", path = "left" },  
        { map = "3,-19", path = "bottom" },  
        { map = "3,-8", path = "top" },  
        { map = "2,-8", path = "top" },  
        { map = "1,-8", path = "top" },  
        { map = "2,-9", path = "top" },  
        { map = "3,-9", path = "top" },  
        { map = "4,-9", path = "top" },  
        { map = "5,-9", path = "top" },  
        { map = "6,-9", path = "top" },  
        { map = "7,-9", path = "top" },  
        { map = "8,-9", path = "top" },  
        { map = "8,-8", path = "top" },  
        { map = "7,-8", path = "top" },  
        { map = "9,-9", path = "top" },  
        { map = "9,-8", path = "top" },  
        { map = "9,-10", path = "top" },  
        { map = "10,-10", path = "top" },  
        { map = "10,-11", path = "top" },  
        { map = "10,-12", path = "top" },  
        { map = "9,-12", path = "top" },  
        { map = "9,-11", path = "top" },  
        { map = "8,-12", path = "top" },  
        { map = "8,-11", path = "top" },  
        { map = "7,-10", path = "top" },  
        { map = "8,-10", path = "top" },  
        { map = "7,-12", path = "top" },  
        { map = "7,-11", path = "top" },  
        { map = "6,-12", path = "top" },  
        { map = "6,-11", path = "top" },  
        { map = "6,-10", path = "top" },  
        { map = "5,-10", path = "top" },  
        { map = "5,-11", path = "top" },  
        { map = "5,-12", path = "top" },  
        { map = "4,-12", path = "top" },  
        { map = "4,-11", path = "top" },  
        { map = "4,-10", path = "top" },  
        { map = "3,-10", path = "top" },  
        { map = "3,-11", path = "top" },  
        { map = "3,-12", path = "top" },  
        { map = "2,-12", path = "top" },  
        { map = "2,-11", path = "top" },  
        { map = "2,-10", path = "top" },  
        { map = "11,-11", path = "left" },  
        { map = "11,-12", path = "left" },  
        { map = "12,-21", path = "left" },  
        { map = "10,-23", path = "right" },  
        { map = "191104002", door = "288"}, -- Map extérieure de la banque d'Astrub
        { map = "192415750", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
    }
end

function phenix()
    return {
        { map = "-3,-13", path = "top" },
        { map = "-2,-14", path = "right" },
        { map = "-3,-14", path = "right" },
        { map = "-1,-14", path = "right" },
        { map = "0,-14", path = "right" },
        { map = "1,-14", path = "right" },
        { map = "2,-14", custom = function() map:door(313) map:changeMap("top") end, done = false },
    }
end

function RouteDesAmes()
    return {
        {map = "4,-1", path = "bottom"},
        {map = "5,-1", path = "left"},
        {map = "4,0", path = "left"},
        {map = "5,0", path = "left"},
        {map = "4,1", path = "top"},
        {map = "3,1", path = "top"},
        {map = "3,0", path = "top"},
        {map = "3,-2", path = "top"},
        {map = "3,-1", path = "top"},
        {map = "2,0", path = "top"},
        {map = "2,-1", path = "top"},
        {map = "2,-2", path = "top"},
        {map = "1,-2", path = "top"},
        {map = "0,-2", path = "top"},
        {map = "0,-1", path = "top"},
        {map = "1,-1", path = "top"},
        {map = "1,0", path = "top"},
        {map = "0,1", path = "top"},
        {map = "-1,1", path = "top"},
        {map = "-1,0", path = "left"},
        {map = "-2,0", path = "top"},
        {map = "-1,-2", path = "top"},
        {map = "-1,-1", path = "top"},
        {map = "-2,-1", path = "top"},
        {map = "-2,-2", path = "top"},
        {map = "-3,-5", path = "right"},
        {map = "-3,-6", path = "right"},
        {map = "-2,-6", path = "bottom"},
        {map = "-2,-5", path = "bottom"},
        {map = "-1,-6", path = "bottom"},
        {map = "-1,-5", path = "bottom"},
        {map = "0,-5", path = "bottom"},
        {map = "1,-5", path = "bottom"},
        {map = "2,-5", path = "bottom"},
        {map = "3,-5", path = "bottom"},
        {map = "4,-4", path = "bottom"},
        {map = "3,-4", path = "bottom"},
        {map = "2,-4", path = "bottom"},
        {map = "-2,-4", path = "bottom"},
        {map = "-1,-4", path = "bottom"},
        {map = "0,-4", path = "bottom"},
        {map = "1,-4", path = "bottom"},
        {map = "152044547", path = "right"},
        {map = "152043521", path = "right"},
        {map = "152045573", path = "right"},
        {map = "152046593", path = "right"},
        {map = "152043523", path = "right"},
        {map = "152046599", path = "right"},
        {map = "152044553", path = "right"},
        {map = "152046595", path = "right"},
        {map = "152044545", path = "right"},
        {map = "152045575", path = "right"},
        {map = "152045571", path = "right"},
        {map = "152043529", path = "right"},
        {map = "152043527", path = "right"},
        {map = "152043525", path = "right"},
        {map = "152045569", path = "right"},
        {map = "152046597", path = "right"},
        {map = "152044549", path = "right"},
        {map = "153092354", door = "409"},
        -- Cartes de combats
        {map = "-1,-3", path = "left|right", fight = true},
        {map = "-2,-3", path = "right", fight = true},
        {map = "3,-3", path = "left", fight = true},
        {map = "0,-3", path = "left|right", fight = true},
        {map = "1,-3", path = "left|right", fight = true},
        {map = "2,-3", path = "left|right", fight = true},
    }
end

function ChampsIncarnam()
    return {
        {map = "-1,-2", path = "top"},
        {map = "-2,-2", path = "top"},
        {map = "-2,-3", path = "top"},
        {map = "3,-3", path = "left"},
        {map = "5,-1", path = "bottom"},
        {map = "4,-1", path = "bottom"},
        {map = "3,1", path = "top"},
        {map = "3,0", path = "top"},
        {map = "2,0", path = "top"},
        {map = "1,0", path = "top"},
        {map = "0,-1", path = "right"},
        {map = "0,1", path = "top"},
        {map = "-1,1", path = "top"},
        {map = "-1,0", path = "top"},
        {map = "-2,0", path = "top"},
        {map = "-2,-1", path = "top"},
        {map = "-1,-1", path = "top"},
        {map = "4,-3", path = "left"},
        {map = "4,-4", path = "left"},
        {map = "2,-4", path = "bottom"},
        {map = "3,-4", path = "bottom"},
        {map = "5,0", path = "left"},
        {map = "4,0", path = "left"},
        {map = "4,1", path = "top"},
        {map = "1,-1", path = "top"},
        {map = "2,-1", path = "top"},
        {map = "3,-5", path = "bottom"},
        {map = "2,-5", path = "bottom"},
        {map = "1,-5", path = "bottom"},
        {map = "1,-4", path = "bottom"},
        {map = "3,-1", path = "top"},
        {map = "3,-2", path = "top"},
        {map = "2,-2", path = "top"},
        {map = "1,-2", path = "top"},
        {map = "0,-2", path = "top"},
        {map = "2,-3", path = "left"},
        {map = "1,-3", path = "left"},
        {map = "0,-3", path = "left"},
        {map = "-1,-3", path = "top"},
        -- Cartes de combats
        {map = "-3,-6", path = "bottom", fight = true},
        {map = "-1,-6", path = "left", fight = true},
        {map = "-1,-5", path = "top|left", fight = true},
        {map = "0,-5", path = "left", fight = true},
        {map = "-2,-6", path = "left|bottom", fight = true},
        {map = "-2,-5", path = "bottom", fight = true},
        {map = "-2,-4", path = "right", fight = true},
        {map = "-3,-5", path = "right", fight = true},
        {map = "0,-4", path = "top", fight = true},
        {map = "-1,-4", path = "top|right", fight = true}
    }
end

function LacIncarnam()
    return {
        {map = "-1,-4", path = "bottom"},
        {map = "-1,-3", path = "bottom"},
        {map = "0,0", path = "right"},
        {map = "1,-4", path = "bottom"},
        {map = "1,-5", path = "bottom"},
        {map = "0,-3", path = "left"},
        {map = "1,-3", path = "left"},
        {map = "2,-3", path = "left"},
        {map = "3,-3", path = "left"},
        {map = "-2,-3", path = "bottom"},
        {map = "1,-2", path = "left"},
        {map = "1,-1", path = "top"},
        {map = "-3,-6", path = "right"},
        {map = "-2,-6", path = "right"},
        {map = "-3,-5", path = "right"},
        {map = "4,-1", path = "bottom"},
        {map = "5,0", path = "left"},
        {map = "5,-1", path = "left"},
        {map = "4,1", path = "left"},
        {map = "4,0", path = "left"},
        {map = "3,1", path = "top"},
        {map = "3,0", path = "top"},
        {map = "3,-2", path = "top"},
        {map = "3,-1", path = "top"},
        {map = "1,0", path = "top"},
        {map = "2,0", path = "top"},
        {map = "2,-2", path = "top"},
        {map = "2,-1", path = "top"},
        {map = "4,-3", path = "left"},
        {map = "4,-4", path = "bottom"},
        {map = "3,-4", path = "bottom"},
        {map = "3,-5", path = "bottom"},
        {map = "2,-5", path = "bottom"},
        {map = "2,-4", path = "bottom"},
        {map = "-2,-5", path = "right"},
        {map = "-2,-4", path = "right"},
        {map = "0,-4", path = "left"},
        {map = "0,-5", path = "left"},
        {map = "-1,-6", path = "bottom"},
        {map = "-1,-5", path = "bottom"},
        -- Cartes de combats
        {map = "-2,0", path = "right", fight = true},
        {map = "-2,-1", path = "right|bottom", fight = true},
        {map = "-2,-2", path = "bottom", fight = true},
        {map = "-1,-2", path = "left|right|bottom", fight = true},
        {map = "-1,-1", path = "top|left", fight = true},
        {map = "0,-1", path = "right", fight = true},
        {map = "0,1", path = "top", fight = true},
        {map = "-1,1", path = "right", fight = true},
        {map = "-1,0", path = "top|right|bottom", fight = true},
        {map = "0,-2", path = "left", fight = true},
    }
end

function ForetIncarnam()
    return {
        {map = "5,0", path = "left"},
        {map = "4,0", path = "left"},
        {map = "4,1", path = "left"},
        {map = "3,0", path = "top"},
        {map = "3,1", path = "top"},
        {map = "-1,-6", path = "bottom"},
        {map = "-2,-6", path = "right"},
        {map = "-2,-5", path = "right"},
        {map = "-2,-4", path = "right"},
        {map = "-3,-6", path = "right"},
        {map = "-3,-5", path = "right"},
        {map = "0,1", path = "top"},
        {map = "3,-3", path = "left"},
        {map = "3,-4", path = "bottom"},
        {map = "3,-5", path = "bottom"},
        {map = "2,-5", path = "bottom"},
        {map = "2,-3", path = "bottom"},
        {map = "2,-4", path = "bottom"},
        {map = "1,-4", path = "bottom"},
        {map = "1,-5", path = "bottom"},
        {map = "0,-4", path = "bottom"},
        {map = "0,-5", path = "bottom"},
        {map = "-1,-4", path = "bottom"},
        {map = "-1,-5", path = "bottom"},
        {map = "-1,1", path = "top"},
        {map = "-1,0", path = "right"},
        {map = "-2,0", path = "right"},
        {map = "5,-1", path = "bottom"},
        {map = "4,-1", path = "bottom"},
        {map = "-2,-1", path = "top"},
        {map = "-1,-1", path = "top"},
        {map = "-2,-2", path = "top"},
        {map = "-1,-2", path = "top"},
        {map = "0,-2", path = "right"},
        {map = "-2,-3", path = "right"},
        {map = "-1,-3", path = "right"},
        {map = "0,-3", path = "right"},
        {map = "1,-3", path = "bottom"},
        {map = "0,-1", path = "bottom"},
        {map = "0,0", path = "right"},
        -- Cartes de combats
        {map = "2,0", path = "top", fight = true},
        {map = "1,0", path = "right", fight = true},
        {map = "1,-1", path = "bottom", fight = true},
        {map = "2,-2", path = "right|bottom", fight = true},
        {map = "1,-2", path = "right", fight = true},
        {map = "3,-1", path = "top", fight = true},
        {map = "2,-1", path = "right", fight = true},
        {map = "3,-2", path = "left", fight = true},
    }
end

function PaturageIncarnam()
    return {
        {map = "3,-1", path = "left"},
        {map = "2,-3", path = "top"},
        {map = "0,0", path = "right"},
        {map = "0,-3", path = "right"},
        {map = "-1,-3", path = "right"},
        {map = "-2,-3", path = "right"},
        {map = "1,0", path = "top"},
        {map = "1,-1", path = "top"},
        {map = "2,0", path = "top"},
        {map = "3,-3", path = "top"},
        {map = "4,1", path = "top"},
        {map = "3,1", path = "top"},
        {map = "3,0", path = "top"},
        {map = "0,1", path = "top"},
        {map = "-1,1", path = "top"},
        {map = "-1,-1", path = "top"},
        {map = "-2,-1", path = "top"},
        {map = "-1,0", path = "right"},
        {map = "5,-1", path = "bottom"},
        {map = "4,-1", path = "bottom"},
        {map = "4,0", path = "left"},
        {map = "5,0", path = "left"},
        {map = "-3,-5", path = "right"},
        {map = "-3,-6", path = "right"},
        {map = "-2,-6", path = "bottom"},
        {map = "-1,-6", path = "bottom"},
        {map = "0,-5", path = "right"},
        {map = "-1,-5", path = "right"},
        {map = "-2,-5", path = "right"},
        {map = "0,-4", path = "right"},
        {map = "-1,-4", path = "right"},
        {map = "-2,-4", path = "right"},
        {map = "-2,0", path = "right"},
        {map = "0,-2", path = "right"},
        {map = "-1,-2", path = "right"},
        {map = "-2,-2", path = "right"},
        {map = "1,-3", path = "right"},
        {map = "2,-1", path = "top"},
        {map = "2,-2", path = "top"},
        {map = "3,-2", path = "left"},
        {map = "1,-2", path = "right"},
        -- Cartes de combats
        {map = "1,-4", path = "right", fight = true},
        {map = "1,-5", path = "bottom", fight = true},
        {map = "2,-5", path = "left", fight = true},
        {map = "3,-5", path = "left", fight = true},
        {map = "2,-4", path = "top|right", fight = true},
        {map = "3,-4", path = "top", fight = true},
    }
end

function CimetiereIncarnam()
    return {
        {map = "-1,-4", path = "right"},
        {map = "3,-2", path = "left"},
        {map = "2,0", path = "top"},
        {map = "1,-2", path = "top"},
        {map = "1,-1", path = "top"},
        {map = "1,0", path = "top"},
        {map = "-1,-6", path = "bottom"},
        {map = "-2,-6", path = "bottom"},
        {map = "-3,-6", path = "bottom"},
        {map = "-3,-5", path = "right"},
        {map = "0,-5", path = "right"},
        {map = "-1,-5", path = "right"},
        {map = "-2,-5", path = "right"},
        {map = "0,-4", path = "right"},
        {map = "3,-4", path = "left"},
        {map = "-2,-4", path = "right"},
        {map = "0,-3", path = "right"},
        {map = "-1,-3", path = "right"},
        {map = "-2,-3", path = "right"},
        {map = "1,-3", path = "right"},
        {map = "1,-4", path = "right"},
        {map = "1,-5", path = "right"},
        {map = "2,-5", path = "bottom"},
        {map = "3,-5", path = "left"},
        {map = "-2,-2", path = "top"},
        {map = "-1,-2", path = "top"},
        {map = "-1,-1", path = "top"},
        {map = "-2,-1", path = "top"},
        {map = "0,1", path = "top"},
        {map = "-1,1", path = "top"},
        {map = "-2,0", path = "right"},
        {map = "-1,0", path = "right"},
        {map = "3,-3", path = "left"},
        {map = "2,-4", path = "bottom"},
        {map = "2,-3", path = "bottom"},
        {map = "2,-2", path = "bottom"},
        {map = "4,-4", path = "left"},
        {map = "4,-3", path = "left"},
        {map = "2,-1", path = "right"},
        {map = "3,-1", path = "bottom"},
        {map = "0,0", path = "right"},
        -- Cartes de combats
        {map = "3,1", path = "right", fight = true},
        {map = "4,0", path = "left|right", fight = true},
        {map = "4,-1", path = "bottom", fight = true},
        {map = "4,1", path = "top", fight = true},
        {map = "5,-1", path = "left", fight = true},
        {map = "3,0", path = "bottom", fight = true},
        {map = "5,0", path = "top", fight = true},
    }
end

function GoToAstrub()
    return {
        {map = "-1,1", path = "top"},
        {map = "0,1", path = "top"},
        {map = "-3,-5", path = "right"},
        {map = "2,-4", path = "right"},
        {map = "2,-5", path = "right"},
        {map = "1,-5", path = "right"},
        {map = "-1,-5", path = "right"},
        {map = "-2,-5", path = "right"},
        {map = "1,-4", path = "right"},
        {map = "0,-4", path = "right"},
        {map = "-1,-4", path = "right"},
        {map = "0,-1", path = "right"},
        {map = "1,-2", path = "top"},
        {map = "1,-1", path = "top"},
        {map = "1,0", path = "top"},
        {map = "2,0", path = "top"},
        {map = "4,-4", path = "bottom"},
        {map = "0,-5", path = "bottom"},
        {map = "3,-4", path = "bottom"},
        {map = "3,-5", path = "bottom"},
        {map = "-1,-6", path = "bottom"},
        {map = "3,-2", path = "top"},
        {map = "-1,-2", path = "top"},
        {map = "-1,-1", path = "top"},
        {map = "-2,-2", path = "top"},
        {map = "-2,-1", path = "top"},
        {map = "-2,0", path = "top"},
        {map = "-1,0", path = "left"},
        {map = "-2,-6", path = "bottom"},
        {map = "2,-1", path = "top"},
        {map = "2,-2", path = "top"},
        {map = "2,-3", path = "right"},
        {map = "3,-3", path = "right"},
        {map = "-3,-6", path = "right"},
        {map = "-2,-4", path = "right"},
        {map = "1,-3", path = "right"},
        {map = "0,-3", path = "right"},
        {map = "-1,-3", path = "right"},
        {map = "-2,-3", path = "right"},
        {map = "5,0", path = "left"},
        {map = "5,-1", path = "left"},
        {map = "4,-1", path = "bottom"},
        {map = "4,0", path = "left"},
        {map = "4,1", path = "left"},
        {map = "3,1", path = "top"},
        {map = "3,0", path = "top"},
        {map = "3,-1", path = "left"},
        {map = "4,-3", custom = Portail},
        {map = "0,0", path = "right"},
    }
end

function DeplacementsCereale()

    if (map:currentMapId() == 192937992) then
        global:printMessage("On est sur la map de l'atelier paysan, je sors ...")
        map:moveToward(189794311) -- mapid exterieur atelier paysan
    end

    return {
        { map = "4,-19", path = "top", gather = false, fight = false },  
        { map = "4,-20", path = "top", gather = false, fight = false },  
        { map = "191104002", path = "top", gather = false, fight = false },  
        { map = "192415750", path = "409" },  
        { map = "4,-17", path = "top", gather = false, fight = false },  
        { map = "3,-19", path = "right", gather = false, fight = false },  
        { map = "3,-18", path = "right", gather = false, fight = false },  
        { map = "3,-17", path = "right", gather = false, fight = false },  
        { map = "2,-18", path = "right", gather = false, fight = false },  
        { map = "1,-18", path = "right", gather = false, fight = false },  
        { map = "0,-18", path = "right", gather = false, fight = false },  
        { map = "-1,-18", path = "right", gather = false, fight = false },  
        { map = "-2,-18", path = "right", gather = false, fight = false },  
        { map = "-3,-18", path = "right", gather = false, fight = false },  
        { map = "2,-17", path = "top", gather = false, fight = false },  
        { map = "2,-16", path = "top", gather = false, fight = false },  
        { map = "1,-16", path = "top", gather = false, fight = false },  
        { map = "1,-17", path = "top", gather = false, fight = false },  
        { map = "0,-17", path = "top", gather = false, fight = false },  
        { map = "-1,-17", path = "top", gather = false, fight = false },  
        { map = "-2,-17", path = "top", gather = false, fight = false },  
        { map = "-3,-17", path = "top", gather = false, fight = false },  
        { map = "-3,-16", path = "top", gather = false, fight = false },  
        { map = "-2,-16", path = "top", gather = false, fight = false },  
        { map = "-1,-16", path = "top", gather = false, fight = false },  
        { map = "0,-16", path = "top", gather = false, fight = false },  
        { map = "-3,-15", path = "top", gather = false, fight = false },  
        { map = "-3,-14", path = "top", gather = false, fight = false },  
        { map = "-2,-14", path = "top", gather = false, fight = false },  
        { map = "-2,-15", path = "top", gather = false, fight = false },  
        { map = "-1,-15", path = "top", gather = false, fight = false },  
        { map = "-1,-14", path = "top", gather = false, fight = false },  
        { map = "0,-14", path = "top", gather = false, fight = false },  
        { map = "0,-15", path = "top", gather = false, fight = false },  
        { map = "1,-15", path = "top", gather = false, fight = false },  
        { map = "1,-14", path = "top", gather = false, fight = false },  
        { map = "2,-15", path = "top", gather = false, fight = false },  
        { map = "2,-14", path = "top", gather = false, fight = false },  
        { map = "4,-14", path = "top", gather = false, fight = false },  
        { map = "3,-14", path = "top", gather = false, fight = false },  
        { map = "4,-16", path = "right", gather = false, fight = false },  
        { map = "3,-16", path = "right", gather = false, fight = false },  
        { map = "5,-17", path = "top", gather = false, fight = false },  
        { map = "5,-16", path = "top", gather = false, fight = false },  
        { map = "5,-14", path = "top", gather = false, fight = false },  
        { map = "5,-18", path = "top", gather = false, fight = false },  
        { map = "5,-19", path = "left", gather = false, fight = false },  
        { map = "6,-19", path = "left", gather = false, fight = false },  
        { map = "6,-18", path = "left", gather = false, fight = false },  
        { map = "6,-17", path = "left", gather = false, fight = false },  
        { map = "6,-16", path = "left", gather = false, fight = false },  
        { map = "6,-15", path = "left", gather = false, fight = false },  
        { map = "7,-16", path = "left", gather = false, fight = false },  
        { map = "7,-15", path = "left", gather = false, fight = false },  
        { map = "7,-14", path = "left", gather = false, fight = false },  
        { map = "6,-14", path = "left", gather = false, fight = false },  
        { map = "-3,-13", path = "top", gather = false, fight = false },  
        { map = "-2,-13", path = "top", gather = false, fight = false },  
        { map = "-1,-13", path = "top", gather = false, fight = false },  
        { map = "1,-13", path = "top", gather = false, fight = false },  
        { map = "0,-13", path = "top", gather = false, fight = false },  
        { map = "2,-13", path = "top", gather = false, fight = false },  
        { map = "3,-13", path = "top", gather = false, fight = false },  
        { map = "3,-12", path = "top", gather = false, fight = false },  
        { map = "3,-10", path = "top", gather = false, fight = false },  
        { map = "3,-9", path = "top", gather = false, fight = false },  
        { map = "3,-8", path = "top", gather = false, fight = false },  
        { map = "4,-8", path = "top", gather = false, fight = false },  
        { map = "4,-9", path = "top", gather = false, fight = false },  
        { map = "5,-9", path = "top", gather = false, fight = false },  
        { map = "6,-9", path = "top", gather = false, fight = false },  
        { map = "7,-9", path = "top", gather = false, fight = false },  
        { map = "7,-8", path = "top", gather = false, fight = false },  
        { map = "8,-8", path = "top", gather = false, fight = false },  
        { map = "8,-9", path = "top", gather = false, fight = false },  
        { map = "9,-9", path = "top", gather = false, fight = false },  
        { map = "9,-8", path = "top", gather = false, fight = false },  
        { map = "9,-10", path = "top", gather = false, fight = false },  
        { map = "10,-10", path = "top", gather = false, fight = false },  
        { map = "10,-11", path = "top", gather = false, fight = false },  
        { map = "10,-12", path = "top", gather = false, fight = false },  
        { map = "11,-11", path = "left", gather = false, fight = false },  
        { map = "11,-12", path = "left", gather = false, fight = false },  
        { map = "11,-13", path = "left", gather = false, fight = false },  
        { map = "11,-14", path = "left", gather = false, fight = false },  
        { map = "10,-14", path = "left", gather = false, fight = false },  
        { map = "9,-14", path = "left", gather = false, fight = false },  
        { map = "10,-13", path = "left", gather = false, fight = false },  
        { map = "9,-13", path = "left", gather = false, fight = false },  
        { map = "8,-14", path = "left", gather = false, fight = false },  
        { map = "8,-13", path = "left", gather = false, fight = false },  
        { map = "7,-13", path = "left", gather = false, fight = false },  
        { map = "9,-12", path = "left", gather = false, fight = false },  
        { map = "9,-11", path = "left", gather = false, fight = false },  
        { map = "8,-11", path = "left", gather = false, fight = false },  
        { map = "8,-10", path = "left", gather = false, fight = false },  
        { map = "7,-12", path = "left", gather = false, fight = false },  
        { map = "8,-12", path = "left", gather = false, fight = false },  
        { map = "7,-11", path = "left", gather = false, fight = false },  
        { map = "7,-10", path = "left", gather = false, fight = false },  
        { map = "6,-13", path = "left", gather = false, fight = false },  
        { map = "6,-12", path = "left", gather = false, fight = false },  
        { map = "6,-11", path = "left", gather = false, fight = false },  
        { map = "6,-10", path = "left", gather = false, fight = false },  
        { map = "5,-13", path = "top", gather = false, fight = false },  
        { map = "5,-12", path = "top", gather = false, fight = false },  
        { map = "5,-11", path = "top", gather = false, fight = false },  
        { map = "5,-10", path = "top", gather = false, fight = false },  
        { map = "4,-10", path = "top", gather = false, fight = false },  
        { map = "4,-11", path = "top", gather = false, fight = false },  
        { map = "4,-12", path = "top", gather = false, fight = false },  
        { map = "3,-11", path = "top", gather = false, fight = false },  
        { map = "4,-13", path = "top", gather = false, fight = false },  
        { map = "7,-17", path = "top", gather = false, fight = false },  
        { map = "8,-17", path = "top", gather = false, fight = false },  
        { map = "8,-16", path = "top", gather = false, fight = false },  
        { map = "8,-15", path = "top", gather = false, fight = false },  
        { map = "9,-17", path = "top", gather = false, fight = false },  
        { map = "9,-16", path = "top", gather = false, fight = false },  
        { map = "9,-15", path = "top", gather = false, fight = false },  
        { map = "10,-15", path = "top", gather = false, fight = false },  
        { map = "10,-16", path = "top", gather = false, fight = false },  
        { map = "10,-17", path = "top", gather = false, fight = false },  
        { map = "11,-17", path = "top", gather = false, fight = false },  
        { map = "11,-16", path = "top", gather = false, fight = false },  
        { map = "11,-15", path = "top", gather = false, fight = false },  
        { map = "12,-18", path = "left", gather = false, fight = false },  
        { map = "12,-17", path = "left", gather = false, fight = false },  
        { map = "12,-15", path = "left", gather = false, fight = false },  
        { map = "12,-16", path = "left", gather = false, fight = false },  
        { map = "11,-18", path = "left", gather = false, fight = false },  
        { map = "10,-18", path = "left", gather = false, fight = false },  
        { map = "9,-18", path = "left", gather = false, fight = false },  
        { map = "8,-18", path = "left", gather = false, fight = false },  
        { map = "7,-18", path = "left", gather = false, fight = false },  
        { map = "7,-19", path = "bottom", gather = false, fight = false },  
        { map = "8,-19", path = "bottom", gather = false, fight = false },  
        { map = "11,-19", path = "top", gather = false, fight = false },  
        { map = "12,-19", path = "top", gather = false, fight = false },  
        { map = "12,-20", path = "left", gather = false, fight = false },  
        { map = "11,-20", path = "left", gather = false, fight = false },  
        { map = "10,-20", path = "left", gather = false, fight = false },  
        { map = "9,-20", path = "left", gather = false, fight = false },  
        { map = "8,-20", path = "left", gather = false, fight = false },  
        { map = "7,-20", path = "left", gather = false, fight = false },  
        { map = "6,-20", path = "left", gather = false, fight = false },  
        { map = "5,-20", path = "left", gather = false, fight = false },  
        { map = "3,-20", path = "right", gather = false, fight = false },  
        { map = "2,-20", path = "right", gather = false, fight = false },  
        { map = "2,-19", path = "right", gather = false, fight = false },  
        { map = "1,-20", path = "right", gather = false, fight = false },  
        { map = "1,-19", path = "right", gather = false, fight = false },  
        { map = "0,-20", path = "right", gather = false, fight = false },  
        { map = "0,-19", path = "right", gather = false, fight = false },  
        { map = "-1,-20", path = "right", gather = false, fight = false },  
        { map = "-1,-19", path = "right", gather = false, fight = false },  
        { map = "-2,-20", path = "right", gather = false, fight = false },  
        { map = "-2,-19", path = "right", gather = false, fight = false },  
        { map = "-3,-20", path = "right", gather = false, fight = false },  
        { map = "-3,-19", path = "right", gather = false, fight = false },  
        { map = "1,-21", path = "right", gather = false, fight = false },  
        { map = "0,-21", path = "right", gather = false, fight = false },  
        { map = "-1,-21", path = "right", gather = false, fight = false },  
        { map = "1,-27", path = "right", gather = false, fight = false },  
        { map = "0,-27", path = "right", gather = false, fight = false },  
        { map = "-1,-27", path = "right", gather = false, fight = false },  
        { map = "-2,-27", path = "right", gather = false, fight = false },  
        { map = "-3,-27", path = "right", gather = false, fight = false },  
        { map = "-3,-26", path = "right", gather = false, fight = false },  
        { map = "-3,-25", path = "right", gather = false, fight = false },  
        { map = "-3,-24", path = "right", gather = false, fight = false },  
        { map = "-3,-23", path = "right", gather = false, fight = false },  
        { map = "-3,-22", path = "right", gather = false, fight = false },  
        { map = "-3,-21", path = "right", gather = false, fight = false },  
        { map = "-2,-21", path = "right", gather = false, fight = false },  
        { map = "-2,-22", path = "right", gather = false, fight = false },  
        { map = "-1,-22", path = "right", gather = false, fight = false },  
        { map = "0,-22", path = "right", gather = false, fight = false },  
        { map = "1,-22", path = "right", gather = false, fight = false },  
        { map = "1,-23", path = "right", gather = false, fight = false },  
        { map = "0,-23", path = "right", gather = false, fight = false },  
        { map = "-1,-23", path = "right", gather = false, fight = false },  
        { map = "-2,-23", path = "right", gather = false, fight = false },  
        { map = "-2,-24", path = "right", gather = false, fight = false },  
        { map = "-1,-24", path = "right", gather = false, fight = false },  
        { map = "0,-24", path = "right", gather = false, fight = false },  
        { map = "1,-24", path = "right", gather = false, fight = false },  
        { map = "1,-25", path = "right", gather = false, fight = false },  
        { map = "0,-25", path = "right", gather = false, fight = false },  
        { map = "-1,-25", path = "right", gather = false, fight = false },  
        { map = "-2,-25", path = "right", gather = false, fight = false },  
        { map = "-2,-26", path = "right", gather = false, fight = false },  
        { map = "-1,-26", path = "right", gather = false, fight = false },  
        { map = "0,-26", path = "right", gather = false, fight = false },  
        { map = "1,-26", path = "right", gather = false, fight = false },  
        { map = "-3,-28", path = "bottom", gather = false, fight = false },  
        { map = "-2,-28", path = "bottom", gather = false, fight = false },  
        { map = "-3,-29", path = "bottom", gather = false, fight = false },  
        { map = "-2,-29", path = "bottom", gather = false, fight = false },  
        { map = "-1,-28", path = "bottom", gather = false, fight = false },  
        { map = "0,-28", path = "bottom", gather = false, fight = false },  
        { map = "1,-28", path = "bottom", gather = false, fight = false },  
        { map = "2,-28", path = "bottom", gather = false, fight = false },  
        { map = "2,-29", path = "bottom", gather = false, fight = false },  
        { map = "9,-21", path = "left", gather = false, fight = false },  
        { map = "10,-21", path = "left", gather = false, fight = false },  
        { map = "11,-21", path = "left", gather = false, fight = false },  
        { map = "12,-21", path = "left", gather = false, fight = false },  
        { map = "4,-21", path = "right", gather = false, fight = false },  
        { map = "5,-21", path = "right", gather = false, fight = false },  
        { map = "6,-21", path = "right", gather = true, fight = false },  
        { map = "7,-21", path = "top", gather = true, fight = false },  
        { map = "7,-22", path = "left", gather = true, fight = false },  
        { map = "6,-22", path = "left", gather = true, fight = false },  
        { map = "5,-22", path = "left", gather = true, fight = false },  
        { map = "4,-22", path = "left", gather = true, fight = false },  
        { map = "3,-22", path = "top", gather = true, fight = false },  
        { map = "3,-23", path = "right", gather = true, fight = false },  
        { map = "4,-23", path = "right", gather = true, fight = false },  
        { map = "5,-23", path = "right", gather = true, fight = false },  
        { map = "6,-23", path = "right", gather = true, fight = false },  
        { map = "7,-23", path = "right", gather = true, fight = false },  
        { map = "8,-23", path = "right", gather = true, fight = false },  
        { map = "9,-23", path = "top", gather = true, fight = false },  
        { map = "9,-24", path = "left", gather = true, fight = false },  
        { map = "8,-24", path = "left", gather = true, fight = false },  
        { map = "189794311", path = "left", gather = true, fight = false },  --mapid exterieur atelier paysan
        { map = "6,-24", path = "left", gather = true, fight = false },  
        { map = "5,-24", path = "left", gather = true, fight = false },  
        { map = "4,-24", path = "left", gather = true, fight = false },  
        { map = "3,-24", path = "top", gather = true, fight = false },  
        { map = "7,-25", path = "top", gather = true, fight = false },  
        { map = "3,-26", path = "top", gather = true, fight = false },  
        { map = "7,-27", path = "top", gather = true, fight = false },  
        { map = "7,-28", path = "left", gather = true, fight = false },  
        { map = "7,-26", path = "left", gather = true, fight = false },  
        { map = "6,-26", path = "left", gather = true, fight = false },  
        { map = "5,-26", path = "left", gather = true, fight = false },  
        { map = "4,-26", path = "left", gather = true, fight = false },  
        { map = "6,-28", path = "left", gather = true, fight = false },  
        { map = "5,-28", path = "left", gather = true, fight = false },  
        { map = "4,-28", path = "left", gather = true, fight = false },  
        { map = "4,-27", path = "right", gather = true, fight = false },  
        { map = "3,-27", path = "right", gather = true, fight = false },  
        { map = "5,-27", path = "right", gather = true, fight = false },  
        { map = "6,-27", path = "right", gather = true, fight = false },  
        { map = "6,-25", path = "right", gather = true, fight = false },  
        { map = "5,-25", path = "right", gather = true, fight = false },  
        { map = "4,-25", path = "right", gather = true, fight = false },  
        { map = "3,-25", path = "right", gather = true, fight = false },  
        { map = "3,-28", path = "top", gather = true, fight = false },  
        { map = "3,-29", path = "right", gather = true, fight = false },  
        { map = "4,-29", path = "right", gather = true, fight = false },  
        { map = "5,-29", path = "right", gather = true, fight = false },  
        { map = "6,-29", path = "top", gather = true, fight = false },  
        { map = "6,-30", path = "left", gather = true, fight = false },  
        { map = "5,-30", path = "left", gather = true, fight = false },  
        { map = "4,-30", path = "top", gather = true, fight = false },  
        { map = "4,-31", path = "left", gather = true, fight = false },  
        { map = "3,-31", path = "bottom", gather = true, fight = false },  
        { map = "3,-30", path = "left", gather = true, fight = false },  
        { map = "2,-27", path = "bottom", gather = false, fight = false },  
        { map = "2,-26", path = "bottom", gather = false, fight = false },  
        { map = "2,-25", path = "bottom", gather = false, fight = false },  
        { map = "2,-24", path = "bottom", gather = false, fight = false },  
        { map = "2,-23", path = "bottom", gather = false, fight = false },  
        { map = "2,-22", path = "bottom", gather = false, fight = false },  
        { map = "2,-21", path = "right", gather = false, fight = false },  
        { map = "3,-21", path = "right", gather = false, fight = false },  
        { map = "8,-21", path = "left", gather = false, fight = false },  
        { map = "8,-22", path = "left", gather = false, fight = false },  
        { map = "9,-22", path = "left", gather = false, fight = false },  
        { map = "11,-22", path = "bottom", gather = false, fight = false },  
        { map = "11,-23", path = "bottom", gather = false, fight = false },  
        { map = "11,-24", path = "bottom", gather = false, fight = false },  
        { map = "11,-25", path = "bottom", gather = false, fight = false },  
        { map = "11,-26", path = "bottom", gather = false, fight = false },  
        { map = "11,-27", path = "bottom", gather = false, fight = false },  
        { map = "11,-28", path = "bottom", gather = false, fight = false },  
        { map = "12,-28", path = "left", gather = false, fight = false },  
        { map = "13,-28", path = "left", gather = false, fight = false },  
        { map = "13,-27", path = "left", gather = false, fight = false },  
        { map = "12,-27", path = "left", gather = false, fight = false },  
        { map = "12,-26", path = "left", gather = false, fight = false },  
        { map = "12,-25", path = "left", gather = false, fight = false },  
        { map = "12,-24", path = "left", gather = false, fight = false },  
        { map = "12,-23", path = "left", gather = false, fight = false },  
        { map = "12,-22", path = "left", gather = false, fight = false },  
        { map = "10,-22", path = "right", gather = false, fight = false },  
        { map = "10,-23", path = "right", gather = false, fight = false },  
        { map = "10,-24", path = "right", gather = false, fight = false },  
        { map = "10,-25", path = "right", gather = false, fight = false },  
        { map = "10,-26", path = "right", gather = false, fight = false },  
        { map = "10,-27", path = "right", gather = false, fight = false },  
        { map = "10,-28", path = "right", gather = false, fight = false },  
        { map = "10,-29", path = "left", gather = false, fight = false },  
        { map = "9,-29", path = "left", gather = false, fight = false },  
        { map = "8,-29", path = "bottom", gather = false, fight = false },  
        { map = "9,-28", path = "left", gather = false, fight = false },  
        { map = "8,-28", path = "left", gather = false, fight = false },  
        { map = "8,-27", path = "top", gather = false, fight = false },  
        { map = "9,-27", path = "top", gather = false, fight = false },  
        { map = "9,-26", path = "top", gather = false, fight = false },  
        { map = "8,-26", path = "top", gather = false, fight = false },  
        { map = "8,-25", path = "top", gather = false, fight = false },  
        { map = "9,-25", path = "bottom", gather = false, fight = false },  
        { map = "2,-30", path = "bottom", gather = false, fight = false },  
        }
end


function Portail()
    npc:npc(4398, 3)
    global:delay(974)
    npc:reply(-1)
    global:delay(1024)
    npc:reply(-1)
    global:delay(5000)
end

function ProcessBank()
    npc:npc(522, 3)
    global:delay(1249)
    npc:reply(-1)
    global:delay(1654)
    exchange:putAllItems()

    global:delay(2457)

    if (NeedToReturnBank) then
        NeedToReturnBank = false

        if (SellMode) then
            global:printSuccess("[Info] Le mode vente est activé, je vérifies combien de lots je peux vendre !")
            local nombreLotsGreuvette = math.floor(exchange:storageItemQuantity(7652) / 100)
            global:printSuccess("[Info] Je peux vendre " .. nombreLotsGreuvette .. " lots de [Michette] !")
            exchange:getItem(7652, nombreLotsGreuvette * 100)
            NeedToSell = true
            global:delay(2146)
        end

    else
        NbBle = exchange:storageItemQuantity(289) -- id du blé

        global:printSuccess("[Banque] : " .. NbBle .. " [Blé].")

        if (job:level(28) >= 10) then
            global:printSuccess("[Info] Le niveau de votre métier de Paysan vous permet de fabriquer des [Michette] !")
            local NbLotsBle = math.floor(NbBle / 5)

            if (NbLotsBle < 1) then
                global:printError("[Info] Pas assez d'[Blé] disponibles en banque pour fabriquer des [Michette]")
            else

                local podsAvailable = (inventory:podsMax() - inventory:pods())

                local quantiteMaxBleAPrendre = podsAvailable / 2
                
                CraftQuantity = math.floor(quantiteMaxBleAPrendre / 5)
                
                if (NbLotsBle * 5 > quantiteMaxBleAPrendre) then
                    CraftQuantity = math.floor(quantiteMaxBleAPrendre / 5)
                end

                global:printSuccess("[Info] Possibilité de création de " .. CraftQuantity .. "x [Michette]")
                global:printSuccess("[Info] Quantités à retirer de [Blé] : " .. CraftQuantity * 5 .. "")

                exchange:getItem(289, CraftQuantity * 5)
                global:delay(2647)
                NeedToCraft = true
            end
        else
            global:printSuccess("[Info] Vous n'avez pas encore atteint le niveau de Paysan nécessaire à la fabrication de [Michette] !")
        end
    end

    global:leaveDialog()
    global:delay(1547)
    map:moveToCell(409)
    global:delay(1394)
end

function ProcessCraft()
    map:useById(515683, -1) -- id de la machine de craft
    global:delay(2148)
    craft:putItem(289, 5) -- id du blé
    global:delay(3476)
    craft:changeQuantityToCraft(CraftQuantity)
    global:delay(2458)
    craft:ready()
    global:delay(4237)
    global:leaveDialog()
    global:delay(1258)
    global:printMessage("Craft terminé, je sors de l'atelier!")
    map:moveToward(189794311) -- mapid map exterieur atelier paysan
    NeedToCraft = false
    NeedToReturnBank = true
    global:delay(3259)
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
