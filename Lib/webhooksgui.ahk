#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 2

OpenWebhooks() {
    WebhookGUI.Show("w300 h150")
}

WebhookGUI := Gui("+AlwaysOnTop")

WebhookGUI.SetFont("s8 bold", "Segoe UI")
WebhookGUI.Add("Text", "x10 y8 w280 cWhite", "If you would like the macro to send you updates occasionally on how the progression is going, you can use webhooks.")

WebhookGUI.Add("Text", "x10 y56 cWhite", "Enter your webhook URL")
WebhookURL := WebhookGUI.Add("Edit", "x10 y70 w280", "")

WebhookCheckbox := WebhookGUI.Add("Checkbox", "x10 y109 cWhite", "Enabled")

WebhookGUI.BackColor := "0c000a"
WebhookGUI.MarginX := 20
WebhookGUI.MarginY := 20

WebhookGUI.OnEvent("Close", (*) => WebhookGUI.Hide())
WebhookGUI.Title := "Webhooks"

Cancel() {
    WebhookGUI.Hide()
}