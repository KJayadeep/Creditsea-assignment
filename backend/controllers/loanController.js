import Loan from '../models/loanModel.js';
import { randomInt } from 'crypto';
import { checkLoanEligibility, VALID_LOAN_PURPOSES } from '../utils/loanEligibility.js';

export const createLoan = async (req, res) => {
    try {
        const {
            principalAmount,
            tenure,
            purpose
        } = req.body;

        if (
            !Number.isFinite(principalAmount) ||
            !Number.isFinite(tenure) ||
            typeof purpose !== 'string'
        ) {
            return res.status(400).json({
                success: false,
                message: 'Invalid loan details'
            });
        }

        if (principalAmount < 5000 || principalAmount > 100000) {
            return res.status(400).json({
                success: false,
                message: 'Loan amount must be between 5000 and 100000'
            });
        }

        if (!Number.isInteger(tenure) || tenure < 20 || tenure > 45) {
            return res.status(400).json({
                success: false,
                message: 'Tenure must be between 20 and 45 days'
            });
        }

        if (!VALID_LOAN_PURPOSES.includes(purpose)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid loan purpose'
            });
        }

        // Check comprehensive loan eligibility
        const eligibility = await checkLoanEligibility(
            req.user,
            { principalAmount, tenure, purpose }
        );

        if (!eligibility.eligible) {
            return res.status(403).json({
                success: false,
                message: `You are not eligible for this loan: ${eligibility.reasons.join('; ')}`,
                eligibility
            });
        }

        const interestAmount = Math.round(principalAmount * 0.01 * tenure * 100) / 100;
        const processingFee = Math.round(principalAmount * 0.10 * 100) / 100;
        const totalPayable = Math.round((principalAmount + interestAmount + processingFee) * 100) / 100;

        const applicationNumber = `CS${Date.now()}${randomInt(100, 1000)}`;

        const loan = await Loan.create({
            user: req.user._id,
            applicationNumber,
            principalAmount,
            tenure,
            purpose,
            interestAmount,
            processingFee,
            totalPayable
        });

        return res.status(201).json({
            success: true,
            message: 'Loan application submitted successfully',
            loan
        });

    } catch (error) {
        console.error('Create loan error:', error);

        return res.status(500).json({
            success: false,
            message: 'Failed to create loan application'
        });
    }
};

export const calculateLoanOffer = async (req, res) => {
    try {
        const { principalAmount, tenure, purpose } = req.body;

        if (
            !Number.isFinite(principalAmount) ||
            !Number.isFinite(tenure) ||
            typeof purpose !== 'string'
        ) {
            return res.status(400).json({
                success: false,
                message: 'Invalid loan details'
            });
        }

        if (principalAmount < 5000 || principalAmount > 100000) {
            return res.status(400).json({
                success: false,
                message: 'Loan amount must be between 5000 and 100000'
            });
        }

        const tenureInt = Math.round(tenure);
        if (tenureInt < 20 || tenureInt > 45) {
            return res.status(400).json({
                success: false,
                message: 'Tenure must be between 20 and 45 days'
            });
        }

        if (!VALID_LOAN_PURPOSES.includes(purpose)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid loan purpose'
            });
        }

        // Check loan eligibility
        const eligibility = await checkLoanEligibility(
            req.user,
            { principalAmount, tenure: tenureInt, purpose }
        );

        if (!eligibility.eligible) {
            return res.status(403).json({
                success: false,
                message: `Eligibility check failed: ${eligibility.reasons.join('; ')}`,
                eligibility
            });
        }

        const interestAmount = Math.round(principalAmount * 0.01 * tenureInt * 100) / 100;
        const processingFee = Math.round(principalAmount * 0.10 * 100) / 100;
        const totalPayable = Math.round((principalAmount + interestAmount + processingFee) * 100) / 100;

        return res.status(200).json({
            success: true,
            offer: {
                principalAmount,
                tenure: tenureInt,
                purpose,
                interestAmount,
                processingFee,
                totalPayable
            },
            eligibility
        });

    } catch (error) {
        console.error('Calculate offer error:', error);

        return res.status(500).json({
            success: false,
            message: 'Failed to calculate loan offer'
        });
    }
};

export const getMyLoans = async (req, res) => {
    try {
        const loans = await Loan.find({
            user: req.user._id
        }).sort({ createdAt: -1 });

        return res.status(200).json({
            success: true,
            loans
        });

    } catch (error) {
        console.error('Fetch loans error:', error);

        return res.status(500).json({
            success: false,
            message: 'Failed to fetch loan applications'
        });
    }
};

export const updateLoanStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;

        const validStatuses = [
            'Submitted',
            'Under Review',
            'Approved',
            'Rejected',
            'Disbursed',
            'Repaid'
        ];

        if (!validStatuses.includes(status)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid loan status'
            });
        }

        const loan = await Loan.findOneAndUpdate(
            { _id: id, user: req.user._id },
            { $set: { status } },
            { new: true }
        );

        if (!loan) {
            return res.status(404).json({
                success: false,
                message: 'Loan application not found'
            });
        }

        return res.status(200).json({
            success: true,
            message: `Loan status updated to ${status}`,
            loan
        });

    } catch (error) {
        console.error('Update loan status error:', error);

        return res.status(500).json({
            success: false,
            message: 'Failed to update loan status'
        });
    }
};
