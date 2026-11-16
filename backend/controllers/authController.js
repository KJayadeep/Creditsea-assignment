import bcrypt from 'bcryptjs';

import OTP from '../models/otpModel.js';
import User from '../models/userModel.js';
import { generateOTP } from '../utils/otpGenerator.js';
import { generateAccessToken, generateOTPToken } from '../utils/generateToken.js';

export const sendOTP = async (req, res) => {
    const { phone} = req.body;

    try {
        if (!/^[6-9]\d{9}$/.test(phone || "")) {
            return res.status(400).json({
                message: "Invalid phone number"
            });
        }
        const existingUser = await User.findOne({ phone });

        if (existingUser) {
            return res.status(409).json({
                message: "User already exists. Please login."
            });
        }
        const otp = generateOTP(4);
        console.log(`Generated OTP for ${phone}: ${otp}`);
        const salt = await bcrypt.genSalt(10);
        const hashedOTP = await bcrypt.hash(otp, salt);

        const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

        await OTP.findOneAndUpdate(
            { phone },
            { otpHash: hashedOTP, expiresAt, verified: false, attempts: 0 },
            { upsert: true, new: true, setDefaultsOnInsert: true}
        );


        res.status(200).json({
            message: 'OTP sent successfully',
            otp: otp
        });
    } catch (error) {
        console.error('Error sending OTP:', error);
        res.status(500).json({ message: 'Failed to send OTP' });
    }
};

export const verifyOTP = async (req, res) => {
    const { phone, otp } = req.body;

    try {
        if (!/^\d{4}$/.test(otp || "")) {
            return res.status(400).json({
                message: "Invalid OTP format"
            });
        }
        const otpDoc = await OTP.findOne({ phone });
        if (!otpDoc) {
            return res.status(404).json({ message: 'OTP not found' });
        }

        if (otpDoc.expiresAt < new Date()) {
            return res.status(400).json({ message: 'OTP has expired' });
        }

        if (otpDoc.attempts >= 5) {
            return res.status(429).json({
                message: 'Too many attempts. Request a new OTP.'
            });
        }

        const isMatch = await bcrypt.compare(otp, otpDoc.otpHash);

        if (!isMatch) {
            otpDoc.attempts += 1;
            await otpDoc.save();
            return res.status(400).json({ message: 'Invalid OTP' });
        }

        otpDoc.verified = true;
        await otpDoc.save();


        res.status(200).json({ message: 'OTP verified successfully'});
    } catch (error) {
        console.error('Error verifying OTP:', error);
        res.status(500).json({ message: 'Failed to verify OTP' });
    }
};


export const registerUser = async (req, res) => {
    const { phone, password } = req.body;

    try {
        if (!/^[6-9]\d{9}$/.test(phone || "")) {
            return res.status(400).json({
                message: 'Invalid phone number'
            });
        }

        if (
            typeof password !== 'string' ||
            password.length < 8 ||
            !/[!@#$%^&*(),.?":{}|<>]/.test(password)
        ) {
            return res.status(400).json({
                message: 'Password must be at least 8 characters and contain a special character'
            });
        }

        // Check whether this phone number has a valid OTP verification
        const otpDoc = await OTP.findOne({
            phone,
            verified: true,
            expiresAt: { $gt: new Date() }
        });

        if (!otpDoc) {
            return res.status(401).json({
                message: 'Please verify your mobile number first'
            });
        }

        const existingUser = await User.findOne({ phone });

        if (existingUser) {
            return res.status(409).json({
                message: 'User already exists'
            });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const user = await User.create({
            phone,
            password: hashedPassword
        });

        // Remove the OTP record after successful registration
        await OTP.deleteOne({ _id: otpDoc._id });

        const accessToken = generateAccessToken(user._id);

        res.cookie('accessToken', accessToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            maxAge: 7 * 24 * 60 * 60 * 1000,
            path: '/'
        });

        return res.status(201).json({
            message: 'Account created successfully',
            token: accessToken,
            user: {
                id: user._id,
                phone: user.phone
            }
        });

    } catch (error) {
        console.error('Registration error:', error);

        return res.status(500).json({
            message: 'Registration failed'
        });
    }
};



export const loginUser = async (req, res) => {
    const { phone, password } = req.body;

    try {
        const user = await User.findOne({ phone });

        if (!user) {
            return res.status(401).json({
                message: 'Invalid phone number or password'
            });
        }

        const isMatch = await bcrypt.compare(
            password,
            user.password
        );

        if (!isMatch) {
            return res.status(401).json({
                message: 'Invalid phone number or password'
            });
        }

        const accessToken = generateAccessToken(user._id);

        res.cookie('accessToken', accessToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            maxAge: 7 * 24 * 60 * 60 * 1000,
            path: '/'
        });

        return res.status(200).json({
            message: 'Login successful',
            token: accessToken,
            user: {
                id: user._id,
                phone: user.phone
            }
        });

    } catch (error) {
        console.error('Login error:', error);

        return res.status(500).json({
            message: 'Login failed'
        });
    }
};


export const logoutUser = (req, res) => {
    res.clearCookie('accessToken', {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'strict',
        path: '/'
    });

    return res.status(200).json({
        message: 'Logged out successfully'
    });
};