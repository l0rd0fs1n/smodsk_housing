Localization = {
    language = "EN",
    languages = {}
}


local missingLocales = {}

function GetLocale(locale)
    if Localization.languages[Localization.language] and Localization.languages[Localization.language][locale] then
        return Localization.languages[Localization.language][locale]
    else
        missingLocales[locale] = true
        return locale
    end
end


function AddMissingLocale(locale)
    missingLocales[locale] = true
end

function PrintMissingLocales()
    for k, v in pairs(missingLocales) do
        print(string.format('["%s"] = ""', k))
    end
end
