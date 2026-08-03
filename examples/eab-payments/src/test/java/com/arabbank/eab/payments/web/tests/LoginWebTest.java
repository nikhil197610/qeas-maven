package com.arabbank.eab.payments.web.tests;

import com.arabbank.eab.payments.web.pages.LoginPage;
import com.qeas.automation.core.Platform;
import com.qeas.automation.core.config.ConfigLoader;
import com.qeas.automation.core.driver.DriverFactory;
import com.qeas.automation.core.driver.DriverManager;
import org.openqa.selenium.WebDriver;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.Test;

/** Web tests manage their own WebDriver via DriverFactory (config/web.yaml). */
public class LoginWebTest {
    @Test(enabled = false)
    public void loginPageLoads() {
        WebDriver driver = DriverFactory.create(Platform.WEB, ConfigLoader.load(Platform.WEB));
        DriverManager.setDriver(driver, Platform.WEB);
        LoginPage page = new LoginPage(driver);
        page.open("https://example.com/login");
        // assertEquals(page.title(), "Login");
    }
    @AfterMethod(alwaysRun = true)
    public void quit() { if (DriverManager.hasDriver()) DriverManager.quitDriver(); }
}
