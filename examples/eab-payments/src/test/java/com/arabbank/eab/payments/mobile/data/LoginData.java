package com.arabbank.eab.payments.mobile.data;

import java.util.Map;

/** Login credentials, built from a {@code users:} block in testdata.yaml (data-driven). */
public record LoginData(String username, String password) {
    public static LoginData from(Map<String, Object> m) {
        return new LoginData(str(m, "username"), str(m, "password"));
    }
    private static String str(Map<String, Object> m, String key) {
        Object v = m.get(key);
        return v == null ? null : String.valueOf(v);
    }
}
