
import jwt from 'jsonwebtoken';
import User from '../models/userModel.js';

export const protect = async (req, res, next) => {
    try {
        // Get JWT from HTTP-only cookie
        const token = req.cookies?.accessToken;

        if (!token) {
            return res.status(401).json({
                success: false,
                message: 'Authentication required. Please login.'
            });
        }

        // Verify JWT
        const decoded = jwt.verify(
            token,
            process.env.JWT_SECRET
        );

        // Find authenticated user
        const user = await User.findById(decoded.userId)
            .select('-password');

        if (!user) {
            return res.status(401).json({
                success: false,
                message: 'User not found'
            });
        }

        // Attach user to request
        req.user = user;

        next();

    } catch (error) {
        console.error('Authentication error:', error.message);

        return res.status(401).json({
            success: false,
            message: 'Invalid or expired authentication token'
        });
    }
};
