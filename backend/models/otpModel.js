import mongoose from "mongoose";

const otpSchema = mongoose.Schema(
    {
        phone:{
            type: String,
            required: true,
            unique: true,
        },
        otpHash:{
            type: String,
            required: true,
        },
        expiresAt:{
            type: Date,
            required: true,
            index: { expires: 0 } 
        },
        verified:{
            type: Boolean,
            default: false
        },
        attempts:{
            type: Number,
            default: 0
        }
    },
    {
        timestamps: true
    }
)

const OTP = mongoose.model("OTP", otpSchema);

export default OTP;