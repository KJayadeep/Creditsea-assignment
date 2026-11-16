import express from 'express';
import {
    updateProfile,
    getProfile,
    verifyPAN,
    verifyEmail,
    verifyAadhaar
} from '../controllers/userController.js';

import { protect } from '../middleware/authMiddleware.js';

const router = express.Router();

router.put('/profile', protect, updateProfile);
router.get('/profile', protect, getProfile);
router.put('/verify-email', protect, verifyEmail);
router.put('/verify-pan', protect, verifyPAN);
router.put('/verify-aadhaar', protect, verifyAadhaar);

export default router;
