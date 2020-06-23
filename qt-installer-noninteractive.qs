function Controller() {
    installer.autoRejectMessageBoxes();
    installer.setMessageBoxAutomaticAnswer("installationError", QMessageBox.Retry);
    installer.setMessageBoxAutomaticAnswer("installationErrorWithRetry", QMessageBox.Retry);
    installer.setMessageBoxAutomaticAnswer("DownloadError", QMessageBox.Retry);
    installer.setMessageBoxAutomaticAnswer("archiveDownloadError", QMessageBox.Retry);
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton);
    })
}

Controller.prototype.WelcomePageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.CredentialsPageCallback = function() {
    var login = installer.environmentVariable("QT_CI_LOGIN");
    var password = installer.environmentVariable("QT_CI_PASSWORD");
    var widget = gui.currentPageWidget();
    widget.loginWidget.EmailLineEdit.setText(login);
    widget.loginWidget.PasswordLineEdit.setText(password);
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ObligationsPageCallback = function() {
    var page = gui.pageWidgetByObjectName("ObligationsPage");
    page.obligationsAgreement.setChecked(true);
    page.completeChanged();
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.DynamicTelemetryPluginFormCallback = function() {
    var widget = gui.currentPageWidget();
    widget.TelemetryPluginForm.statisticGroupBox.disableStatisticRadioButton.checked = true;
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.TargetDirectoryPageCallback = function()
{
    //dev is the user in our docker image
    gui.currentPageWidget().TargetDirectoryLineEdit.setText(installer.environmentVariable("QT_PATH"));
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.PerformInstallationPageCallback = function() {
    gui.clickButton(buttons.CommitButton);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();
    widget.deselectAll();
    widget.selectComponent("qt.qt5." + installer.environmentVariable("QT_VERSION_PKG") + ".gcc_64");
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ReadyForInstallationPageCallback = function()
{
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.FinishedPageCallback = function() {
    var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm;
    if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
        checkBoxForm.launchQtCreatorCheckBox.checked = false;
    }
    gui.clickButton(buttons.FinishButton);
}
