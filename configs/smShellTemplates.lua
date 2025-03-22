-- ShellBuilder templates, where the key represents the grid size.
-- {7,1} = 7x7x1 grid.
SMShellTemplates = 
    GetResourceState("smodsk_shellBuilder") == "started" and {
        {name = "Grid 7x1",    key = {7, 1}},
        {name = "Grid 7x2",    key = {7, 2}},
        {name = "Grid 7x3",    key = {7, 3}},
        {name = "Grid 9x1",    key = {9, 1}},
        {name = "Grid 9x2",    key = {9, 2}},
        {name = "Grid 12x1",   key = {12, 1}},
    }
or nil