List = {
    {itemID = 420, itemName = "Potion", price = 100000, minPrice = 5, nbLot = 1},
    {itemID = 421, itemName = "Pain de Larve de Frigost", price = 40000000, minPrice = 5, nbLot = 1},
    {itemID = 422, itemName = "Cawotte", price = 100, minPrice = 5, nbLot = 1},
    {itemID = 423, itemName = "CENDREPIERRE", price = 45810, minPrice = 5000, nbLot = 1},
    {itemID = 424, itemName = "Poudre de PERLINPAINPAIN toute blanche", price = 45810, minPrice = 5, nbLot = 1},
}

-- Type: Lua script, adapt this function for the List above
function printList(list)
    local maxLengthItemID = 0
    local maxLengthItemName = 0
    local maxLengthPrice = 0
    local maxLengthMinPrice = 0
    local maxLengthNbLot = 0

    for i = 1, #list do
        if string.len(list[i].itemID) > maxLengthItemID then
            maxLengthItemID = string.len(list[i].itemID)
            if maxLengthItemID < string.len("Item ID") then
                maxLengthItemID = string.len("Item ID")
            end
        end
        if string.len(list[i].itemName) > maxLengthItemName then
            maxLengthItemName = string.len(list[i].itemName)
            if maxLengthItemName < string.len("Item Name") then
                maxLengthItemName = string.len("Item Name")
            end
        end
        if string.len(list[i].price) > maxLengthPrice then
            maxLengthPrice = string.len(list[i].price)
            if maxLengthPrice < string.len("Price") then
                maxLengthPrice = string.len("Price")
            end
        end
        if string.len(list[i].minPrice) > maxLengthMinPrice then
            maxLengthMinPrice = string.len(list[i].minPrice)
            if maxLengthMinPrice < string.len("Min Price") then
                maxLengthMinPrice = string.len("Min Price")
            end
        end
        if string.len(list[i].nbLot) > maxLengthNbLot then
            maxLengthNbLot = string.len(list[i].nbLot)
            if maxLengthNbLot < string.len("Nb Lot") then
                maxLengthNbLot = string.len("Nb Lot")
            end
        end
    end

    print("Item ID" .. string.rep(" ", maxLengthItemID - string.len("Item ID")) .. "\t" ..
        "Item Name" .. string.rep(" ", maxLengthItemName - string.len("Item Name")) .. "\t" ..
        "Price" .. string.rep(" ", maxLengthPrice - string.len("Price")) .. "\t" ..
        "Min Price" .. string.rep(" ", maxLengthMinPrice - string.len("Min Price")) .. "\t" ..
        "Nb Lot".. string.rep(" ", maxLengthMinPrice - string.len("Nb Lot")))

    for i = 1, #list do
        print(list[i].itemID .. string.rep(" ", maxLengthItemID - string.len(list[i].itemID)) .. "\t" ..
            list[i].itemName .. string.rep(" ", maxLengthItemName - string.len(list[i].itemName)) .. "\t" ..
            list[i].price .. string.rep(" ", maxLengthPrice - string.len(list[i].price)) .. "\t" ..
            list[i].minPrice .. string.rep(" ", maxLengthMinPrice - string.len(list[i].minPrice)) .. "\t" ..
            list[i].nbLot .. string.rep(" ", maxLengthNbLot - string.len(list[i].nbLot)))
    end
end

printList(List)

-- Output:

-- Path: luaTest.lua
-- Type: Lua Script, print this list with the good number of tabulations to allign each collumn with the other

