import jwt from "jsonwebtoken";

export const generateAccessToken = (userId) => {
    return jwt.sign(
        { userId },
        process.env.JWT_SECRET,
        { expiresIn: "7d" }
    );
};

export const generateOTPToken = (phone) => {
    return jwt.sign(
        { phone, purpose: "mobile-verification" },
        process.env.JWT_OTP_SECRET,
        { expiresIn: "5m" }
    );
};
