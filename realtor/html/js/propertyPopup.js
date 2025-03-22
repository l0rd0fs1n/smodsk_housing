function fetchAndOpen(propertyId) {
    Fetch({id : propertyId}, "GetPropertyData", function(propertyDetails) {
        PropertyDetails.SetData(propertyDetails)
        openPopup();
    })
}

function isOwner() {
    return PropertyDetails.Get("owner") == identifier
}
function setDescription(event) { PropertyDetails.Set("description", event.target.value, true) }
function setExterior() { Post({}, "SetExterior"); Hide(); }
function setDoor() { Post({}, "SetDoor"); Hide(); }
function setGarage() { Post({}, "SetGarage"); Hide(); }
function saveData() { Post({}, "SaveData"); document.getElementById("popup").style.display = "none";}
function toggleListing() {PropertyDetails.Set("status", PropertyDetails.Get("status") == 0 ? 1 : 0, true), openPopup()}
function setWayPointProperty() {
    var id = PropertyDetails.Get("id")
    if (id) {
        Post({id:id}, "SetWayPointProperty")
    }
}
function onGarageSelect(select) {
    PropertyDetails.Set("garageData", shellData.garage[select.value], true)
}
function onApartmentSelect(select) {
    PropertyDetails.Set("apartmentData", shellData.apartment[select.value], true)
}

function openPopup() {
    let popupBody = document.getElementById("popup-body");
    let priceContent = isRealtor || isOwner() ? 
        `<button id="change-price-btn" class="button-realtor">${PropertyDetails.Get("price")} ${GetLocale("MONEY_SYMBOL")}</button>` : 
        `<h3>${PropertyDetails.Get("price")} ${GetLocale("MONEY_SYMBOL")}</h3>`;


        popupBody.innerHTML = `
        <h2>${PropertyDetails.Get("location")}</h2>
        <h3>${PropertyDetails.Get("street")}</h3>
        <div class="shell-data">
            <div> 
                <div> ${GetLocale("APARTMENT")} </div>
                ${(isRealtor && !PropertyDetails.Get("apartmentId")) 
                    ? `<select id="apartment-dropdown"  onchange="onApartmentSelect(this)">
                            <option value="" disabled selected>  ${PropertyDetails.Get("apartmentData")?.name || GetLocale("SELECT_SHELL")} </option>
                            ${shellData.apartment.map((v, index) => `<option class="option-${v.type}" value="${index}">${v.name}</option>`).join("")}
                    </select>`
                    : `<strong> ${PropertyDetails.Get("apartmentData")?.name} </strong>`
                } 
            </div> 
            <div> 
                <div> ${GetLocale("GARAGE")} </div>
                ${(isRealtor && !PropertyDetails.Get("apartmentId")) 
                    ? `<select id="garage-dropdown" onchange="onGarageSelect(this)">
                            <option value="" disabled selected> ${PropertyDetails.Get("garageData")?.name || GetLocale("SELECT_SHELL")}</option>
                            ${shellData.garage.map((v, index) => `<option class="option-${v.type}" value="${index}">${v.name}</option>`).join("")}
                    </select>`
                    : `<strong> ${PropertyDetails.Get("garageData")?.name || GetLocale("NO_GARAGE")} </strong>`
                } 
            </div>
        </div>
        <p>${priceContent}</p>
        <div class="description-container">
            ${isRealtor || isOwner()
                ? `<textarea id="property-description" onfocusout="setDescription(event)" maxlength="200">${PropertyDetails.Get("description") || ""}</textarea>` 
                : `<p>${PropertyDetails.Get("description") || "No description available."}</p>`}
        </div>
        <div>
            <div class="image-grid">
                ${PropertyDetails.Get("images").map((img, index) => `
                    <div class="image-container">
                        <img src="${img}"
                            onclick="ShowImagePopup('${img}', ${index})">
                    </div>
                `).join('')}
            </div>
            <div class="popup-buttons">
                    ${isRealtor || isOwner() ?
                        `
                            <button 
                                id="add-image"
                                class="button-realtor"
                            > 
                                ${GetLocale("ADD_IMAGE")}
                            </button>
                        ` : ""}
                    ${isRealtor || isOwner() ? `
                        <button 
                            id="toggle-listing-popup" 
                            class="button-realtor"
                            onclick="toggleListing()"
                        > 
                            ${PropertyDetails.Get("status") == 1 ? GetLocale("UNLIST") : GetLocale("LIST")}
                        </button>
                    ` : ""}

                    ${(isRealtor && !PropertyDetails.Get("apartmentId")) ? `
                        <button 
                            id="set-exterior-popup" 
                            class="button-realtor"
                            onclick="setExterior()"
                        >
                            ${GetLocale("SET_EXTERIOR")} ${(!PropertyDetails.Get("exterior")) ? "❌" : "✅" }
                        </button>
                    ` : ""}

                    ${(isRealtor && !PropertyDetails.Get("apartmentId")) ? `
                        <button 
                            id="set-door-popup" 
                            class="button-realtor"
                            onclick="setDoor()"
                        >
                            ${GetLocale("SET_DOOR")} ${(!PropertyDetails.Get("door")) ? "❌" : "✅" }
                        </button>
                    ` : ""}
                    ${(isRealtor && !PropertyDetails.Get("apartmentId")) ? `
                        <button 
                            id="set-garage-popup" 
                            class="button-realtor"
                            onclick="setGarage()"
                        >
                            ${GetLocale("SET_GARAGE")} ${(!PropertyDetails.Get("garageDoor")) ? "❌" : "✅" }
                        </button>
                    ` : ""}
                    ${isRealtor || isOwner() ?`
                        <button 
                            id="save-popup" 
                            class="button-realtor"
                            onclick="saveData()"
                        >
                            ${GetLocale("SAVE")}
                        </button>
                    `: ""}

                    ${!isRealtor && !isOwner() ? `
                        <button 
                            id="buy-popup"
                            onclick="MakeOfferPopup()"
                        > 
                            ${GetLocale("MAKE_OFFER")} 
                        </button>
                    ` : ""}
                

                    <button 
                        id="gps-popup" 
                        class="popup-btn"
                        onclick="setWayPointProperty()"
                    >
                        ${GetLocale("GPS")}
                    </button>
                    
                    <button 
                        id="close-popup" 
                        class="popup-btn"
                    >
                        ${GetLocale("CLOSE")}
                    </button>

            </div>
        </div>
    `;



    


    document.getElementById("popup").style.display = "flex";
    document.getElementById("close-popup").onclick = () => {
        document.getElementById("popup").style.display = "none";
    };


    if (isRealtor || isOwner()) {

        const changePriceButton = document.getElementById("change-price-btn");
        if (changePriceButton) {
            changePriceButton.onclick = () => {
                ChangePricePopup();
            };
        }

        const addImageButton = document.getElementById("add-image");
        const imagePopup = document.getElementById("add-image-popup");
        const saveImageButton = document.getElementById("save-image");
        const cancelImageButton = document.getElementById("cancel-image");
        
        addImageButton.onclick = () => {
            const images = PropertyDetails.Get("images")
            if (!images || images.length  < 3)
            {
                imagePopup.style.display = "block";
            }

        };

        saveImageButton.onclick = () => {
            const imageUrl = document.getElementById("new-image-url").value;
            if (imageUrl) {
                const images = PropertyDetails.Get("images")
                images.push(imageUrl);
                PropertyDetails.Set("images", images, true)
                openPopup();
            }
            imagePopup.style.display = "none";
        };

        cancelImageButton.onclick = () => {
            imagePopup.style.display = "none";
        };
    }
}



