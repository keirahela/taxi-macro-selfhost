#Requires Autohotkey v2.0

#Include %A_ScriptDir%\Lib\gui.ahk

global repoOwner := "keirahela"
global repoName := "taxi-macro-selfhost"
global currentVersion := "v1.1.6-4"

CheckForUpdates() {
    url := "https://api.github.com/repos/" repoOwner "/" repoName "/releases/latest"
    http := ComObject("MSXML2.XMLHTTP")
    http.Open("GET", url, false)
    http.Send()

    if (http.Status != 200) {
        AddToLog("Failed to check for updates.")
        return
    }

    response := http.responseText
    latestVersion := JSON.parse(response).Get("tag_name")

    if (latestVersion != currentVersion) {
        AddToLog("A new version is available! Current version: " currentVersion "`nLatest version: " latestVersion)
        if (autoUpdateEnabled) {
            DownloadAndUpdateRepo()
        }
    } else {
        AddToLog("You are using the latest version.")
    }
}


DownloadAndUpdateRepo() {
    zipUrl := "https://github.com/" repoOwner "/" repoName "/archive/refs/heads/main.zip"

    zipFilePath := A_ScriptDir "\repo.zip"

    Download(zipUrl, zipFilePath)

    ExtractZIP(zipFilePath, A_ScriptDir)

    FileDelete(zipFilePath)

    extractedFolderPath := A_ScriptDir . "\" . "taxi-macro-selfhost-main"

    if !DirExist(extractedFolderPath) {
        MsgBox("Something went wrong while extracting")
        return
    }

    FileCopy(extractedFolderPath, A_ScriptDir, "1")

    FileDelete(extractedFolderPath)

    AddToLog("Updated! Restarting script")
    RestartScript()
}

ExtractZIP(zipFilePath, targetDir) {
    RunWait("tar -xf " "" zipFilePath "" " -C " "" targetDir "" "", "", "Hide")
}

RestartScript() {
    Run(A_ScriptFullPath)
    ExitApp
}