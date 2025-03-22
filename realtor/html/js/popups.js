function MakeOfferPopup() {
    let offerPopup = document.getElementById("create-offer-popup");
    let sendOfferBtn = document.getElementById("send-offer-btn");
    let cancelOfferBtn = document.getElementById("cancel-offer-btn"); 
    let offerInfo = document.getElementById("offer-info"); 

    let price = document.getElementById("offer-price");
    price.value = PropertyDetails.Get("price");
    let phone = document.getElementById("offer-phone"); 

    offerInfo.innerHTML = `${GetLocale("ASKING_PRICE") + " " + PropertyDetails.Get("price") + " " + GetLocale("MONEY_SYMBOL")}`
    offerPopup.style.display = "block";


    sendOfferBtn.onclick = () => {
        Post({
            propertyId: PropertyDetails.Get("id"), 
            price: price.value, 
            phone: phone.value
        }, "CreateOffer")
        
        offerPopup.style.display = "none";
    };

    cancelOfferBtn.onclick = () => {
        offerPopup.style.display = "none";
    };

}

function ChangePricePopup() {
    let priceChangePopup = document.getElementById("price-change-popup");
    let newPriceInput = document.getElementById("new-price-input");
    let savePriceButton = document.getElementById("save-price-btn");
    let cancelPriceButton = document.getElementById("cancel-price-btn");

    priceChangePopup.style.display = "block";
    newPriceInput.value = PropertyDetails.Get("price");

    savePriceButton.onclick = () => {
        let newPrice = parseInt(newPriceInput.value);
        if (newPrice && newPrice > 0) {
            PropertyDetails.Set("price", newPrice, true)
            openPopup();
        }
        priceChangePopup.style.display = "none";
    };

    cancelPriceButton.onclick = () => {
        priceChangePopup.style.display = "none";
    };
}


function ShowImagePopup(imageUrl, index) {
    let imageViewer = document.getElementById("image-popup");
    let largeImage = document.getElementById("large-image");
    let removeButton = document.getElementById("remove-image-btn");

    largeImage.src = imageUrl;
    imageViewer.style.display = "flex";


    if (removeButton) {
        removeButton.style.display = (isRealtor || isOwner()) ? "block" : "none";

        if (isRealtor || isOwner()) {
            removeButton.onclick = () => {
                const images = PropertyDetails.Get("images")
                images.splice(index, 1);
                PropertyDetails.Set("images", images, true)
                imageViewer.style.display = "none";
                openPopup();
            };
        }  
    }
}
