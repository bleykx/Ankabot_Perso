HumanityManager = {}

function HumanityManager:new()
    local object = {}
    setmetatable(object, self)
    self.__index = self
    return object
end

function HumanityManager:FightDelay()
    -- Prend un nombre aléatoire
    local rand = global:random(1, 100)

    -- Dans 80% des cas
    if rand <= 80 then
        global:delay(math.random(2500, 3500))

    -- Dans 17% des cas
    elseif rand > 80 and rand <= 97 then
        global:delay(math.random(4500, 5500))

    -- Dans 2% des cas
    elseif rand > 97 and rand <= 99 then
        global:delay((math.random(8500, 9500)))

    -- Dans 1% des cas
    elseif rand > 99 and rand <= 100 then
        global:delay((math.random(13500, 15000)))
    end

    -- Je joue le tour avec l'IA basique, avec la tactique "CAC"
    fightBasic:playTurn(1)
end

function HumanityManager:CraftDelay()
    -- Prend un nombre aléatoire
    local rand = global:random(1, 100)

    -- Dans 80% des cas
    if rand <= 80 then
        global:delay(math.random(4000, 6000))
        

    -- Dans 17% des cas
    elseif rand > 80 and rand <= 97 then
        global:delay(math.random(9000, 11000))

    -- Dans 2% des cas
    elseif rand > 97 and rand <= 99 then
        global:delay(14000, 16000)

    -- Dans 1% des cas
    elseif rand > 99 and rand <= 100 then
        global:delay(19000, 21000)
    end
end

function HumanityManager:MoveDelay()
    -- Prend un nombre aléatoire
    local rand = global:random(1, 100)

    -- Dans 80% des cas
    if rand <= 80 then
        global:delay(math.random(1500, 2500))

    -- Dans 17% des cas
    elseif rand > 80 and rand <= 97 then
        global:delay(math.random(4000, 5000))

    -- Dans 2% des cas
    elseif rand > 97 and rand <= 99 then
        global:delay((math.random(7000, 8000)))

    -- Dans 1% des cas
    elseif rand > 99 and rand <= 100 then
        global:delay((math.random(11000, 12000)))
    end
end

function HumanityManager:HDVDelay()
    -- Prend un nombre aléatoire
    local rand = global:random(1, 100)

    -- Dans 80% des cas
    if rand <= 80 then
        global:delay(math.random(1500, 2500))

    -- Dans 17% des cas
    elseif rand > 80 and rand <= 97 then
        global:delay(math.random(4000, 5000))

    -- Dans 2% des cas
    elseif rand > 97 and rand <= 99 then
        global:delay((math.random(7000, 8000)))

    -- Dans 1% des cas
    elseif rand > 99 and rand <= 100 then
        global:delay((math.random(11000, 12000)))
    end
end