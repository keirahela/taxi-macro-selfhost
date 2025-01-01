#Requires AutoHotkey v2
#Include %A_ScriptDir%\Lib\guidegui.ahk
#Include %A_ScriptDir%\Lib\mainsettingsui.ahk

GemsEarned := 0
ShibuyaFood := 0
TraitRerolls := 0
StatChips := 0
SuperStatChips := 0
GreenEssence := 0
ColoredEssence := 0
CurrentChallenge := "None"
MinimizeImage := "Lib\Images\minimize.png"
CloseImage := "Lib/Images/close.png"
TaxiImage := "Lib\Images\faxi pfp.png"
DiscordImage := "Lib\Images\Discord-Logo.png"
lastlog := ""
MainGUI := Gui("-Caption +Border +AlwaysOnTop", "Taxi Winter Event Farm")

MainGUI.BackColor := "0c000a"
MainGUI.SetFont("s9 bold", "Segoe UI")

CloseAppButton := MainGUI.Add("Picture", "x910 y8 w60 h34 +BackgroundTrans cffffff", DiscordImage)
CloseAppButton.OnEvent("Click", (*) => OpenDiscord())

MinimizeButton:= MainGUI.Add("Picture", "x1000 y22 w37 h9 +BackgroundTrans cffffff", MinimizeImage)
MinimizeButton.OnEvent("Click", (*) => MinimizeGUI())

CloseAppButton := MainGUI.Add("Picture", "x1052 y10 w30 h32 +BackgroundTrans cffffff", CloseImage)
CloseAppButton.OnEvent("Click", (*) => ExitApp())

GuideBttn := MainGui.Add("Button", "x830 y632 w238 cffffff +BackgroundTrans +Center", "How to use?")
GuideBttn.OnEvent("Click", (*) => OpenGuide())




MainGUI.Add("Picture", "x820 y-20 w90 h90 +BackgroundTrans cffffff", TaxiImage)

MainGUI.AddProgress("c0x7e4141 x8 y27 h602 w800", 100) ; box behind roblox, credits to yuh for this idea
WinSetTransColor("0x7e4141 255", MainGUI)

MainGUI.Add("GroupBox", "x830 y60 w238 h250 cfffd90 ", "Unit Setup")
enabled1 := MainGUI.Add("Checkbox", "x840 y80 cffffff", "Slot 1")
enabled2 := MainGUI.Add("Checkbox", "x840 y110 cffffff", "Slot 2")
enabled3 := MainGUI.Add("Checkbox", "x840 y140 cffffff", "Slot 3")
enabled4 := MainGUI.Add("Checkbox", "x840 y170 cffffff", "Slot 4")
enabled5 := MainGUI.Add("Checkbox", "x840 y200 cffffff", "Slot 5")
enabled6 := MainGUI.Add("Checkbox", "x840 y230 cffffff", "Slot 6")

placement1 := MainGUI.Add("DropDownList", "x1020 y80  w40 cffffff Choose3", [1, 2, 3, 4, 5])
placement2 := MainGUI.Add("DropDownList", "x1020 y110 w40 cffffff Choose3", [1, 2, 3, 4, 5])
placement3 := MainGUI.Add("DropDownList", "x1020 y140 w40 cffffff Choose3", [1, 2, 3, 4, 5])
placement4 := MainGUI.Add("DropDownList", "x1020 y170 w40 cffffff Choose3", [1, 2, 3, 4, 5])
placement5 := MainGUI.Add("DropDownList", "x1020 y200 w40 cffffff Choose3", [1, 2, 3, 4, 5])
placement6 := MainGUI.Add("DropDownList", "x1020 y230 w40 cffffff Choose3", [1, 2, 3, 4, 5])


SendChatButton := MainGUI.Add("Button", "x710 y633 cffffff Choose1 +Center", "Send Chat")

SendChatButton.OnEvent("Click", (*) => OpenSendChat())

MainGUI.Add("Text", "x940 y80 h60 cffffff +BackgroundTrans", "Placements: ")
MainGUI.Add("Text", "x940 y110 h60 cffffff +BackgroundTrans", "Placements: ")
MainGUI.Add("Text", "x940 y140 h60 cffffff +BackgroundTrans", "Placements: ")
MainGUI.Add("Text", "x940 y170 h60 cffffff +BackgroundTrans", "Placements: ")
MainGUI.Add("Text", "x940 y200 h60 cffffff +BackgroundTrans", "Placements: ")
MainGUI.Add("Text", "x940 y230 h60 cffffff +BackgroundTrans", "Placements: ")

SaveConfigBttn := MainGUI.Add("Button", "x850 y270 w198 h30 cffffff +Center", "Save Configuration")
SaveConfigBttn.OnEvent("Click", (*) => SaveConfig())




MainGUI.Add("GroupBox", "x830 y320 w238 h210 cfffd90 ", "Activity Log ")
ActivityLog := MainGUI.Add("Text", "x830 y340 w238 h300 r11 cffffff +BackgroundTrans +Center", "Macro Launched")



MainGUI.Add("GroupBox", "x830 y540 w238 h80 cfffd90 ", "Keybinds")
KeyBinds := MainGUI.Add("Text", "x830 y560 w238 h300 r7 cffffff +BackgroundTrans +Center", "F1 - Fix Roblox Position `n F2 - Start Macro `n F3 - Stop Macro")

MainGUI.SetFont("s16 bold", "Segoe UI")

MainGUI.Add("Text", "x12 y632 w800 cWhite +BackgroundTrans", "Winter Event Macro v1.1.6 - Taxi Macro")

MainGUI.Show("x27 y15 w1100 h665")

AddToLog(text) {
    global lastlog
    ActivityLog.Value := text "`n" ActivityLog.Value
}

MinimizeGUI() {
    WinMinimize("Taxi Winter Event Farm")
}

OpenDiscord() {
    Run("https://discord.gg/UB9AaPzqdq")
}

SaveConfig() {
    global enabled1, enabled2, enabled3, enabled4, enabled5, enabled6
    global placement1, placement2, placement3, placement4, placement5, placement6

    ; Open file for writing
    File := FileOpen("Lib\Settings\config.txt", "w")
    if !File {
        AddToLog("Failed to save the configuration.")
        return
    }

    ; Write each setting to the file
    File.WriteLine("Enabled1=" enabled1.Value)
    File.WriteLine("Enabled2=" enabled2.Value)
    File.WriteLine("Enabled3=" enabled3.Value)
    File.WriteLine("Enabled4=" enabled4.Value)
    File.WriteLine("Enabled5=" enabled5.Value)
    File.WriteLine("Enabled6=" enabled6.Value)

    File.WriteLine("Placement1=" placement1.Text)
    File.WriteLine("Placement2=" placement2.Text)
    File.WriteLine("Placement3=" placement3.Text)
    File.WriteLine("Placement4=" placement4.Text)
    File.WriteLine("Placement5=" placement5.Text)
    File.WriteLine("Placement6=" placement6.Text)

    File.Close()
    AddToLog("Configuration saved successfully.")
}

LoadConfig() {
    global enabled1, enabled2, enabled3, enabled4, enabled5, enabled6
    global placement1, placement2, placement3, placement4, placement5, placement6

    if !FileExist("Lib\Settings\config.txt") {
        AddToLog("No configuration file found. Default settings will be used.")
    } else {
        ; Open file for reading
        file := FileOpen("Lib\Settings\config.txt", "r", "UTF-8")
        if !file {
            AddToLog("Failed to load the configuration.")
            return
        }

        ; Read settings from the file
        while !file.AtEOF {
            line := file.ReadLine()
            if RegExMatch(line, "Enabled(\d)=(\d+)", &match) {
                slot := match.1
                value := match.2
                enabledgui := "Enabled" slot
                enabledgui := %enabledgui%
                enabledgui.Value := value ; Set checkbox value
            }
            if RegExMatch(line, "Placement(\d)=(\d+)", &match) {
                slot := match.1
                value := match.2
                placementgui := "Placement" slot
                placementgui := %placementgui%
                placementgui.Text := value ; Set dropdown value
            }
        }
        file.Close()
        AddToLog("Configuration loaded successfully.")
    }


    LoadChatSettings() ; Load chat settings
}





SendChatGUI := Gui("+AlwaysOnTop")

SendChatGUI.SetFont("s8 bold", "Segoe UI")
SendChatGUI.Add("Text", "x10 y8 w280 cWhite", "Would you like the macro to send a message once it loads in a game? (it only sends it once per game and this is optional)")

SendChatGUI.Add("Text", "x10 y56 cWhite", "Message to send")
ChatToSend := SendChatGUI.Add("Edit", "x10 y70 w280", "")

ChatStatusBox := SendChatGUI.Add("Checkbox", "x10 y109 cWhite", "Enabled")

SaveChat := SendChatGUI.Add("Button", "x170 y105 w120 +BackgroundTrans", "Save Settings")
SaveChat.OnEvent("Click", (*) => SaveChatSend())

SendChatGUI.BackColor := "0c000a"
SendChatGUI.MarginX := 20
SendChatGUI.MarginY := 20

SendChatGUI.OnEvent("Close", (*) => SendChatGUI.Hide())
SendChatGUI.Title := "Send Chat"

SaveChatSend() {
    global ChatToSend, ChatStatusBox

    ; Open file for writing
    File := FileOpen("Lib\Settings\chatsettings.txt", "w")
    if !File {
        AddToLog("Failed to save the chat settings.")
        return
    }

    ; Write the chat settings to the file
    File.WriteLine("MessageToSend=" ChatToSend.Value)
    File.WriteLine("ChatEnabled=" ChatStatusBox.Value)
    File.Close()
    AddToLog("Chat settings saved successfully.")
    SendChatGUI.Hide()
}

LoadChatSettings() {
    global ChatToSend, ChatStatusBox

    if !FileExist("Lib\Settings\chatsettings.txt") {
        AddToLog("No chat settings file found. Default settings will be used.")
        return
    }

    ; Open file for reading
    File := FileOpen("Lib\Settings\chatsettings.txt", "r", "UTF-8")
    if !File {
        AddToLog("Failed to load the chat settings.")
        return
    }

    ; Read and apply the chat settings
    while !File.AtEOF {
        line := File.ReadLine()
        if RegExMatch(line, "MessageToSend=(.+)", &match) {
            ChatToSend.Value := match.1 ; Set the chat message
        }
        if RegExMatch(line, "ChatEnabled=(\d+)", &match) {
            ChatStatusBox.Value := match.1 ; Set the checkbox value
        }
    }

    File.Close()
    AddToLog("Chat settings loaded successfully.")
}



OpenSendChat() {
    SendChatGUI.Show("w300 h150")
}

LoadConfig()

