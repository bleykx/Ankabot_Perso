-- /$$$$$$$  /$$                     /$$                        /$$$           /$$$$$$$$                            
-- | $$__  $$| $$                    | $$                       /$$ $$         | $$_____/                            
-- | $$  \ $$| $$  /$$$$$$  /$$   /$$| $$   /$$ /$$   /$$      |  $$$          | $$    /$$    /$$ /$$   /$$  /$$$$$$$
-- | $$$$$$$ | $$ /$$__  $$| $$  | $$| $$  /$$/|  $$ /$$/       /$$ $$/$$      | $$$$$|  $$  /$$/| $$  | $$ /$$_____/
-- | $$__  $$| $$| $$$$$$$$| $$  | $$| $$$$$$/  \  $$$$/       | $$  $$_/      | $$__/ \  $$/$$/ | $$  | $$|  $$$$$$ 
-- | $$  \ $$| $$| $$_____/| $$  | $$| $$_  $$   >$$  $$       | $$\  $$       | $$     \  $$$/  | $$  | $$ \____  $$
-- | $$$$$$$/| $$|  $$$$$$$|  $$$$$$$| $$ \  $$ /$$/\  $$      |  $$$$/$$      | $$$$$$$$\  $/   |  $$$$$$$ /$$$$$$$/
-- |_______/ |__/ \_______/ \____  $$|__/  \__/|__/  \__/       \____/\_/      |________/ \_/     \____  $$|_______/ 
--                          /$$  | $$                                                             /$$  | $$          
--                         |  $$$$$$/                                                            |  $$$$$$/          
--                          \______/                                                              \______/           


-----------------------------------------
-- 🙏 Merci d'utiliser nos scripts 🙏 --
-----------------------------------------


-- !!! READ ME !!!
-- Ce script de vente automatique repose sur un système de White liste. 
-- Vous devez impérativement renseigner tout les ID des items que vous souhaitez vendre dans la variable "Whitelist" ci dessous
-- Vous devez aussi renseigner plusieurs ID de map / cellule / npc ainsi que les MDP des vos coffres et portes de maison


HaveMaison = false; -- Si vous voulez que le script se déplace jusqu'à votre maison pour prendre les items, mettre à true
NomProprioMaison = "Evysdfogk#4748";  -- Pseudo du personnage propriétaire de la Maison


-- Whitelist des items qui seront mis en vente
Whitelist = {
    423, --Lin
    449, --Bois d'Ébène
    16488, --Bois de Noisetier
    474, --Bois de Merisier
    461, --Bois d'If
    471, --Bois d'Érable
    460, --Bois de Chêne
    405, --Malt
    532, --Seigle
    425, --Chanvre
    401, --Houblon
    476, --Bois de Noyer
    473, --Bois de Châtaignier
    303, --Bois de Frêne
}


-- Coefficient pour déterminer quel est le prix minimum de vente, si le prix est en dessous du prix de vente, l'item n'est pas mit en vente
CoefPrixMini = 0.7;

-- Coefficient pour déterminer le prix de vente d'un Lot quand aucun autre Lot n'est en vente
-- Si aucun Lots par 100, alors le prix sera le prix des Lots par 10 * le coefficient
-- Si aucun Lots par 10, alors le prix sera le prix des Lots par 1 * le coefficient
CoefLotSansPrix = 13;

-- Nombre de lot maximum en vente
MaxNbLot = 5;

-- Taille des lots mis en vente
LotSize = 100;

-- Temps des pauses en minutes
DelayTime = 5;


-- CONFIG HDV RESSOURCE

-- ID de la Map de l'HDV Ressource
IdMapHDVRessource = 191104004;

-- ID HDV Ressource
IdElementNpcHDVRessource = 515220;


-- CONFIG BANQUE

-- ID de la Map de l'intérieur de la Banque
IdMapInterieurBanque = 192415750;

-- ID de la Map de l'extérieur de la Banque
IdMapExterieurBanque = 191104002;

-- ID de la Porte de la Banque
IdPorteInterieurBanque = 409;

IdPorteExterieurBanque = 288;


-- CONFIG MAISON

-- ID de la Map de votre Maison
IdMapMaison = 54173485;

-- ID de la Map de la pièce où se trouve votre coffre à l'intérieur de votre Maison
IdMapInterieurMaison = 54532106;

IdMapExterieurMaison = "???";

-- ID de la Cellule de la Porte de l'extérieur de votre Maison
IdCellulePorteExterieurMaison = 267;

-- ID de la Cellule de la Porte de l'intérieur de votre Maison
IdCellulePorteInterieurMaison = 386;

-- MDP de la Porte de votre Maison
MDPPorteMaison = "91234487";

-- ID de la Map où se trouve votre Coffre
IdMapCoffre = 54533130;

-- ID de la Cellule de votre Coffre de votre Maison
IdCelluleCoffreMaison =  232;

-- MDP de votre Coffre de votre Maison
MDPCoffreMaison = "91234486";

-- !!! NE PAS TOUCHER !!!
NeedABreak = false;
GoForKamas = false;
GoCoffre = false;
GoHDVRessource = true;
GoHDVConso = false;
UpdateNeeded = true;
SellNeeded = false;
EmptyCoffre = true;
HDVFull = false;

RecapSession = {}
ItemSelling = {}

AUTO_DELETE = {}
GATHER = {}
MIN_MONSTERS = 1
MAX_MONSTERS = 8

function move()

    if GoHDVRessource then
        map:moveToward(IdMapHDVRessource);
    end

    if GoCoffre then
        if HaveMaison then
            map:moveToward(IdMapExterieurMaison);
        else
            map:moveToward(IdMapInterieurBanque);
        end
        if map:currentMapId() == IdMapExterieurMaison then
            EntrerDansMaison();
        end
        if map:currentMapId() == IdMapInterieurMaison then
            map:moveToward(IdMapCoffre);
        end
        if map:currentMapId() == IdMapCoffre then
            TakeItems();
        end
        if map:currentMapId() == IdMapInterieurBanque then
            TakeItems();
        end
    end

    if GoForKamas then
        map:moveToward(IdMapInterieurBanque);
        if map:currentMapId() == IdMapInterieurBanque then
            TakeKamas();
        end
    end
end

function bank()
    if GoHDVRessource then
        return CheminHDVRessource;
    end

    if GoCoffre then
        return
            CheminCoffreMaison;
    end

    if GoForKamas then
        return
            CheminKamasBanque;
    end
end

function phenix()
    return {
        -- La chemin vers le phenix si le personnage est mort
    }
end

function stopped()
    -- Lorsque le script est arrêté brusquement
end

function banned()
    global:printSuccess("Bruh...");
end

function mule_lost(bossMapId)
    -- Lorsqu'une mule ne se trouve pas dans la meme carte du chef
    global:printSuccess(bossMapId)
end

--Récupére les données des objets mis en ventes
function GetSalesDatas()
    global:leaveDialog()
    npc:npc(IdElementNpcHDVRessource, 5)
    ItemSelling = {};
    for i = 1, sale:itemsOnSale() do
        local alreadyInTable = false; 

        -- Si l'item est dans la liste, on incrémente le nombre de lot
        for _, item in ipairs(ItemSelling) do
            if item.itemID == sale:getItemGID(i) then
                item.nbLot = item.nbLot + 1;
                alreadyInTable = true;
            end
        end

        -- Sinon on rajoute l'item à la liste
        if not alreadyInTable then
        table.insert(ItemSelling, {
                itemID = sale:getItemGID(i),
                itemName = inventory:itemNameId(sale:getItemGID(i)),
                price = sale:getPriceItem(sale:getItemGID(i),GetIdNbLot()),
                minPrice = sale:getAveragePriceItem(sale:getItemGID(i), GetIdNbLot()) * CoefPrixMini;
                nbLot = 1
            })
        end
    end

    -- Scan son inventaire que si le bot a besoin de vendre 
    if SellNeeded then
        for _, itemID in ipairs(Whitelist) do
            local alreadyInTable = false; 
            for _, item in ipairs(ItemSelling) do
                if item.itemID == itemID then
                    item.price = sale:getPriceItem(itemID, GetIdNbLot());
                    alreadyInTable = true;
                    break;
                end
            end

            if inventory:itemCount(itemID) > LotSize - 1 then
                if not alreadyInTable then
                    table.insert(ItemSelling, {
                        itemID = itemID,
                        itemName = inventory:itemNameId(itemID),
                        price = sale:getPriceItem(itemID, GetIdNbLot()) -1,
                        minPrice = sale:getAveragePriceItem(itemID, GetIdNbLot()) * CoefPrixMini;
                        nbLot = 1
                    })
                end
            end
        end
    end

    -- Si aucun lot par 100 en vente, multiplie le prix des lot par 10 par le CoefLotSansPrix
    for _, item in ipairs(ItemSelling) do
        if item.price < 0 then
            item.price = sale:getPriceItem(item.itemID, GetIdNbLot() - 1) * CoefLotSansPrix;
        end
    end

    -- Check s'il reste des slots de vente
    if sale:availableSpace() > 0 then
        HDVFull = false;
    else
        HDVFull = true;
    end

    PrintTable();
end

function OuvreHDV()
    if map:currentMapId() == IdMapHDVRessource then
        global:printColor("#FF33F6","Ouverture de l'Hôtel de Vente.")
        npc:npc(IdElementNpcHDVRessource, 5)

        --Update les prix de l'HDV si l'HDV est plein à la connexion ou s'il a besoin d'actualiser après le coffre
        if UpdateNeeded then
            global:printColor("#FF33F6","[Information] J'actualise les prix de l'HDV Ressource.");
            sale:updateAllItems(-1);
            GetSalesDatas();
            UpdateNeeded = false;
        else
            GetSalesDatas();
        end

        if SellNeeded then
            global:printColor("#FF33F6","Je vends mon inventaire.");
            SellInventory();
            global:delay(2000);
            GetSalesDatas();
        end

        -- Fait une pause si aucun slot n'est dispo en HDV
        if sale:availableSpace() == 0 then
            global:printError("[Information] Plus aucun slots disponibles en HDV.")
            global:printColor("#FF33F6","[Information] J'actualise les prix de l'HDV Ressource.");
            sale:updateAllItems(-1);
            global:printColor("#FF33F6","[Pause] Je fais une pause de ".. DelayTime .. " minutes..")
            global:leaveDialog();
            PrintRecapTable();
            global:delay(DelayTime * 60 * 1000);
            global:printColor("#FF33F6","[Pause] Pause terminée")
            npc:npc(IdElementNpcHDVRessource, 5)
            sale:updateAllItems(-1);
            GetSalesDatas();
        end
        global:delay(2000);
        global:leaveDialog();

        if character:kamas() < 100000 then
            GoForKamas = true;
            global:printColor("#F04C00","[Mouvement] Je vais chercher des kamas")
        else
            GoCoffre = true;
            global:printColor("#F04C00","[Mouvement] Je vais au coffre")
        end

        GoHDVRessource = false;

        map:changeMap("top");
    end
end

-- Vend l'inventaire à l'HDV
function SellInventory()
    for _, item in ipairs(ItemSelling) do
        if item.nbLot <= MaxNbLot then
            for i = item.nbLot, MaxNbLot do
                if sale:availableSpace() > 0 then
                    if inventory:itemCount(item.itemID) > LotSize - 1 then
                        sale:sellItem(item.itemID, LotSize, item.price);
                        Recap(item);
                        global:delay(1000);
                        global:printColor ("#00ECFF", "[Mise en vente] ".. item.itemName .. " x " .. LotSize .. " | Prix : " .. item.price)
                    end
                    HDVFull = false;
                else
                    HDVFull = true;
                end
            end
        end
    end
    SellNeeded = false;
end

-- Gère le récap des objets mis en vente
function Recap(item)
    local alreadyInTable = false; 

    if #RecapSession == 0 then
        table.insert(RecapSession, {
            itemID = item.itemID,
            itemName = item.itemName,
            quantity = LotSize,
            totalKamas = item.price,
        });
    else
        for _, itemSession in ipairs(RecapSession) do
            if itemSession.itemID == item.itemID then
                itemSession.quantity = itemSession.quantity + LotSize;
                itemSession.totalKamas = itemSession.totalKamas + item.price;
                alreadyInTable = true;
                break;
            end
        end
        if not alreadyInTable then
            table.insert(RecapSession, {
                itemID = item.itemID,
                itemName = item.itemName,
                quantity = LotSize,
                totalKamas = item.price,
            });
        end
    end
end

-- Récupére les items dans le coffre en fonction des slots disponibles en HDV
function TakeItems()
    local quantity = 0;
    local takeAnItem = false;

    if HaveMaison then     
        map:lockedStorage(IdCelluleCoffreMaison,MDPCoffreMaison);
    else
        npc:npcBank(-1);
        global:delay(1000);
        exchange:getKamas(0);
    end

    global:delay(1000);
    exchange:putAllItems();
    global:delay(1000);

    --Vérifie les conditions de pauses
    EmptyCoffre = true
    for _, itemID in ipairs(Whitelist) do
        if exchange:storageItemQuantity(itemID) > LotSize  - 1 then
            EmptyCoffre = false;
            break;
        end
    end

    -- Pour chaque items de la Whitelist
    for _, itemID in ipairs(Whitelist) do
        -- Pour chaque items dans la liste des items en vente
        for _, item in ipairs(ItemSelling) do
            -- Si l'item est déjà en vente
            if item.itemID == itemID then 
                quantity = MaxNbLot - item.nbLot;
                break;
            -- Sinon..
            else
                quantity = MaxNbLot;
            end
        end

        if #ItemSelling == 0 then
            quantity = MaxNbLot;
        end
        -- Récupére 100 x la quantité pour ne pas dépasser le nombre max de lot en vente

        for i = 1, quantity do
            -- Check s'il reste des pods
            if inventory:itemWeight(itemID)*LotSize > GetPod() then
                global:printSuccess("[BANQUE] Full Pods : go HDV.");
                break;
            else
                if exchange:storageItemQuantity(itemID) > LotSize - 1 then
                    exchange:getItem(itemID, LotSize);
                    takeAnItem = true;
                    SellNeeded = true;
                end
                EmptyCoffre = false;
            end
        end
    end

    if takeAnItem == false then
        NeedABreak = true;
        global:printError("[Information] Je n'ai pris aucun item dans le coffre");
        global:printError("[1] Soit plus aucun items de la Whitelist est présent dans le coffre...");
        global:printError("[2] Soit le nombre de lot max par item en HDV est atteint.");
    end

    global:delay(500)
    global:leaveDialog();

    if NeedABreak then
        global:printColor ("#00ECFF","[Pause] Je fais une pause de ".. DelayTime .. " minutes...")
        PrintRecapTable();
        global:delay(DelayTime * 60 * 1000);
        global:printColor("#FF33F6","[Pause] Pause terminée")
        NeedABreak = false;
        UpdateNeeded = true;
    end

    GoCoffre = false;
    GoHDVRessource = true;
    global:printColor("#F04C00","[Mouvement] Je vais à l'HDV ressource")
    
    map:moveToward(IdMapHDVRessource);
end

-- saisit le code pour entrer dans la maison
function EntrerDansMaison()
    if map:currentMap(IdMapExterieurMaison) then
        map:lockedHouse(IdCellulePorteExterieurMaison, MDPPorteMaison, NomProprioMaison);
    end
end

-- Retourne les Pods restantes
function GetPod()
	return inventory:podsMax() - inventory:pods()
end

function GetIdNbLot()
    if LotSize == 1 then
        return 1;
    end
    if LotSize == 10 then
        return 2;
    end
    if LotSize == 100 then
        return 3;
    end
end

function TakeKamas()
    npc:npcBank(-1)
    exchange:getKamas(0);
    global:leaveDialog();
    GoForKamas = false;
    GoCoffre = true;
    global:printColor("#F04C00","[Mouvement] Je vais au coffre");
    map:moveToCell(IdPorteInterieurBanque);
end

-- function PrintTable()
--     local total = 0;
-- 	global:printMessage("------------------------  RECAP HDV RESSOURCE ---------------------------"); 
-- 	for _, item in ipairs(ItemSelling) do	
-- 		global:printColor("#EFEB00",item.itemName .. " | Item ID : " .. item.itemID .. " | Nombre de Lots : " .. item.nbLot .. " | Prix : " .. item.price .. " | Prix minimum : " .. item.minPrice);
--         total = total + (item.price * item.nbLot);
--     end

--     global:printColor("#28FF06","---------------------------------------------------------------");
--     global:printColor("#28FF06","Valeur totale de l'HDV Ressource");
--     global:printColor("#28FF06",total);
-- 	global:printMessage("---------------------------------------------------------------");
-- end

function PrintHDV(ItemSelling)
    local maxLengthItemID = 0
    local maxLengthItemName = 0
    local maxLengthPrice = 0
    local maxLengthMinPrice = 0
    local maxLengthNbLot = 0

    for i = 1, #ItemSelling do
        if string.len(ItemSelling[i].itemID) > maxLengthItemID then
            maxLengthItemID = string.len(ItemSelling[i].itemID)
            if maxLengthItemID < string.len("Item ID") then
                maxLengthItemID = string.len("Item ID")
            end
        end
        if string.len(ItemSelling[i].itemName) > maxLengthItemName then
            maxLengthItemName = string.len(ItemSelling[i].itemName)
            if maxLengthItemName < string.len("Item Name") then
                maxLengthItemName = string.len("Item Name")
            end
        end
        if string.len(ItemSelling[i].price) > maxLengthPrice then
            maxLengthPrice = string.len(ItemSelling[i].price)
            if maxLengthPrice < string.len("Price") then
                maxLengthPrice = string.len("Price")
            end
        end
        if string.len(ItemSelling[i].minPrice) > maxLengthMinPrice then
            maxLengthMinPrice = string.len(ItemSelling[i].minPrice)
            if maxLengthMinPrice < string.len("Min Price") then
                maxLengthMinPrice = string.len("Min Price")
            end
        end
        if string.len(ItemSelling[i].nbLot) > maxLengthNbLot then
            maxLengthNbLot = string.len(ItemSelling[i].nbLot)
            if maxLengthNbLot < string.len("Nb Lot") then
                maxLengthNbLot = string.len("Nb Lot")
            end
        end
    end

    local color = {"#28FF06","#27EF08"}

    global:printColor(color[0],"Item ID" .. string.rep(" ", maxLengthItemID - string.len("Item ID")) .. "\t" ..
        "Item Name" .. string.rep(" ", maxLengthItemName - string.len("Item Name")) .. "\t" ..
        "Price" .. string.rep(" ", maxLengthPrice - string.len("Price")) .. "\t" ..
        "Min Price" .. string.rep(" ", maxLengthMinPrice - string.len("Min Price")) .. "\t" ..
        "Nb Lot".. string.rep(" ", maxLengthMinPrice - string.len("Nb Lot")))

    for i = 1, #ItemSelling do
        global:printColor(color[i%2],ItemSelling[i].itemID .. string.rep(" ", maxLengthItemID - string.len(ItemSelling[i].itemID)) .. "\t" ..
            ItemSelling[i].itemName .. string.rep(" ", maxLengthItemName - string.len(ItemSelling[i].itemName)) .. "\t" ..
            ItemSelling[i].price .. string.rep(" ", maxLengthPrice - string.len(ItemSelling[i].price)) .. "\t" ..
            ItemSelling[i].minPrice .. string.rep(" ", maxLengthMinPrice - string.len(ItemSelling[i].minPrice)) .. "\t" ..
            ItemSelling[i].nbLot .. string.rep(" ", maxLengthNbLot - string.len(ItemSelling[i].nbLot)))
    end
end


function PrintRecapTable()
    local total = 0;

	global:printColor("#28FF06","------------------------  RECAP Mise en vente ---------------------------"); 
	for _, item in ipairs(RecapSession) do	
		global:printColor("#28FF06",item.itemName .. " | Item ID : " .. item.itemID .. " | Nombre de Lots : " .. item.quantity .. " | Total Kamas : " .. item.totalKamas);
        total = total + (item.totalKamas * item.quantity);
    end
    global:printColor("#EFEB00","---------------------------------------------------------------");
    global:printColor("#EFEB00","Valeur totale de l'HDV Ressource");
    global:printColor("#EFEB00",total);
	global:printColor("#28FF06","---------------------------------------------------------------");
end

