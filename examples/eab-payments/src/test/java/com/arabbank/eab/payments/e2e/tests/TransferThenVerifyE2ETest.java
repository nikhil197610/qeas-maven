package com.arabbank.eab.payments.e2e.tests;

import com.arabbank.eab.payments.mobile.screens.common.LoginScreen;
import com.qeas.automation.api.ApiClient;
import com.qeas.automation.core.BaseMobileTest;
import com.qeas.automation.mainframe.AS400System;
import org.testng.annotations.Test;
import java.util.List;
import java.util.Map;

/**
 * MIXED flow — one scenario spanning engines: act on MOBILE, then verify the result via the API and
 * on the AS/400 (EQUATION) backend. This is the pattern for cross-engine end-to-end checks.
 */
public class TransferThenVerifyE2ETest extends BaseMobileTest {
    @Test(enabled = false)
    public void transferOnMobileThenVerifyBackend() {
        // 1) MOBILE — perform the action
        LoginScreen login = new LoginScreen(driver(), locatorContext);
        login.loginAs("myUser", "myPass");
        String reference = "EW-123456";   // captured from the transfer receipt

        // 2) API — verify through a backend service
        new ApiClient(Map.of("baseUrl", "https://api.internal"))
            .get("/transfers/" + reference).assertSuccess();

        // 3) AS/400 (EQUATION) — verify the posting landed
        try (AS400System ibmi = new AS400System("HOST", "USER", "PASSWORD")) {
            List<String> txns = ibmi.runCommand("DSPLIBL");
            // assert the reference/amount appears in txns
        }
    }
}
