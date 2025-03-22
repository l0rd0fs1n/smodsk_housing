function Bridge.ox.ConfirmDialog(text)
    return lib.alertDialog({
        header = "",
        content = text,
        cancel = true,
        centered = true
    }) == "confirm"
end