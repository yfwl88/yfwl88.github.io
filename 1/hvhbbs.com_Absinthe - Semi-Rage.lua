--汉化by李清照QQ2571781314
--aimware交流群262244016
--欢迎您访问 “ 贞德游戏交流论坛 ” 地址：https://hvhbbs.com/
--论坛拥有HVH圈内大量免费OTCV3DLL等丨注入器丨教程翻译丨免费泄露参数丨免费破解私人脚本丨更新迅速及时丨



--[[
    ABSINTHE.LUA BY OLEXON (https://aimware.net/forum/user/346412)
]]--

local lua_ver = "1.3"
local tab = gui.Tab(gui.Reference("RAGEBOT"), "ABSINTHE_TAB", "ABSINTHE V" .. lua_ver)
local semi_group = gui.Groupbox(tab, "红演", 15, 15, 200, 500)
local aa_group = gui.Groupbox(tab, "反自瞄", 230, 15, 200, 500)
local misc_group = gui.Groupbox(tab, "杂项", 445, 15, 180, 500)
local lby_group = gui.Groupbox(tab, "LBY (实验性)", 15, 445, 200, 500)

local screen_x, screen_y = draw.GetScreenSize()

local weapon_categories = { --for awall toggle
    [1] = "shared",
    [2] = "zeus",
    [3] = "pistol",
    [4] = "hpistol",
    [5] = "smg",
    [6] = "rifle",
    [7] = "shotgun",
    [8] = "scout",
    [9] = "asniper",
    [10] = "sniper",
    [11] = "lmg",
}

local function get_velocity() --thanks m0nsterJ
    local local_player = entities.GetLocalPlayer()

    vel_x, vel_y = local_player:GetPropFloat("localdata", "m_vecVelocity[0]"), local_player:GetPropFloat("localdata", "m_vecVelocity[1]")
    return math.sqrt(vel_y ^ 2 + vel_x ^ 2)
end

local function get_base_yaw()
    local str_table = {}
    for str in string.gmatch(gui.GetValue("rbot.antiaim.base"), "([^".."%s".."]+)") do 
        table.insert(str_table, str)
    end

    local base_yaw = str_table[1]:gsub("\"", "")
    return tonumber(base_yaw)
end

local function get_percentage(val, max)
    return math.floor(val / max * 100)
end

-- SWITCHES ETC ETC --

-- SEMI --
local dynamicfov_sw = gui.Checkbox(semi_group, "ABSINTHE_DYNAMICFOV", "动态Fov", false); dynamicfov_sw:SetDescription("过高的Fov会导致账号封禁 ")
local dynamicfov_min = gui.Slider(semi_group, "ABSINTHE_DYNAMICFOVMIN", "动态Fov最小", 1, 1, 180)
local dynamicfov_max = gui.Slider(semi_group, "ABSINTHE_DYNAMICFOVMAX", "动态Fov最大", 1, 1, 180)

local awol_sw = gui.Checkbox(semi_group, "ABSINTHE_AUTOWALL", "穿墙", false)

local fl_randomizer_sw = gui.Checkbox(semi_group, "ABSINTHE_FL_RANDOMIZER", "随机假卡", false)
local fl_randomizer_min = gui.Slider(semi_group, "ABSINTHE_FL_RANDOMIZER_MIN", "假卡最小值", 3, 3, 8)
local fl_randomizer_max = gui.Slider(semi_group, "ABSINTHE_FL_RANDOMIZER_MAX", "假卡最大值", 3, 3, 8)

local ragetoggle_sw = gui.Checkbox(semi_group, "ABSINTHE_RAGETOGGLE", "按键低头", false); ragetoggle_sw:SetDescription("不安全")

-- AA --
local fs_sw = gui.Checkbox(aa_group, "ABSINTHE_FREESTANDING", "自动藏头", false); fs_sw:SetDescription("不安全 改为Peek按键")

local desync_left = gui.Slider(aa_group, "ABSINTHE_DESYNC_LEFT", "假身 [左]", 0, 0, 58, 2)
local desync_right = gui.Slider(aa_group, "ABSINTHE_DESYNC_right", "假身 [右]", 0, 0, 58, 2)
local roll_slider = gui.Slider(aa_group, "ABSINTHE_ROLL", "ROLL大角度", 0, 0, 90, 1); roll_slider:SetDescription("非常不安全 尤其是45°以上")
local roll_combo = gui.Combobox(aa_group, "ABSINTHE_ROLL_MODE", "ROLL抖动模式", "高", "低", "抖动", "同步假身")

local inverter_kb = gui.Keybox(aa_group, "ABSINTHE_INVERTER_KEY", "反转", 0)


gui.Text(aa_group, " ------- 慢走 ------ ")

local slowwalking_desync_mods = gui.Combobox(aa_group, "ABSINTHE_SLOWWALKING_DESYNC_MODS", "假身模式", "静态", "抖动", "抖动切换", "3角度抖动")

gui.Text(aa_group, " --------- 站立 --------- ")

local standing_desync_mods = gui.Combobox(aa_group, "ABSINTHE_STANDING_DESYNC_MODS", "假身模式", "静态", "抖动", "抖动切换", "3角度抖动")

gui.Text(aa_group, " ---------- 移动 ---------- ")

local moving_desync_mods = gui.Combobox(aa_group, "ABSINTHE_MOVING_DESYNC_MODS", "假身模式", "静态", "抖动", "抖动切换", "3角度抖动")

-- MISC/VIS --
local watermark_sw = gui.Checkbox(misc_group, "ABSINTHE_水印", "水印", true)
local watermark_col = gui.ColorPicker(watermark_sw, "ABSINTHE_WATERMARK_COLOR", "", 75, 230, 145, 200)

local aa_arrows_sw = gui.Checkbox(misc_group, "ABSINTHE_AAARROWS", "真身指示器", false)
local aa_arrows_col = gui.ColorPicker(aa_arrows_sw, "ABSINTHE_AAARROWS_COLOR", "", 75, 230, 145, 200)

local undercross_indicators_sw = gui.Checkbox(misc_group, "ABSINTHE_UNDERCROSS_INDICATORS", "准星下指示器", false)
local undercross_indicators_color = gui.ColorPicker(undercross_indicators_sw, "ABSINTHE_UNDERCROSS_COLOR", "", 75, 230, 145, 200)

local killsay_sw = gui.Checkbox(misc_group, "ABSINTHE_KILLSAY", "击杀喊话", false)
local viewmodel_sw = gui.Checkbox(misc_group, "ABSINTHE_OVERRIDE_VIEWMODEL", "覆盖手臂位置", false)

local viewmodel_x_slider = gui.Slider(misc_group, "ABSINTHE_OVERRIDE_VIEWMODEL_X", "手臂 X", 0, -20, 20, 0.1)
local viewmodel_y_slider = gui.Slider(misc_group, "ABSINTHE_OVERRIDE_VIEWMODEL_Y", "手臂 Y", 0, -20, 20, 0.1)
local viewmodel_z_slider = gui.Slider(misc_group, "ABSINTHE_OVERRIDE_VIEWMODEL_Z", "手臂 Z", 0, -20, 20, 0.1)

local aspect_sw = gui.Checkbox(misc_group, "ABSINTHE_ASPECTRATIO", "屏幕拉伸", false)
local aspect_slider = gui.Slider(misc_group, "ABSINTHE_ASPECTRATIO_VALUE", "屏幕拉伸数值", 0, 0, 10, 0.1)

local xy_reset = gui.Button(misc_group, "X/Y RESET", function() --isabel v2
    screen_x, screen_y = draw.GetScreenSize()
end); xy_reset:SetWidth(148)

-- LBY --
local lby_sw = gui.Checkbox(lby_group, "ABSINTHE_LBY", "LBY", false); lby_sw:SetDescription("不安全")
local lby_offset_slider = gui.Slider(lby_group, "ABSINTHE_LBY_OFFSET", "LBY偏移", 0, 0, 179)

-- VISUAL STUFF --

--[[local function sineout(time, start, add, dur)
    return add * math.sin(time/dur * (math.pi/2)) + start
end
]]

local font_main = draw.CreateFont("Verdana", 13, 25)
local font_watermark = draw.CreateFont("Verdana", 13, 1200)
local font_undecross = draw.CreateFont("Verdana", 15, 800)
local font_undecross_items = draw.CreateFont("Verdana", 12, 800)

local function watermark()
    local wm_text = "Absinthe | Ver: " .. lua_ver .. " | User: " .. cheat.GetUserName()

    local r, g, b = watermark_col:GetValue()

    if watermark_sw:GetValue() then
        draw.Color(30, 30, 30, 180)
        draw.FilledRect((screen_x - 12) - draw.GetTextSize(wm_text), 5, screen_x - 4, 29)

        draw.Color(r, g, b, 180)
        draw.FilledRect((screen_x - 12) - draw.GetTextSize(wm_text), 29, screen_x - 4, 26)

        draw.SetFont(font_watermark); draw.Color(210, 210, 210, 255)
        draw.TextShadow((screen_x - 7) - draw.GetTextSize(wm_text), 12, wm_text)
    end
end

local function viewmodel_override()
    if viewmodel_sw:GetValue() then
        if client.GetConVar("viewmodel_offset_x") ~= viewmodel_x_slider:GetValue() then
            client.SetConVar("viewmodel_offset_x", viewmodel_x_slider:GetValue(), true)
        end

        if client.GetConVar("viewmodel_offset_y") ~= viewmodel_y_slider:GetValue() then
            client.SetConVar("viewmodel_offset_y", viewmodel_y_slider:GetValue(), true)
        end

        if client.GetConVar("viewmodel_offset_z") ~= viewmodel_z_slider:GetValue() then
            client.SetConVar("viewmodel_offset_z", viewmodel_z_slider:GetValue(), true)
        end
    end
end

local function aspect_ratio()
    if aspect_sw:GetValue() then
        if client.GetConVar("r_aspectratio") ~= aspect_slider:GetValue() then
            client.SetConVar("r_aspectratio", aspect_slider:GetValue(), true)
        end
    end
end

local killsay_phrases = {
    [1] = "Visit www.EZfrags.co.uk for the finest public & private CS:GO cheats",
    [2] = "Stop being a noob! Get good with www.EZfrags.co.uk",
    [3] = "I'm not using www.EZfrags.co.uk, you're just bad",
    [4] = "If I was cheating, I'd use www.EZfrags.co.uk",
    [5] = "Think you could do better? Not without www.EZfrags.co.uk",
    [6] = "You just got pwned by EZfrags, the #1 CS:GO cheat",
}

local function killsay(e)
    if killsay_sw:GetValue() then
        if e:GetName() == "player_death" then
            local localplayer = client.GetLocalPlayerIndex();
            local victim = client.GetPlayerIndexByUserID(e:GetInt("userid"));
            local attacker = client.GetPlayerIndexByUserID(e:GetInt("attacker"));

            if (attacker == localplayer and victim ~= localplayer) then
                client.ChatSay(killsay_phrases[math.random(1, #killsay_phrases)]);
            end
        end
    end
end

local function aa_arrows()
    if aa_arrows_sw:GetValue() then
        if not entities.GetLocalPlayer() or not entities.GetLocalPlayer():IsAlive() then return end

        if not gui.GetValue( "rbot.master" ) then return end
        local r, g, b, a = aa_arrows_col:GetValue()
        
        if gui.GetValue("rbot.antiaim.base.rotation") < 0 and get_base_yaw() == 0 or gui.GetValue("rbot.antiaim.base.rotation") > 0 and get_base_yaw() ~= 0 then
            draw.Color(r, g, b, a)
            draw.Triangle(screen_x / 2 + 50, screen_y / 2 - 4 , screen_x / 2 + 69, screen_y / 2, screen_x / 2 + 50, screen_y / 2 + 4)
        elseif gui.GetValue("rbot.antiaim.base.rotation") > 0 and get_base_yaw() == 0 or gui.GetValue("rbot.antiaim.base.rotation") < 0 and get_base_yaw() ~= 0 then
            draw.Color(r, g, b, a)
            draw.Triangle(screen_x / 2 - 50, screen_y / 2 + 4, screen_x / 2 - 50, screen_y / 2 - 4,  screen_x / 2 - 69, screen_y / 2)
        end
    end
end

local undercross_pos = {
    [1] = 40,
    [2] = 55,
    [3] = 70,
    [4] = 85,
    [5] = 100,
}

local function undercross_indicators()
    local pos_items = function(string)
        return screen_x / 2 - draw.GetTextSize(string) / 2
    end

    if undercross_indicators_sw:GetValue() then
        local localplayer = entities.GetLocalPlayer()

        if localplayer == nil or not localplayer:IsAlive() then return end

        local r, g, b, a = undercross_indicators_color:GetValue()
        local itemsc = 1

        draw.SetFont(font_undecross); draw.Color(r, g, b, a)
        draw.TextShadow(pos_items("AIMWARE"), screen_y/2 + 25, "AIMWARE")

        draw.SetFont(font_undecross_items)

        if awol_sw:GetValue() then
            draw.TextShadow(pos_items("autowall"), screen_y/2 + undercross_pos[itemsc], "autowall")

            itemsc = itemsc + 1
        end

        draw.TextShadow(pos_items("fov: " .. gui.GetValue("rbot.aim.target.fov") .. "°"), screen_y/2 + undercross_pos[itemsc],
        "fov: " .. gui.GetValue("rbot.aim.target.fov") .. "°")

        itemsc = itemsc + 1

        if roll_slider:GetValue() > 0 then
            draw.Color(2.55 * (get_percentage(roll_slider:GetValue(), 90)), 255 - (2.55 * (get_percentage(roll_slider:GetValue(), 90))), 0, a)
            draw.TextShadow(pos_items("roll: " .. roll_slider:GetValue() .. "°"), screen_y/2 + undercross_pos[itemsc], "roll: " .. roll_slider:GetValue() .. "°")

            itemsc = itemsc + 1
        end

        if ragetoggle_sw:GetValue() then
            draw.Color(255, 0, 0, math.abs((a * math.sin(globals.CurTime()))))
            draw.TextShadow(pos_items("rage aa"), screen_y/2 + undercross_pos[itemsc], "rage aa")

            itemsc = itemsc + 1
        end
    end
end

-- POO POO --

local function clamp() -- this won't allow user to set some things to minimize the chance of getting banned
    if not ragetoggle_sw:GetValue() then
        gui.SetValue("rbot.antiaim.base", 0)
        gui.SetValue("rbot.antiaim.advanced.pitch", 0)
    end

    gui.SetValue("rbot.antiaim.condition.autodir.targets", 0)
    --gui.SetValue("rbot.antiaim.condition.autodir.edges", 0)
    gui.SetValue("rbot.antiaim.advanced.antiresolver", 0)
    gui.SetValue("rbot.antiaim.extra.exposefake", 0)
    gui.SetValue("rbot.antiaim.advanced.roll", 0)
end

local function dynamicfov()
    if dynamicfov_sw:GetValue() then
        if dynamicfov_min:GetValue() > dynamicfov_max:GetValue() then return end

        local localplayer = entities.GetLocalPlayer()

        if localplayer == nil or not localplayer:IsAlive() then return end

        local players = entities.FindByClass("CCSPlayer")
        local localplayer_head = localplayer:GetHitboxPosition(0)
        local distance_to_enemy = nil

        for i = 1, #players do
            local player = players[i]
            if player:IsAlive() then
                if player:GetTeamNumber() ~= localplayer:GetTeamNumber() then
                    local player_head = player:GetHitboxPosition(0)
                    distance_to_enemy = math.sqrt(math.pow((player_head.x - localplayer_head.x), 2) + 
                    math.pow((player_head.y - localplayer_head.y), 2) +
                    math.pow((player_head.z - localplayer_head.z), 2))
                end
            end
        end

        local fov = nil

        if distance_to_enemy == nil or distance_to_enemy > 1200 then 
            fov = dynamicfov_min:GetValue() 
        else
            fov = math.floor(math.min(dynamicfov_max:GetValue(), math.max(dynamicfov_min:GetValue(), 5000 / distance_to_enemy)))
        end

        gui.SetValue("rbot.aim.target.fov", fov)
    end
end

local function autowall()
    for i = 1, #weapon_categories do
        if awol_sw:GetValue() then
            gui.SetValue("rbot.hitscan.accuracy." .. weapon_categories[i] .. ".autowall", true)
        else
            gui.SetValue("rbot.hitscan.accuracy." .. weapon_categories[i] .. ".autowall", false)
        end
    end
end

local function fl_randomizer()
    if fl_randomizer_sw:GetValue() then
        if fl_randomizer_min:GetValue() > fl_randomizer_max:GetValue() then return end
        gui.SetValue("misc.fakelag.factor", math.random(fl_randomizer_min:GetValue(), fl_randomizer_max:GetValue()))
    end
end


local function freestanding()
    if fs_sw:GetValue() then
        if not gui.GetValue("rbot.antiaim.condition.autodir.edges") then
            gui.SetValue("rbot.antiaim.condition.autodir.edges", true)
        end

        gui.SetValue("rbot.antiaim.left", 90)
        gui.SetValue("rbot.antiaim.right", -90)
    else
        if gui.GetValue("rbot.antiaim.condition.autodir.edges") then
            gui.SetValue("rbot.antiaim.condition.autodir.edges", false)
        end
    end
end

local desync_side = "left"; local override_desync = false
local function desync()
    if not override_desync then
        if desync_side == "left" then
            if get_base_yaw() > 0 then
                gui.SetValue("rbot.antiaim.base.rotation", desync_left:GetValue())
            else
                gui.SetValue("rbot.antiaim.base.rotation", -desync_left:GetValue())
            end
        elseif desync_side == "right" then
            if get_base_yaw() > 0 then
                gui.SetValue("rbot.antiaim.base.rotation", -desync_left:GetValue())
            else
                gui.SetValue("rbot.antiaim.base.rotation", desync_left:GetValue())
            end
        elseif desync_side == "center" then
            gui.SetValue("rbot.antiaim.base.rotation", 0)
        end
    end
end

local function inverter()
    if inverter_kb:GetValue() == nil or inverter_kb:GetValue() == 0 then return end

    if input.IsButtonPressed(inverter_kb:GetValue()) then
        if desync_side == "left" then
            desync_side = "right"
        else
            desync_side = "left"
        end
    end
end

local roll_value = 0
local function roll(UserCmd)
    if roll_combo:GetValue() == 0 then
        roll_value = roll_slider:GetValue()
    elseif roll_combo:GetValue() == 1 then
        roll_value = -roll_slider:GetValue()
    elseif roll_combo:GetValue() == 2 then
        if roll_value >= 0 then
            roll_value = -roll_slider:GetValue()
        else
            roll_value = roll_slider:GetValue()
        end
    elseif roll_combo:GetValue() == 3 then
        if gui.GetValue("rbot.antiaim.base.rotation") < 0  then
            roll_value = roll_slider:GetValue()
        elseif gui.GetValue("rbot.antiaim.base.rotation") > 0 then
            roll_value = -roll_slider:GetValue()
        end
    end

    if UserCmd.viewangles.z ~= roll_value and not cheat.IsFakeDucking() then
        UserCmd.viewangles = EulerAngles(UserCmd.viewangles.x, UserCmd.viewangles.y, roll_value)
    end
end

local function desync_mods()
    local localplayer = entities.GetLocalPlayer()
    if localplayer == nil or not localplayer:IsAlive() then return end

    local localplayer_velocity = get_velocity()
    local is_slowwalking = false

    if gui.GetValue("rbot.accuracy.movement.slowkey") == nil or gui.GetValue("rbot.accuracy.movement.slowkey") == 0 or localplayer_velocity < 3 then
        is_slowwalking = false
    else
        is_slowwalking = input.IsButtonDown(gui.GetValue("rbot.accuracy.movement.slowkey"))
    end

    if standing_desync_mods:GetValue() == 1 and localplayer_velocity < 3 and not is_slowwalking or
       moving_desync_mods:GetValue() == 1 and localplayer_velocity >= 3 and not is_slowwalking or 
       slowwalking_desync_mods:GetValue() == 1 and is_slowwalking then

        if desync_side == "left" then
            gui.SetValue("rbot.antiaim.base.rotation", math.random(-desync_left:GetValue(), -2))
        else
            gui.SetValue("rbot.antiaim.base.rotation", math.random(2, desync_right:GetValue()))
        end

        override_desync = true

    elseif standing_desync_mods:GetValue() == 2 and localplayer_velocity < 3 and not is_slowwalking or
           moving_desync_mods:GetValue() == 2 and localplayer_velocity >= 3 and not is_slowwalking or 
           slowwalking_desync_mods:GetValue() == 2 and is_slowwalking then

        if desync_side == "left" then
            desync_side = "right"
        else
            desync_side = "left"
        end

        override_desync = false

    elseif standing_desync_mods:GetValue() == 3 and localplayer_velocity < 3 and not is_slowwalking or
           moving_desync_mods:GetValue() == 3 and localplayer_velocity >= 3 and not is_slowwalking or 
           slowwalking_desync_mods:GetValue() == 3 and is_slowwalking then

        if desync_side == "left" then
            desync_side = "center"
        elseif desync_side == "center" then
            desync_side = "right"
        else
            desync_side = "left"
        end

        override_desync = false
    else
        override_desync = false
    end
end

local next_lby_update = 0
local function lby(UserCmd)
    if lby_sw:GetValue() then
        local localplayer = entities.GetLocalPlayer()
        if localplayer == nil or not localplayer:IsAlive() then return end

        local localplayer_velocity = get_velocity()

        if localplayer_velocity > 3 or bit.band(UserCmd.buttons, bit.lshift(1, 0)) > 0 or fs_sw:GetValue() or 
        bit.band(UserCmd.buttons, bit.lshift(1, 5)) > 0 or fs_sw:GetValue() or cheat.IsFakeDucking() then
            next_lby_update = globals.CurTime() + 0.22
        end

        if globals.CurTime() >= next_lby_update then
            next_lby_update = globals.CurTime() + 0.22

            if gui.GetValue("rbot.antiaim.base.rotation") < 0 then
                UserCmd.viewangles = EulerAngles(UserCmd.viewangles.x, UserCmd.viewangles.y + lby_offset_slider:GetValue(), UserCmd.viewangles.z)
            elseif gui.GetValue("rbot.antiaim.base.rotation") > 0  then
                UserCmd.viewangles = EulerAngles(UserCmd.viewangles.x, UserCmd.viewangles.y - lby_offset_slider:GetValue(), UserCmd.viewangles.z)
            end
        end
    end
end

local function rageaa()
    if ragetoggle_sw:GetValue() then
        if gui.GetValue("rbot.antiaim.advanced.pitch") ~= 1 then
            gui.SetValue("rbot.antiaim.advanced.pitch", 1)
        end

        if get_base_yaw() ~= 180 then
            gui.SetValue("rbot.antiaim.base", 180)
        end
    end
end

-- ALL OF THAT GARBAGE EXECUTES HERE --

client.AllowListener("player_death")
callbacks.Register("FireGameEvent", killsay)

callbacks.Register("CreateMove", function(UserCmd) 
    roll(UserCmd)
    lby(UserCmd)
end)

callbacks.Register("Draw", function()
    -- VISUAL --
    watermark()
    aa_arrows()
    undercross_indicators()
    viewmodel_override()
    aspect_ratio()

    -- SEMI-RAGE --
    clamp()
    dynamicfov()
    autowall()
    fl_randomizer()
    rageaa()

    -- ANTI-AIM --
    freestanding()
    desync()
    inverter()
    desync_mods()
end);