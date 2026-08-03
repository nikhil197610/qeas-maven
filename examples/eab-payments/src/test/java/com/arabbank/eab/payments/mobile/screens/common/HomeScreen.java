package com.arabbank.eab.payments.mobile.screens.common;

import com.qeas.automation.actions.BaseScreen;
import com.qeas.automation.locator.LocatorContext;
import io.appium.java_client.AppiumDriver;

import java.time.Duration;

/** Post-login dashboard — the shared landing point flows start from. */
public class HomeScreen extends BaseScreen {
    public HomeScreen(AppiumDriver driver, LocatorContext locatorContext) {
        super(driver, "common/HomeScreen", locatorContext);
    }
    public boolean isLoaded() {
        return isTextPresent("welcome", Duration.ofSeconds(30));
    }
}
