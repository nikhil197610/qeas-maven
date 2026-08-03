package com.arabbank.eab.payments.support;

import com.qeas.automation.core.BaseMobileTest;
import com.qeas.automation.core.config.ConfigLoader;
import org.testng.annotations.BeforeMethod;

import java.util.Map;

/**
 * Project test base. The framework's {@link BaseMobileTest} owns the driver lifecycle
 * (target/platform/device → Appium driver → thread-local DriverManager → LocatorContext); this class
 * only layers project test data from {@code config/testdata.yaml}. Mobile + e2e tests extend this.
 */
public abstract class BaseTest extends BaseMobileTest {

    protected Map<String, Object> testData;

    @BeforeMethod(alwaysRun = true)
    public void loadTestData() {
        testData = ConfigLoader.loadFile("testdata.yaml");
    }

    /** A named user block from {@code testdata.yaml} (users: → key). */
    @SuppressWarnings("unchecked")
    protected Map<String, Object> user(String key) {
        Map<String, Object> users = (Map<String, Object>) testData.get("users");
        return (Map<String, Object>) users.get(key);
    }
}
