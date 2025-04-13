script_name('admchecker')
script_author('Hakaru Hashimoto')
script_description('Check online admins from list')

require "lib.moonloader"

local adminListFile = "adminlist.txt"
local admins = {}

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    loadAdminList()
    sampRegisterChatCommand("alo", showOnlineAdmins)

    sampAddChatMessage("[ADMCheck] AdminChecker успішно завантажено. Список адмінів онлайн: {2E8B57}/alo", -1)
    wait(-1)
end

function loadAdminList()
    admins = {}
    local file = io.open(getWorkingDirectory() .. "\\" .. adminListFile, "r")
    if file then
        for line in file:lines() do
            table.insert(admins, line:match("^%s*(.-)%s*$"))
        end
        file:close()
    else
        sampAddChatMessage("[ADMCheck] Файл adminlist.txt не знайдено!", 0xFF0000)
    end
end

function showOnlineAdmins()
    local onlineAdmins = {}
    for i = 0, 999 do
        if sampIsPlayerConnected(i) then
            local nick = sampGetPlayerNickname(i)
            for _, adminNick in ipairs(admins) do
                if nick == adminNick then
                    local id = i
                    table.insert(onlineAdmins, {nick = nick, id = id})
                end
            end
        end
    end

    if #onlineAdmins > 0 then
        sampAddChatMessage("[ADMCheck] Адміністратори онлайн: ", 0xFFD700)
        for _, admin in ipairs(onlineAdmins) do
            local message = string.format(" - %s {66CC66}id %d", admin.nick, admin.id)
            sampAddChatMessage(message, 0xFFFFFF)
        end
    else
        sampAddChatMessage("[ADMCheck] Адміністрація {32CD32}відсутня{FFFFFF}. {32CD32}Можна веселитись!", -1)
    end
end
