function Bridge.qb.Notification(message, duration, success)
    QBCore.Functions.Notify(
        message, 
        success and 'success' or 'error',
        duration or 5000)
end
