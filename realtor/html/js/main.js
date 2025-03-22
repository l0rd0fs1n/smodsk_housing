const cardsPerPage = 9;
var buttonsContainer = null
var gridContainer = null
var paginationContainer = null
var popup = null
var popupContent = null
var locations = {};
let currentLocation = "";
let currentPage = 1;
let isRealtor = true
let identifier = true
let shellData = {}


function Hide() {
    document.body.style.display = "none";
}

function Show() {
    SetScale();
    document.body.style.display = "block";
}
function initializeButtons() {
    buttonsContainer = document.getElementById("buttons-container");
    gridContent = document.getElementById("grid-content");
    gridContainer = document.getElementById("grid-container");
    frontContainer = document.getElementById("front-container");
    paginationContainer = document.getElementById("pagination-container");
    popup = document.getElementById("popup");
    popupContent = document.getElementById("popup-content");
    buttonsContainer.innerHTML = "";
    paginationContainer.innerHTML = "";
    
    SelectPage("frontPage");

    if (isRealtor) {
        let btn = document.createElement("button");
        btn.textContent = GetLocale("NEW");
        btn.classList.add("button-realtor");
        btn.onclick = () => {
            Post({}, "NewProperty");
            SelectPage("propertiesPage");
        };
        buttonsContainer.appendChild(btn);

        btn = document.createElement("button");
        btn.textContent = GetLocale("UNLISTED");
        btn.onclick = () => {
            SelectPage("propertiesPage");
            currentLocation = "unlisted";
            currentPage = 1;
            createCards(currentLocation, currentPage, function(){
                createPagination(currentLocation);
            });
            createPagination(currentLocation);
        };
        buttonsContainer.appendChild(btn);
    }

    let btn = document.createElement("button");
    btn.textContent = GetLocale("MY_PROPERTIES");
    btn.onclick = () => {
        SelectPage("propertiesPage");
        currentLocation = "myProperties";
        currentPage = 1;
        createCards(currentLocation, currentPage, function(){
            createPagination(currentLocation);
        });
        createPagination(currentLocation);
    };
    buttonsContainer.appendChild(btn);


    const offersButton = document.createElement("button");
    offersButton.textContent = GetLocale("OFFERS")
    offersButton.onclick = () => {
        OffersPopup()
    }
    buttonsContainer.appendChild(offersButton);


    const basicApartmentsButton = document.createElement("button");
    basicApartmentsButton.textContent = GetLocale("APARTMENTS")
    basicApartmentsButton.onclick = () => {
        SelectPage("basicApartments")
    }
    buttonsContainer.appendChild(basicApartmentsButton);


    basicApartments

    const dropdownButton = document.createElement("button");
    dropdownButton.classList.add("dropdown-btn");
    buttonsContainer.appendChild(dropdownButton);

    const dropdownContainer = document.createElement("div");
    dropdownContainer.classList.add("dropdown-container");
    dropdownContainer.style.display = "none";

    let locationsCount = 0

    Object.keys(locations).forEach(location => {
        const locationBtn = document.createElement("button");
        locationBtn.textContent = location;
        locationsCount += 1
        locationBtn.onclick = () => {
            SelectPage("propertiesPage");
            currentLocation = location;
            currentPage = 1;
            dropdownContainer.style.display = "none";
            createCards(currentLocation, currentPage, function(){
                createPagination(currentLocation);
            });
        };
        dropdownContainer.appendChild(locationBtn);
    });

    dropdownButton.textContent = GetLocale("SELECT_LOCATION") + " (" + locationsCount + ")";
    buttonsContainer.appendChild(dropdownContainer);

    dropdownButton.onclick = () => {
        if (locationsCount > 0) {
            dropdownContainer.style.display = (dropdownContainer.style.display === "none") ? "block" : "none";
        }
    };
}



function createCardElements(properties, page) {
    const start = (page - 1) * cardsPerPage;
    const end = Math.min(start + cardsPerPage, properties.length);

    for (let i = start; i < end; i++) {
        const item = properties[i];
        var card = `
            <div class="card" onClick="fetchAndOpen(${item.id})">
                <img src="${item.image ? item.image : (item.apartmentId ? "images/apartment_placeholder.jpg" : "images/house_placeholder.jpg")}">
                <p>${item.street}</p>
                <p>${item.price} ${GetLocale("MONEY_SYMBOL")}</p>
            </div>
        `;

        gridContainer.innerHTML += card;
    }
}

function createCards(location, page, callback) {
    gridContainer.innerHTML = '';
    const properties = locations[location];

    if (properties) {
        createCardElements(properties, page);
        callback()
    } else {
        Fetch({location : location}, "GetPropertiesByLocation", function(data) {
            locations[location] = data
            createCardElements(data, page)
            callback()
        })
    }
}


window.addEventListener('message', function(event) {
    if (event.data.action === "open") {

        locations = {}

        event.data.locations.forEach(element => {
            locations[element] = false
        });

        isRealtor = event.data.isRealtor
        identifier = event.data.identifier
        propertyDetails = event.data.propertyData

        if (event.data.shellData) {
            buildShellData(event.data.shellData)
        }

        initializeButtons();
        Show();
    } else if (event.data.action === "close") {
        Hide()
    } else if (event.data.action === "init") {
        
        SetLocales(event.data.localization)
        InitializePage()
        BasicApartments(event.data.basicApartments)
    } else if (event.data.action == "setPropertyDetails") {
        PropertyDetails.SetData(event.data.data)

        if (event.data.popUp) {
            openPopup();
            Show();
        }
    } else if (event.data.action === "setPropertyDetailsValue") {
        PropertyDetails.Set(event.data.key, event.data.value, false)
        openPopup();
        Show();
    }
});