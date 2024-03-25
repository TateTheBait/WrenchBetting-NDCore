local prizepool = 0
local isbetopen = false


RegisterCommand("bet", function(idfk, args)
    TriggerServerEvent("wrenchbets:UpdateBets", GetPlayerServerId(PlayerId()))
    Wait(100)
    if isbetopen == true then
        local value = tonumber(args[1])
        if value then
            if type(value) == "number" then
                TriggerServerEvent("wrenchbets:addbet", GetPlayerServerId(PlayerId()), value)
            end
        else
            lib.notify({
                id = "betfail:noarg",
                title = "Bet",
                description = "Failed to place bet, please put a number after the command!"
            })
        end
    else
        lib.notify({
            id = "betfail:noarg",
            title = "Bet",
            description = "A bet has not been started yet!"
        })
    end
end, false)


RegisterCommand("startbet", function ()
    TriggerServerEvent("wrenchbets:openbet", GetPlayerServerId(PlayerId()))
end, false)



RegisterNetEvent("wrenchbets:UpdateBetc", function(prizepoolu, isbetopenu)
    prizepool = prizepoolu
    isbetopen = isbetopenu
end)