package com.hotel.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    private PasswordUtil() { }

    /** Call when saving a new password (register, or a future "change password"). */
    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    /** Call when checking a login attempt against the stored hash. */
    public static boolean matches(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) return false;
        try {
            return BCrypt.checkpw(plainPassword, storedHash);
        } catch (IllegalArgumentException e) {
            // storedHash isn't a valid BCrypt hash (e.g. corrupted data) — never allow login
            return false;
        }
    }
}