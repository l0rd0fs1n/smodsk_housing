QBCore = GetResourceState('qb-core') == "started" and exports['qb-core']:GetCoreObject() or nil
QBX = GetResourceState("qbx_core") == "started" and exports['qb-core']:GetCoreObject() or nil
ESX = GetResourceState('es_extended') == "started" and exports['es_extended']:getSharedObject() or nil
ox_inventory = GetResourceState("ox_inventory") == "started" and exports["ox_inventory"] or nil
qb_inventory = GetResourceState("qb-inventory") == "started" and exports["qb-inventory"] or nil
ox_target = GetResourceState("ox_target") == "started" and exports["ox_target"] or nil
qb_target = GetResourceState("qb-target") == "started" and exports['qb-target'] or nil

Bridge = {
    ox = {},
    qb = {},
}


