package com.arabbank.eab.payments.mobile.tests;

import com.arabbank.eab.payments.mobile.screens.common.LoginScreen;
import com.qeas.automation.core.BaseMobileTest;
import org.testng.annotations.Test;
import static org.testng.Assert.assertTrue;

/** Extends the framework's BaseMobileTest, which builds the Appium driver from config/ + -Dtarget. */
public class LoginMobileTest extends BaseMobileTest {
    @Test
    public void loginScreenIsReached() {
        LoginScreen login = new LoginScreen(driver(), locatorContext);
        assertTrue(login.isDisplayed(), "Login screen should be visible on launch");
        // login.loginAs("myUser", "myPass");
    }
}
