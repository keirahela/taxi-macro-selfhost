#Include %A_ScriptDir%\Lib\gui.ahk
#Include %A_ScriptDir%\Lib\configgui.ahk
#Include %A_ScriptDir%\Macro.ahk

SaveConfig() {
    global enabled1, enabled2, enabled3, enabled4, enabled5, enabled6
    global placement1, placement2, placement3, placement4, placement5, placement6

    SaveChoiceGui.Show("AutoSize Center")

    return
}

LoadConfig() {
    global enabled1, enabled2, enabled3, enabled4, enabled5, enabled6
    global placement1, placement2, placement3, placement4, placement5, placement6

    LoadChoiceGui.Show("AutoSize Center")

    return
}

GuiClose() {
    LoadChoiceGui.Hide()
    SaveChoiceGui.Hide()
}

SaveConfigToFile(filePath) {
    File := FileOpen(filePath, "w")
    if !File {
        AddToLog("Failed to save the configuration.")
        return
    }

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
    AddToLog("Configuration saved successfully to " filePath ".")
}

SaveGlobal(*) {
    global enabled1, enabled2, enabled3, enabled4, enabled5, enabled6
    global placement1, placement2, placement3, placement4, placement5, placement6

    SaveConfigToFile("C:\global.txt")
    SaveWebhookSettings(true)
    GuiClose()
}

SaveLocal(*) {
    global enabled1, enabled2, enabled3, enabled4, enabled5, enabled6
    global placement1, placement2, placement3, placement4, placement5, placement6

    SaveConfigToFile("Lib\Settings\config.txt")
    SaveWebhookSettings(false)
    GuiClose()
}

LoadGlobal(*) {
    global enabled1, enabled2, enabled3, enabled4, enabled5, enabled6
    global placement1, placement2, placement3, placement4, placement5, placement6

    LoadConfigFromFile("C:\global.txt")
    LoadWebhookSettings(true)
    GuiClose()
}

LoadLocal(*) {
    global enabled1, enabled2, enabled3, enabled4, enabled5, enabled6
    global placement1, placement2, placement3, placement4, placement5, placement6

    LoadConfigFromFile("Lib\Settings\config.txt")
    LoadWebhookSettings(false)
    GuiClose()
}

LoadConfigFromFile(filePath) {
    global enabled1, enabled2, enabled3, enabled4, enabled5, enabled6
    global placement1, placement2, placement3, placement4, placement5, placement6

    if !FileExist(filePath) {
        AddToLog("No configuration file found. Default settings will be used.")
    } else {
        ; Open file for reading
        file := FileOpen(filePath, "r", "UTF-8")
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

SaveWebhookSettings(isGlobal) {
    global WebhookURL, WebhookCheckbox


    ; Open file for writing
    File := FileOpen((isGlobal = true) ? "C:\webhooksettings.txt" : "Lib\Settings\webhooksettings.txt", "w")
    if !File {
        AddToLog("Failed to save the chat settings.")
        return
    }

    ; Write the chat settings to the file
    File.WriteLine("WebhookURL=" WebhookURL.Value)
    File.WriteLine("WebhookEnabled=" WebhookCheckbox.Value)
    File.Close()
    AddToLog("Chat settings saved successfully.")
    SendChatGUI.Hide()

}

LoadWebhookSettings(isGlobal) {
    global WebhookURL, WebhookCheckbox

    if !FileExist((isGlobal = true) ? "C:\webhooksettings.txt" : "Lib\Settings\webhooksettings.txt") {
        AddToLog("No webhook settings file found. Default settings will be used.")
        return
    }

    ; Open file for reading
    File := FileOpen((isGlobal = true) ? "C:\webhooksettings.txt" : "Lib\Settings\webhooksettings.txt", "r", "UTF-8")
    if !File {
        AddToLog("Failed to load the chat settings.")
        return
    }

    ; Read and apply the chat settings
    while !File.AtEOF {
        line := File.ReadLine()
        if RegExMatch(line, "WebhookURL=(.+)", &match) {
            WebhookURL.Value := match.1 ; Set the chat message
        }
        if RegExMatch(line, "WebhookEnabled=(\d+)", &match) {
            WebhookCheckbox.Value := match.1 ; Set the checkbox value
        }
    }

    File.Close()
    try {
        if (WebhookURL.Value != "") {
            Webhook := WebHookBuilder(WebhookURL.Value)
        }
    } catch {
        MsgBox("Your webhook URL is not valid.", "Webhook", 4096 + 0)
    }
    AddToLog("Webhook settings loaded successfully.")
}