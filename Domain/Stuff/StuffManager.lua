StuffManager = {}

function StuffManager:new(bot)
    local object = {}
    object.Bot = bot
    setmetatable(object, self)
    self.__index = self
    return object
end


function StuffManager:EquipAventurier()
    if character:level() >= 1 and CouteauChasse == false then
        if inventory:equipItem(1934, 1) == true then
            global:printMessage("Je m'équipe du couteau de Chasse !")
            CouteauChasse = true
        end
    end
    -- Définition des zones de drop de la panoplie et des conditions
    if (map:currentArea() == "Incarnam") then
        enoughtForCouteau()
        if character:level() >= 3 then          
            if (inventory:itemCount(2473) >= 1 ) or (DropSetRequiredToLeaveIncarnam == false) then
                ZoneIncarnam = 1
                 if (inventory:itemCount(2478) >= 1 and needPlpp == false) or (DropSetRequiredToLeaveIncarnam == false) then
                    ZoneIncarnam = 4
                    if (inventory:itemCount(2476) >= 1 and needLaine == false) or (DropSetRequiredToLeaveIncarnam == false) then
                        ZoneIncarnam = 6
                        -- je sort de l'atelier avec mon couteau
                        if (CouteauChasse == true) or (DropSetRequiredToLeaveIncarnam == false) then
                            ZoneIncarnam = 2
                            if (inventory:itemCount(2477) >= 1) or (DropSetRequiredToLeaveIncarnam == false) then
                                ZoneIncarnam = 5
                                if (inventory:itemCount(2474) >= 1) or (DropSetRequiredToLeaveIncarnam == false) then
                                    ZoneIncarnam = 3
                                    if (inventory:itemCount(2475) >= 1 ) or (DropSetRequiredToLeaveIncarnam == false) then
                                        ZoneIncarnam = 7
                                    end
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
    end
end

function StuffManager:EquipCouteauChasse()
    if character:level() >= 1 and CouteauChasse == false then
        if inventory:equipItem(1934, 1) == true then
            global:printMessage("Je m'équipe du couteau de Chasse !")
            CouteauChasse = true
        end
        
    end
end

---@return boolean fullPano - True if the full set is equipped
function StuffManager:EquipPanoPiou()
    if(character:getAgilityBase() > 30) then
        local fullPano = self:EquipPanoPiouVert()
        if (fullPano) then
            return fullPano
        end
    end

    if(character:getStrenghtBase() > 30) then
        local fullPano = self:EquipPanoPiouJaune()
        if (fullPano) then
            return fullPano
        end
    end

    if(character:getIntelligenceBase() > 30) then
        local fullPano = self:EquipPanoPiouRouge()
        if (fullPano) then
            global:printSuccess("chibre")
            return fullPano
        end
    end

    if(character:getChanceBase() > 20) then
        local fullPano = self:EquipPanoPiouBleu()
        if (fullPano) then
            return fullPano
        end
    end
return false
end

function StuffManager:EquipPanoPiouBleu()
    -- 8214 - Amulette du Piou Bleu
    if(inventory:itemCount(8214) >= 1 and inventory:itemPosition(8214) == 63) then
        inventory:equipItem(8214, 0)
        global:printError("[Stuff Manager] Amulette du Piou Bleu équipée")
    end
    --8214 - Amulette du Piou Bleu
    if(inventory:itemCount(8220) >= 1 and inventory:itemPosition(8220) == 63) then
        inventory:equipItem(8220, 2)
        global:printError("[Stuff Manager] Anneau du Piou Bleu équipée")
    end
    --8226 - Sandales du Piou Bleu
    if(inventory:itemCount(8226) >= 1 and inventory:itemPosition(8226) == 63) then
        inventory:equipItem(8226, 5)
        global:printError("[Stuff Manager] Sandales du Piou Bleu équipée")
    end
    --8232 - Cape du Piou Bleu
    if(inventory:itemCount(8232) >= 1 and inventory:itemPosition(8232) == 63) then
        inventory:equipItem(8232, 7)
        global:printError("[Stuff Manager] Cape du Piou Bleu équipée")
    end
    --8238 - Ceinture du Piou Bleu
    if(inventory:itemCount(8238) >= 1 and inventory:itemPosition(8238) == 63) then
        inventory:equipItem(8238, 3)
        global:printError("[Stuff Manager] Ceinture du Piou Bleu équipée")
    end
    --8244 - Chapeau du Piou Bleu
    if(inventory:itemCount(8244) >= 1 and inventory:itemPosition(8244) == 63) then
        inventory:equipItem(8244, 6)
        global:printError("[Stuff Manager] Chapeau du Piou Bleu équipée")
    end

    if(
        inventory:itemPosition(8214) == 0 and
        inventory:itemPosition(8220) == 2 and
        inventory:itemPosition(8226) == 5 and
        inventory:itemPosition(8232) == 7 and
        inventory:itemPosition(8238) == 3 and
        inventory:itemPosition(8244) == 6
    ) then
        global:printSuccess("[Stuff Manager] Panoplie mise avec succès : [Piou Bleu]")
        return true
    end
end

function StuffManager:EquipPanoPiouJaune()
    -- 8217 - Amulette du Piou Jaune
    if(inventory:itemCount(8217) >= 1 and inventory:itemPosition(8217) == 63) then
        inventory:equipItem(8217, 0)
        global:printError("[Stuff Manager] Amulette du Piou Jaune équipée")
    end
    --8223 - Anneau du Piou Jaune
    if(inventory:itemCount(8223) >= 1 and inventory:itemPosition(8223) == 63) then
        inventory:equipItem(8223, 2)
        global:printError("[Stuff Manager] Anneau du Piou Jaune équipée")
    end
    --8229 - Sandales du Piou Jaune
    if(inventory:itemCount(8229) >= 1 and inventory:itemPosition(8229) == 63) then
        inventory:equipItem(8229, 5)
        global:printError("[Stuff Manager] Sandales du Piou Jaune équipée")
    end
    --8235 - Cape du Piou Jaune
    if(inventory:itemCount(8236) >= 1 and inventory:itemPosition(8236) == 63) then
        inventory:equipItem(8236, 7)
        global:printError("[Stuff Manager] Cape du Piou Jaune équipée")
    end
    --8241 - Ceinture du Piou Jaune
    if(inventory:itemCount(8241) >= 1 and inventory:itemPosition(8241) == 63) then
        inventory:equipItem(8241, 3)
        global:printError("[Stuff Manager] Ceinture du Piou Jaune équipée")
    end
    --8247 - Chapeau du Piou Jaune
    if(inventory:itemCount(8247) >= 1 and inventory:itemPosition(8247) == 63) then
        inventory:equipItem(8247, 6)
        global:printError("[Stuff Manager] Chapeau du Piou Jaune équipée")
    end

    if(
        inventory:itemPosition(8217) == 0 and
        inventory:itemPosition(8223) == 2 and
        inventory:itemPosition(8229) == 5 and
        inventory:itemPosition(8235) == 7 and
        inventory:itemPosition(8241) == 3 and
        inventory:itemPosition(8247) == 6
    ) then
        global:printSuccess("[Stuff Manager] Panoplie mise avec succès : [Piou Jaune]")
        return true
    end
end

function StuffManager:EquipPanoPiouRouge()
    -- 8213 - Amulette du Piou Rouge
    if(inventory:itemCount(8213) >= 1 and inventory:itemPosition(8213) == 63) then
        inventory:equipItem(8213, 0)
        global:printError("[Stuff Manager] Amulette du Piou Rouge équipée")
    end
    --8219 - Anneau du Piou Rouge
    if(inventory:itemCount(8219) >= 1 and inventory:itemPosition(8219) == 63) then
        inventory:equipItem(8219, 2)
        global:printError("[Stuff Manager] Anneau du Piou Rouge équipée")
    end
    --8225 - Sandales du Piou Rouge
    if(inventory:itemCount(8225) >= 1 and inventory:itemPosition(8225) == 63) then
        inventory:equipItem(8225, 5)
        global:printError("[Stuff Manager] Sandales du Piou Rouge équipée")
    end
    --8231 - Cape du Piou Rouge
    if(inventory:itemCount(8231) >= 1 and inventory:itemPosition(8231) == 63) then
        inventory:equipItem(8231, 7)
        global:printError("[Stuff Manager] Cape du Piou Rouge équipée")
    end
    --8237 - Ceinture du Piou Rouge
    if(inventory:itemCount(8237) >= 1 and inventory:itemPosition(8237) == 63) then
        inventory:equipItem(8237, 3)
        global:printError("[Stuff Manager] Ceinture du Piou Rouge équipée")
    end
    --8243 - Chapeau du Piou Rouge
    if(inventory:itemCount(8243) >= 1 and inventory:itemPosition(8243) == 63) then
        inventory:equipItem(8243, 6)
        global:printError("[Stuff Manager] Chapeau du Piou Rouge équipée")
    end

    if(
        inventory:itemPosition(8213) == 0 and
        inventory:itemPosition(8219) == 2 and
        inventory:itemPosition(8225) == 5 and
        inventory:itemPosition(8231) == 7 and
        inventory:itemPosition(8237) == 3 and
        inventory:itemPosition(8243) == 6
    ) then
        global:printSuccess("[Stuff Manager] Panoplie mise avec succès : [Piou Rouge]")
        return true
    else
        global:printError("[Stuff Manager] Panoplie non mise avec succès : [Piou Rouge]")
    end
end

function StuffManager:EquipPanoPiouVert()
    -- 8215 - Amulette du Piou Vert
    if(inventory:itemCount(8216) >= 1 and inventory:itemPosition(8216) == 63) then
        inventory:equipItem(8216, 0)
        global:printError("[Stuff Manager] Amulette du Piou Vert équipée")
    end
    --8221 - Anneau du Piou Vert
    if(inventory:itemCount(8222) >= 1 and inventory:itemPosition(8222) == 63) then
        inventory:equipItem(8222, 2)
        global:printError("[Stuff Manager] Anneau du Piou Vert équipée")
    end
    --8227 - Sandales du Piou Vert
    if(inventory:itemCount(8228) >= 1 and inventory:itemPosition(8228) == 63) then
        inventory:equipItem(8228, 5)
        global:printError("[Stuff Manager] Sandales du Piou Vert équipée")
    end
    --8233 - Cape du Piou Vert
    if(inventory:itemCount(8233) >= 1 and inventory:itemPosition(8233) == 63) then
        inventory:equipItem(8233, 7)
        global:printError("[Stuff Manager] Cape du Piou Vert équipée")
    end
    --8239 - Ceinture du Piou Vert
    if(inventory:itemCount(8240) >= 1 and inventory:itemPosition(8240) == 63) then
        inventory:equipItem(8240, 3)
        global:printError("[Stuff Manager] Ceinture du Piou Vert équipée")
    end
    --8245 - Chapeau du Piou Vert
    if(inventory:itemCount(8246) >= 1 and inventory:itemPosition(8246) == 63) then
        inventory:equipItem(8246, 6)
        global:printError("[Stuff Manager] Chapeau du Piou Vert équipée")
    end

    if(
        inventory:itemPosition(8216) == 0 and
        inventory:itemPosition(8222) == 2 and
        inventory:itemPosition(8228) == 5 and
        inventory:itemPosition(8233) == 7 and
        inventory:itemPosition(8240) == 3 and
        inventory:itemPosition(8246) == 6
    ) then
        global:printSuccess("[Stuff Manager] Panoplie mise avec succès : [Piou Vert]")
        return true
    end
end