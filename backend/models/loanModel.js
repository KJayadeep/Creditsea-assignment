
import mongoose from 'mongoose';

const loanSchema = new mongoose.Schema(
    {
        user: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            required: true
        },

        applicationNumber: {
            type: String,
            unique: true,
            required: true
        },

        principalAmount: {
            type: Number,
            required: true,
            min: 5000,
            max: 100000
        },

        tenure: {
            type: Number,
            required: true,
            min: 20,
            max: 45
        },

        purpose: {
            type: String,
            required: true,
            enum: [
                'Medical Expenses',
                'Education',
                'Travel',
                'Shopping',
                'Emergency',
                'Business',
                'Other'
            ]
        },

        interestRatePerDay: {
            type: Number,
            default: 1
        },

        interestAmount: {
            type: Number,
            required: true
        },

        processingFee: {
            type: Number,
            required: true
        },

        totalPayable: {
            type: Number,
            required: true
        },

        status: {
            type: String,
            enum: [
                'Submitted',
                'Under Review',
                'Approved',
                'Rejected',
                'Disbursed',
                'Repaid'
            ],
            default: 'Submitted'
        }
    },
    {
        timestamps: true
    }
);

const Loan = mongoose.model('Loan', loanSchema);

export default Loan;
