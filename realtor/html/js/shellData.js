function buildShellData(data) {
    shellData.apartment = []
    shellData.garage = []

    for (var i=0; i < data.shell.apartment.length; i++)
    {
        shellData.apartment.push({
            name : data.shell.apartment[i].name,
            key :  data.shell.apartment[i].key,
            shellType : data.shell.apartment[i].shellType,
            type : "shell"
        })
    }

    for (var i=0; i < data.shell.garage.length; i++)
    {
        shellData.garage.push({
            name : data.shell.garage[i].name,
            key :  data.shell.garage[i].key,
            shellType : data.shell.garage[i].shellType,
            type : "shell"
        })
    }

    if (data.smShell)
    {
        for (var i=0; i < data.smShell.length; i++)
            {
                var newData = {
                    name : data.smShell[i].name,
                    key :  data.smShell[i].key,
                    type : "smShell"
                }
        
                shellData.apartment.push(newData)
                shellData.garage.push(newData)
            }
    }
    
    if (data.smShellTemplate)
    {
        for (var i=0; i < data.smShellTemplate.length; i++)
        {
            var newData = {
                name : data.smShellTemplate[i].name,
                key :  data.smShellTemplate[i].key,
                type : "smShellTemplate"
            }
    
            shellData.apartment.push(newData)
            shellData.garage.push(newData)
        }
    }
}