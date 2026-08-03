package com.arabbank.eab.payments.web.pages;

import com.qeas.automation.actions.BasePage;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

/** Web page object (Selenium 4). Uses the framework's click()/clearAndType() waits. */
public class LoginPage extends BasePage {
    public LoginPage(WebDriver driver) { super(driver); }
    public void open(String url) { navigateTo(url); }
    public void loginAs(String user, String password) {
        clearAndType(driver.findElement(By.id("username")), user);
        clearAndType(driver.findElement(By.id("password")), password);
        click(driver.findElement(By.id("login")));
    }
    public String title() { return getTitle(); }
}
