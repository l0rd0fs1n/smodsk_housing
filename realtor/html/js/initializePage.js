

function InitializePage() {
    var wrapper = document.getElementById("wrapper")
    wrapper.innerHTML = `
        <div id="close" onClick="Post({}, 'close')">
            <i class="fas fa-times"></i>
        </div>

        <div id="refresh" onClick="Post({}, 'refresh')">
            <i class="fas fa-arrows-rotate"></i>
        </div>


        <div id="buttons-container"></div>
        
        <div id="pages-container">
            <div id="frontPage">
                <h1>Welcome to Your Dream Apartment</h1>
                <p>Find the perfect space to call home.</p>
                <div class="image-container">
                    <img src="images/houses.jpg">
                </div>
            </div>

            <div id="basicApartments">
                <div id="basic-container">
                    <div id="basic-content"></div>
                </div>
            </div>

            <div id="propertiesPage">
                <div id="grid-container"></div>
                <div id="pagination-container"></div>
            </div>

            <div id="offersPage">
                <div id="offers-container">
                    <div id="offers-content"></div>
                </div>
            </div>
        </div>
       

       
        
        <div id="popups">
            <div id="image-popup">
                <img id="large-image" src="" alt="Large Image">
                <button id="remove-image-btn">${GetLocale("REMOVE_IMAGE")}</button>
            </div>

            <div id="popup">
                <div id="popup-content">
                    <div id="popup-body">
                    </div>
                </div>
            </div>

            <div id="price-change-popup" class="edit-popup">
                <div class="popup-content">
                    <h3>${GetLocale("CHANGE_PRICE")}</h3>
                    <input type="number" id="new-price-input" placeholder="${GetLocale("ENTER_PRICE")}" min="1" />
                    <div class="popup-buttons">
                        <button id="save-price-btn">${GetLocale("OK")}</button>
                        <button id="cancel-price-btn">${GetLocale("CANCEL")}</button>
                    </div>
                </div>
            </div>

            <div id="add-image-popup" class="edit-popup">
                <div class="popup-content">
                    <p>${GetLocale("IMAGE_URL")}</p>
                    <input type="text" id="new-image-url" placeholder="${GetLocale("ENTER_URL")}">
                    <div class="popup-buttons">
                        <button id="save-image">${GetLocale("ACCEPT")}</button>
                        <button id="cancel-image">${GetLocale("CANCEL")}</button>
                    </div>
                </div>
            </div>

            <div id="create-offer-popup" class="edit-popup">
                <div class="popup-content">
                    <h3 id="offer-info"></h3>
                    <h4>${GetLocale("OFFER_INFO")}</h4>
                    <input type="number" id="offer-price" placeholder="${GetLocale("ENTER_OFFER")}" min="1" />
                    <input type="text" id="offer-phone" placeholder="${GetLocale("ENTER_PHONE_NUMBER")}" min="1" />
                    <div class="popup-buttons">
                        <button id="send-offer-btn">${GetLocale("SEND_OFFER")}</button>
                        <button id="cancel-offer-btn">${GetLocale("CANCEL")}</button>
                    </div>
                </div>
            </div>
        </div>
    `

    document.getElementById("large-image").onclick = function (event) {
        let imageViewer = document.getElementById("image-popup");
        if (event.target === this) {
            imageViewer.style.display = "none";
        }
    };
    
    document.getElementById("price-change-popup").onclick = function (event) {
        if (event.target === this) {
            this.style.display = "none";
        }
    };
}