function getParentResourceName() {
    return GetParentResourceName()
}

function Post(data, action) {
    fetch(`https://${getParentResourceName()}/${action}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(data)
    })
    .catch((error) => {
        //console.error("Post request failed:", error);
    });
}

function Fetch(data, action, callback) {
    fetch(`https://${getParentResourceName()}/${action}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(data)
    })
    .then(resp => resp.json())
    .then(callback)
    .catch((error) => {
       //console.error("Fetch request failed:", error);
    });
}


