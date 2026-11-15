import mongoose from "mongoose";

const userSchema = mongoose.Schema(
    {
        phone:{
            type: String,
            required: true,
            unique: true,
            trim: true
        },
        password:{
            type: String,
            required: true,
        },
        firstName:{ 
            type: String,
            trim: true,
            default: ""
        },
        lastName:{
            type: String,
            trim: true,
            default: ""
        },
        dateOfBirth:{
            type: Date,
            default: null
        },
        gender:{
            type: String,
            enum: ["Male", "Female", "Other"],
            default: null
        },
        maritalStatus:{
            type: String,
            enum: ["Single", "Married", "Divorced", "Widowed"],
            default: null
        },
        email:{
            type: String,
            lowercase: true,
            trim: true,
            default: ""
        },
        emailVerified:{
            type: Boolean,
            default: false
        },
        panNumber:{
            type: String,
            trim: true,
            default: ""
        },
        panVerified:{
            type: Boolean,
            default: false
        }
    },
    {timestamps: true}
)

const User = mongoose.model("User", userSchema);

export default User;