var propertyOffers = [];
var myOffers = [];

function onAcceptOffer(propertyIndex, offerIndex) {
    var offer = propertyOffers[propertyIndex].offers[offerIndex]
    Fetch({id:offer.id}, "AcceptOffer", function() {
        OffersPopup()
    })
    
}

function onDeclineOffer(propertyIndex, offerIndex) {
    var offer = propertyOffers[propertyIndex].offers[offerIndex]
    Fetch({id:offer.id}, "DeclineOffer", function() {
        OffersPopup()
    })
}

function onRemoveOffer(id) {
    Fetch({id:id}, "RemoveOffer", function() {
        OffersPopup()
    })
}


function OffersPopup() {
    let offersElement = document.getElementById("offers-content");
    offersElement.innerHTML = "";
    SelectPage("offersPage");

    Fetch({}, "GetOffers", function(offers) {
        propertyOffers = offers.offers;
        myOffers = offers.myOffers;

        if (myOffers.length > 0) {
            offersElement.innerHTML += `
            <h3>${GetLocale("MY_OFFERS")}</h3>
            <div class="offer-box">
                ${myOffers.map((v, index) => {
                    return `
                        <div class="offer-block">
                            <p>
                                <strong>${GetLocale("LOCATION")}:</strong> ${v.location}<br>
                                <strong>${GetLocale("STREET")}:</strong> ${v.street}<br>
                                <strong>${GetLocale("PRICE")}:</strong> ${v.askingPrice}<br>
                                <strong>${GetLocale("OFFER")}:</strong> ${v.price}<br>
                            </p>
                            <button class="decline-btn" onclick="onRemoveOffer(${v.id})">${GetLocale("REMOVE")}</button>
                        </div>
                    `;
                }).join('')}
            </div>
        `;
        }
    
        Object.entries(propertyOffers).forEach(([propertyId, offerInfo]) => {
            offersElement.innerHTML += `
                <h3>${offerInfo.location} - ${offerInfo.street} (${offerInfo.price} ${GetLocale("MONEY_SYMBOL")})</h3>
                <div class="offer-box">
                    ${offerInfo.offers.map((v, index) => `
                        <div class="offer-block">
                            <p>
                                <strong>${GetLocale("OFFER")}:</strong> ${v.price} ${GetLocale("MONEY_SYMBOL")}<br>
                                <strong>${GetLocale("NAME")}:</strong> ${v.name}<br>
                                <strong>${GetLocale("PHONE")}:</strong> ${v.phone}<br>
                            </p>
                            <button class="accept-btn" onclick="onAcceptOffer(${propertyId}, ${index})">${GetLocale("ACCEPT")}</button>
                            <button class="decline-btn" onclick="onDeclineOffer(${propertyId}, ${index})">${GetLocale("DECLINE")}</button>
                        </div>
                    `).join('')}
                </div>`;
        });
    });

    offersElement.style.display = "block";
}

