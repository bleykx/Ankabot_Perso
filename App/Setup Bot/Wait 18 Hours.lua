AUTO_DELETE = {}
GATHER = {}
MIN_MONSTERS = 1
MAX_MONSTERS = 8


function move()
    local totalTime = global:totalTime()
    local hoursToWait = 18
    local secondToWait = hoursToWait * 60 * 60

    if(totalTime < secondToWait) then        
        local timeToWait = hoursToWait * 60 * 60 * 1000
        global:delay(timeToWait)
        return {
            global:printColor("#01F4FF", "Le Bot a attendu "..hoursToWait.." heures."),
         }
    end

    return {
        global:printColor("#01F4FF", "Le Bot a déjà attendu "..hoursToWait.." heures."),
    }
end

function bank()
    return {
    }
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