function buyApartment(id, shellIndex) {
    Post({ id: id, index: shellIndex  +1}, "BuyApartment");
}

function setWayPointApartment(id) {
    Post({ id: id }, "SetWayPointApartment");
}

function BasicApartments(basicApartments) {
    let container = document.getElementById("basic-content");
    container.innerHTML = ""; // Clear previous content

    basicApartments.forEach(apartment => {
        let apartmentElement = document.createElement("div");

        let header = document.createElement("h3");
        header.textContent = `${apartment.location} ${apartment.street}`;
        apartmentElement.appendChild(header);

        let basicBox = document.createElement("div");
        basicBox.classList.add("basic-box");

        apartment.shells.forEach((shell, shellIndex) => {
            let block = document.createElement("div");
            block.classList.add("basic-block");

            let details = document.createElement("p");
            details.innerHTML = `
                <img src="images/apartment_placeholder.jpg">
                <strong>${GetLocale("NAME")}:</strong> ${shell.data.name}<br>
                <strong>${GetLocale("PRICE")}:</strong> ${shell.price}<br>
            `;
            block.appendChild(details);

            let buyButton = document.createElement("button");
            buyButton.classList.add("decline-btn");
            buyButton.textContent = GetLocale("BUY");
            buyButton.addEventListener("click", () => buyApartment(apartment.id, shellIndex));

            let gpsButton = document.createElement("button");
            gpsButton.classList.add("decline-btn");
            gpsButton.textContent = GetLocale("GPS");
            gpsButton.addEventListener("click", () => setWayPointApartment(apartment.id));

            block.appendChild(buyButton);
            block.appendChild(gpsButton);
            basicBox.appendChild(block);
        });

        apartmentElement.appendChild(basicBox);
        container.appendChild(apartmentElement);
    });
}
