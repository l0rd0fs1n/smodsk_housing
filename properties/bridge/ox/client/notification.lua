function Bridge.ox.Notification(message, duration, success)
    lib.notify({
        description = message,
        type =  success and 'success' or 'error',
        duration = duration or 5000,
        position = 'center-right'
    })
end