import User from '../models/userModel.js';

export const updateProfile = async (req, res) => {
    try {
        const {
            firstName,
            lastName,
            dateOfBirth,
            gender,
            maritalStatus,
            email
        } = req.body;

        if (
            !firstName?.trim() ||
            !lastName?.trim() ||
            !dateOfBirth ||
            !gender ||
            !maritalStatus
        ) {
            return res.status(400).json({
                success: false,
                message: 'All personal details are required'
            });
        }

        if (!['Male', 'Female', 'Other'].includes(gender)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid gender'
            });
        }

        if (!['Single', 'Married', 'Divorced', 'Widowed', 'Other'].includes(maritalStatus)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid marital status'
            });
        }

        const dob = new Date(dateOfBirth);

        if (
            Number.isNaN(dob.getTime()) ||
            dob >= new Date() ||
            dob < new Date('1900-01-01')
        ) {
            return res.status(400).json({
                success: false,
                message: 'Invalid date of birth'
            });
        }

        const updateData = {
            firstName: firstName.trim(),
            lastName: lastName.trim(),
            dateOfBirth: dob,
            gender,
            maritalStatus
        };

        if (email && typeof email === 'string' && email.trim()) {
            const trimmedEmail = email.trim().toLowerCase();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (emailRegex.test(trimmedEmail)) {
                updateData.email = trimmedEmail;
            }
        }

        const user = await User.findByIdAndUpdate(
            req.user._id,
            updateData,
            {
                new: true,
                runValidators: true
            }
        ).select('-password');

        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'User not found'
            });
        }

        return res.status(200).json({
            success: true,
            message: 'Personal details saved successfully',
            user
        });

    } catch (error) {
        console.error('Update profile error:', error);

        return res.status(500).json({
            success: false,
            message: 'Failed to update personal details'
        });
    }
};

// Verify user email
export const verifyEmail = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email || typeof email !== 'string') {
            return res.status(400).json({
                success: false,
                message: 'Email is required'
            });
        }

        const trimmedEmail = email.trim().toLowerCase();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailRegex.test(trimmedEmail)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid email address'
            });
        }

        const user = await User.findByIdAndUpdate(
            req.user._id,
            {
                email: trimmedEmail,
                emailVerified: true
            },
            {
                new: true,
                runValidators: true
            }
        ).select('-password');

        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'User not found'
            });
        }

        return res.status(200).json({
            success: true,
            message: 'Email verified successfully',
            user
        });

    } catch (error) {
        console.error('Email verification error:', error);

        return res.status(500).json({
            success: false,
            message: 'Failed to verify email'
        });
    }
};

// Get logged-in user's profile
export const getProfile = async (req, res) => {
    try {
        return res.status(200).json({
            success: true,
            user: req.user
        });

    } catch (error) {
        console.error('Get profile error:', error);

        return res.status(500).json({
            success: false,
            message: 'Failed to fetch profile'
        });
    }
};

export const verifyPAN = async (req, res) => {
    try {
        const { panNumber } = req.body;

        if (!panNumber || typeof panNumber !== 'string') {
            return res.status(400).json({
                success: false,
                message: 'PAN number is required'
            });
        }

        const pan = panNumber.trim().toUpperCase();

        if (!/^[A-Z]{5}[0-9]{4}[A-Z]$/.test(pan)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid PAN number'
            });
        }

        const user = await User.findByIdAndUpdate(
            req.user._id,
            {
                panNumber: pan,
                panVerified: true
            },
            {
                new: true,
                runValidators: true
            }
        ).select('-password');

        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'User not found'
            });
        }

        return res.status(200).json({
            success: true,
            message: 'PAN verification completed successfully',
            user
        });

    } catch (error) {
        console.error('PAN verification error:', error);

        return res.status(500).json({
            success: false,
            message: 'PAN verification failed'
        });
    }
};

export const verifyAadhaar = async (req, res) => {
    try {
        const { aadhaarNumber } = req.body;

        if (!aadhaarNumber || typeof aadhaarNumber !== 'string') {
            return res.status(400).json({
                success: false,
                message: 'Aadhaar number is required'
            });
        }

        const cleanedAadhaar = aadhaarNumber.replace(/\s+/g, '').trim();

        if (!/^\d{12}$/.test(cleanedAadhaar)) {
            return res.status(400).json({
                success: false,
                message: 'Enter a valid 12-digit Aadhaar number'
            });
        }

        const user = await User.findByIdAndUpdate(
            req.user._id,
            {
                aadhaarNumber: cleanedAadhaar,
                aadhaarVerified: true
            },
            {
                new: true,
                runValidators: true
            }
        ).select('-password');

        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'User not found'
            });
        }

        return res.status(200).json({
            success: true,
            message: 'Aadhaar e-KYC completed successfully',
            user
        });

    } catch (error) {
        console.error('Aadhaar verification error:', error);

        return res.status(500).json({
            success: false,
            message: 'Aadhaar verification failed'
        });
    }
};
