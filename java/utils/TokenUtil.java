package utils;

import java.security.SecureRandom;
import java.util.Base64;

public class TokenUtil {
    private static SecureRandom random = new SecureRandom();

    public static String generateToken(int bytes) {
        byte[] b = new byte[bytes];
        random.nextBytes(b);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(b);
    }

    public static String generateTicketCode() {
        return "TICKET-" + generateToken(12);
    }
}
