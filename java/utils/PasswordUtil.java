package utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    public static boolean checkPassword(String plainPassword, String hashed) {
        if (hashed == null || !hashed.startsWith("$2a$")) return false;
        return BCrypt.checkpw(plainPassword, hashed);
    }
}
