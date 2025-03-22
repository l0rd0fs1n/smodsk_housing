if not IsDuplicityVersion() then
    -- CLIENT --
    -- Returns the front door of the last property if the player was inside an apartment or garage when they exited.
    exports("GetLastPosition", PlayerData.GetLastPosition)

else
    -- SERVER --
    -- TODO: Retrieve property details based on the player's identifier?
    -- TODO: Retrieve coordinates based on address
end
