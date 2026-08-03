package com.arabbank.eab.payments.as400.tests;

import com.qeas.automation.integrations.db.AS400Client;
import com.qeas.automation.mainframe.AS400System;
import org.testng.annotations.Test;
import java.util.List;

/**
 * AS/400 (EQUATION) verification — all headless, no green-screen GUI.
 *  - AS400System: run CL commands / call programs (JTOpen).
 *  - AS400Client : JDBC queries against EQUATION tables.
 *  - Headless 5250 green-screen is the framework's HaclTerminal (Terminal5250Client) — it needs
 *    IBM ACS's acshod2.jar at build/runtime, so it isn't in the public jar; enable it on an ACS box.
 */
public class BackendChecksAs400Test {
    @Test(enabled = false)
    public void clCommandExample() {
        try (AS400System ibmi = new AS400System("HOST", "USER", "PASSWORD")) {
            List<String> out = ibmi.runCommand("DSPLIBL");
            System.out.println(out);
        }
    }
    @Test(enabled = false)
    public void jdbcExample() {
        AS400Client db = new AS400Client("HOST", "USER", "PASSWORD");
        // db.query("SELECT ... FROM ...");
    }
}
