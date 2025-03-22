-----------------------------------------
--- These trigger only for client doing stuff
-----------------------------------------
function TryBreakIn(callback)
    callback(Bridge.Progressbar({
        duration = 10000,
        label = GetLocale("BREAKING_IN"),
        anim = {
            dict = 'mp_arresting',
            clip = 'a_uncuff'
        }
    }))
end


-- Triggers when player at door and rings bell
function RingDoorbell(callback)
    callback(Bridge.Progressbar({
        duration = 1000,
        --label = GetLocale("BREAKING_IN"),
        anim = {
            dict = 'mp_arresting',
            clip = 'a_uncuff'
        }
    }))
end

-- Triggers when player locks/unlocks door at exterior door
function DoorLock(callback)
    -- TODO Add animation
    callback(Bridge.Progressbar({
        duration = 3000,
       -- lablel = GetLocale("BREAKING_IN"),
        anim = {
            dict = 'mp_arresting',
            clip = 'a_uncuff'
        }
    }))
end



-- Everyone inside apartment see this
function DoorbellRings()
    Bridge.Notification(GetLocale("DOORBELL"), 6000, true)
end

-- Everyone close to position see this
function DoorLockStateChanged(position)
    if #(vec3(position.x, position.y, position.z) - PlayerData.Position()) < 5.0 then
        Bridge.Notification(GetLocale("DOORLOCK"), 6000, true)
    end
end