
import User from '../models/userModel.js';

export const updateProfile = async (req, res) => {
    try {
        const {
            firstName,
            lastName,
            dateOfBirth,
            gender,
            maritalStatus
        } = req.body;

        // Validate required fields
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

        // Validate gender
        if (!['Male', 'Female', 'Other'].includes(gender)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid gender'
            });
        }

        // Validate marital status
        if (!['Single', 'Married', 'Other'].includes(maritalStatus)) {
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

        const user = await User.findByIdAndUpdate(
            req.user._id,
            {
                firstName: firstName.trim(),
                lastName: lastName.trim(),
                dateOfBirth: dob,
                gender,
                maritalStatus
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
