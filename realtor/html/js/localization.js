let Localization = {}

function SetLocales(localization) {
    Localization = localization
}


function GetLocale(locale) {
    if (Localization.languages[Localization.language] && Localization.languages[Localization.language][locale]) {
        return Localization.languages[Localization.language][locale]
    }

    Post({locale:locale}, "AddMissingLocale");
    return locale
}