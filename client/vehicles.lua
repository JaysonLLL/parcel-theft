-- 检查玩家是否靠近车辆后备箱
function IsPlayerNearTrunk(vehicle)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local trunkCoords = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'boot'))

    local distance = #(playerCoords - trunkCoords)
    return distance < 2.0  -- 检测距离为2米内
end

-- 在车辆后备箱放入包裹
function StoreParcelInVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 71)  -- 获取距离玩家最近的车辆

    if vehicle then
        -- 检查玩家是否在车辆的后备箱附近
        if IsPlayerNearTrunk(vehicle) then
            -- 打开后备箱（可选，参考 qb-inventory）
            SetVehicleDoorOpen(vehicle, 5, false, false)

            -- 添加包裹到后备箱
            TriggerServerEvent('qb-inventory:server:AddItemToTrunk', 'parcel', 1, vehicle)
            TriggerEvent('QBCore:Notify', "包裹已放入后备箱")
        else
            TriggerEvent('QBCore:Notify', "你需要靠近后备箱", "error")
        end
    else
        TriggerEvent('QBCore:Notify', "附近没有车辆", "error")
    end
end

-- 从后备箱取出包裹
function TakeParcelFromTrunk()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 71)  -- 获取最近的车辆

    if vehicle then
        -- 检查玩家是否在车辆的后备箱附近
        if IsPlayerNearTrunk(vehicle) then
            -- 检查后备箱是否处于打开状态
            if GetVehicleDoorAngleRatio(vehicle, 5) > 0.1 then
                -- 检查后备箱是否有包裹物品
                local hasParcel = exports['qb-inventory']:HasItemInTrunk(vehicle, 'parcel')
                if hasParcel then
                    -- 取出包裹并给玩家设定动画
                    TriggerServerEvent('qb-inventory:server:RemoveItemFromTrunk', 'parcel', 1, vehicle)
                    PickupParcel(nil)  -- 执行取包裹动画
                    TriggerEvent('QBCore:Notify', "包裹已取出")
                else
                    TriggerEvent('QBCore:Notify', "后备箱中没有包裹", "error")
                end
            else
                TriggerEvent('QBCore:Notify', "后备箱需要打开", "error")
            end
        else
            TriggerEvent('QBCore:Notify', "你需要靠近后备箱", "error")
        end
    else
        TriggerEvent('QBCore:Notify', "附近没有车辆", "error")
    end
end

-- qb-target 后备箱交互
exports['qb-target']:AddTargetBone("boot", {
    options = {
        {
            label = "放入包裹",
            action = function()
                StoreParcelInVehicle()
            end
        },
        {
            label = "取出包裹",
            action = function()
                TakeParcelFromTrunk()
            end
        },
    },
    distance = 2.0
})
