-- 生成物品模型的函数
local function spawnProp(prop, coords, heading)
    local propModel = GetHashKey(prop)

    -- 请求模型加载
    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Citizen.Wait(0)
    end

    -- 在指定坐标生成物品
    local propObject = CreateObject(propModel, coords.x, coords.y, coords.z, true, true, false)
    SetEntityHeading(propObject, heading)
    PlaceObjectOnGroundProperly(propObject)

    -- 保持网络同步
    NetworkRegisterEntityAsNetworked(propObject)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(propObject), true)

    return propObject
end


-- 在所有指定的坐标点生成模型
Citizen.CreateThread(function()
    for _, loc in pairs(Config.Locations) do
        if loc.debug then
            DrawMarker(2, loc.coords.x, loc.coords.y, loc.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
        end
        local prop = spawnProp(loc.prop, loc.coords, loc.heading)
        
        -- 使用 qb-target 添加互动
        exports['qb-target']:AddTargetEntity(prop, {
            options = {
                {
                    label = "打开包裹",
                    action = function()
                        OpenParcel(prop)
                    end
                },
                {
                    label = "拿起包裹",
                    action = function()
                        PickupParcel(prop)
                    end
                },
            },
            distance = loc.distance
        })
    end
end)

-- 打开包裹逻辑
function OpenParcel(prop)
    local loot = {}
    local lootAmount = Config.Loot.amount

    for i = 1, lootAmount do
        local randomItem = Config.Loot.items[math.random(#Config.Loot.items)]
        local amount = math.random(randomItem.minAmount, randomItem.maxAmount)
        table.insert(loot, { item = randomItem.item, amount = amount })
    end

    -- 给玩家添加物品
    for _, lootItem in pairs(loot) do
        TriggerServerEvent('qb-inventory:server:AddItem', lootItem.item, lootItem.amount)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[lootItem.item], "add")
    end

    -- 删除包裹模型
    DeleteEntity(prop)
end

-- 拿起包裹业务逻辑
function PickupParcel(prop)
    -- 设定抱着包裹的动画
    local playerPed = PlayerPedId()
    -- 调用该函数播放动画并生成道具
    CarryBoxAnimation()
    
    -- 删除当前的包裹模型
    DeleteEntity(prop)
end

-- 放下包裹逻辑
function PutDownParcel()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- 设置偏移量，避免与玩家重叠
    local offsetCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.5, 0.0)

    -- 生成新的包裹
    spawnProp('hei_prop_heist_box', offsetCoords, GetEntityHeading(playerPed))

    -- 取消动画
    ClearPedTasks(playerPed)
end

-- 使用携带物体的动画
function CarryBoxAnimation()
    local playerPed = PlayerPedId()
    local animDict = "anim@heists@box_carry@"
    local animName = "idle"

    -- 请求动画字典
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end

    -- 播放抱着箱子的动画
    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 50, 0, false, false, false)

    -- 给玩家添加一个物品（比如箱子）
    local propModel = "prop_cs_cardbox_01"  -- 使用的箱子模型
    local prop = CreateObject(GetHashKey(propModel), 0, 0, 0, true, true, true)
    AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, -0.05, 0.0, 0.0, 0.0, false, false, false, true, 1, true)
end