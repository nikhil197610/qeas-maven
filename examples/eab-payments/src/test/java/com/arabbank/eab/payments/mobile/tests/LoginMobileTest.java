package com.arabbank.eab.payments.mobile.tests;

import com.arabbank.eab.payments.mobile.data.LoginData;
import com.arabbank.eab.payments.mobile.flows.LoginFlow;
import com.arabbank.eab.payments.mobile.screens.common.HomeScreen;
import com.arabbank.eab.payments.support.BaseTest;
import org.testng.annotations.Test;

import static org.testng.Assert.assertTrue;

/** Data-driven mobile test: creds come from testdata.yaml, login is driven by the reusable flow. */
public class LoginMobileTest extends BaseTest {
    @Test
    public void userCanLogInToDashboard() {
        LoginData creds = LoginData.from(user("internal"));
        HomeScreen home = new LoginFlow(driver(), locatorContext).login(creds.username(), creds.password());
        assertTrue(home.isLoaded(), "Dashboard should load after login");
    }
}
