package com.arabbank.eab.payments.mobile.flows;

import com.arabbank.eab.payments.mobile.screens.common.HomeScreen;
import com.arabbank.eab.payments.mobile.screens.common.LoginScreen;
import com.qeas.automation.locator.LocatorContext;
import io.appium.java_client.AppiumDriver;

/**
 * Reusable authentication flow. Every test that needs a logged-in session calls {@link #login} here
 * rather than re-driving the login screens, so the steps live in exactly one place.
 */
public final class LoginFlow {
    private final AppiumDriver driver;
    private final LocatorContext locatorContext;

    public LoginFlow(AppiumDriver driver, LocatorContext locatorContext) {
        this.driver = driver;
        this.locatorContext = locatorContext;
    }

    /** Enters credentials on the login screen and returns the dashboard it lands on. */
    public HomeScreen login(String username, String password) {
        new LoginScreen(driver, locatorContext).loginAs(username, password);
        return new HomeScreen(driver, locatorContext);
    }
}
