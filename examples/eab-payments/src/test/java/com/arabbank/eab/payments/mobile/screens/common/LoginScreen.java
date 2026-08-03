package com.arabbank.eab.payments.mobile.screens.common;

import com.qeas.automation.actions.BaseScreen;
import com.qeas.automation.locator.LocatorContext;
import io.appium.java_client.AppiumDriver;

/** Mobile page object. Locators live in JSON (resources/locators/common/LoginScreen.json). */
public class LoginScreen extends BaseScreen {
    public LoginScreen(AppiumDriver driver, LocatorContext locatorContext) {
        super(driver, "common/LoginScreen", locatorContext);
    }
    public boolean isDisplayed() { return isTextPresent("Login"); }
    public void loginAs(String user, String password) {
        clearAndType(locate("username"), user);
        clearAndType(locate("password"), password);
        hideKeyboard();
        click(locate("loginButton"));
    }
}
