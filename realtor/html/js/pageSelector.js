var pages = ["frontPage", "propertiesPage", "offersPage", "basicApartments"];

function SelectPage(page) {
    for (var i = 0; i < pages.length; i++) {
        document.getElementById(pages[i]).style.display = "none";
    }
    document.getElementById(page).style.display = "block";
}
