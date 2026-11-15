import express from 'express';

import {
    updateProfile,
    getProfile
} from '../controllers/userController.js';

import { protect } from '../middleware/authMiddleware.js';

const router = express.Router();

router.put('/profile', protect, updateProfile);
router.get('/profile', protect, getProfile);

export default router;