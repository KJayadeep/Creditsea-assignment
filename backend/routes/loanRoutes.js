import express from 'express';
import { createLoan, calculateLoanOffer, getMyLoans, updateLoanStatus } from '../controllers/loanController.js';
import { protect } from '../middleware/authMiddleware.js';

const router = express.Router();

router.post('/accept', protect, createLoan);
router.post('/calculate', protect, calculateLoanOffer);
router.get('/my-loans', protect, getMyLoans);
router.patch('/:id/status', protect, updateLoanStatus);

export default router;