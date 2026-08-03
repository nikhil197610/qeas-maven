package com.arabbank.eab.payments.api.tests;

import com.qeas.automation.api.ApiClient;
import org.testng.annotations.Test;
import java.util.Map;

/** API engine — runs with no device/host (points at a public echo API here). */
public class AccountApiTest {
    @Test
    public void apiEngineIsAvailable() {
        new ApiClient(Map.of("baseUrl", "https://httpbin.org")).retries(1)
            .get("/get").assertSuccess().assertField("url", "https://httpbin.org/get");
    }
}
