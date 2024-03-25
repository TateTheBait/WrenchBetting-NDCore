local isbetopen = false
local prizepool = 0
local players = {}
local betholder = -1




local function endbet()
    isbetopen = false
    prizepool = 0
    players = {}
    betholder = -1
    TriggerEvent("wrenchbets:UpdateBets")
end


RegisterNetEvent("wrenchbets:openbet", function(clientid)
    if isbetopen == false then
        isbetopen = true
        prizepool = 0
        players = {clientid}
        local player = NDCore.getPlayer(clientid)
        betholder = clientid
        TriggerClientEvent('ox_lib:notify', -1, {
            title = "Bets",
            description = "A bet has been opened by " .. player.firstname .. " | Use command /bet to put money into the event!",
            type = "Success",
            duration = 10000
        })
        TriggerEvent("wrenchbets:UpdateBets")
    else
        TriggerClientEvent('ox_lib:notify', clientid, {
            title = "Bets",
            description = "Failed to open bet, a bet is already started!"
        })
    end
end)

RegisterNetEvent("wrenchbets:addbet", function(clientid, amount)
    local playerinlist = false
    if isbetopen == true then
        isbetopen = true
        local player = NDCore.getPlayer(clientid)
        player.deductMoney("bank", amount, "Prize Pool")
        prizepool += amount
        for _, player in pairs(players) do
            if clientid == player then playerinlist = true end
        end
        if playerinlist == false then
            players[#players+1] = clientid
        end
        TriggerEvent("wrenchbets:UpdateBets")
        for _, player in pairs(players) do
            TriggerClientEvent('ox_lib:notify', -1, {
                title = "Bets",
                description = "The Prize Pool was added too, it is now $" .. prizepool
            })
        end
    end
end)


RegisterNetEvent("wrenchbets:UpdateBets", function(clientid)
    if clientid then
        TriggerClientEvent("wrenchbets:UpdateBetc", clientid, prizepool, isbetopen)
    else
        TriggerClientEvent("wrenchbets:UpdateBetc", -1, prizepool, isbetopen)
    end
end)


RegisterCommand("payout", function(id, args)
    print(id)
    if args[1] and betholder == id then
        local player = tonumber(args[1])
        local ndplayer = NDCore.getPlayer(player)
        ndplayer.addMoney("bank", prizepool, "Bet Winnings")
        for _, player in pairs(players) do
            TriggerClientEvent('ox_lib:notify', player, {
                title = "Bets",
                description = ndplayer.firstname .. " Has Won The Bet of... $" .. tostring(prizepool) .. "!"
            })
        end
        endbet()
    end
end, true)