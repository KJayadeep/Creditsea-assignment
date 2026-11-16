import Loan from "../models/loanModel.js";

export const ACTIVE_LOAN_STATUSES = [
  "Submitted",
  "Under Review",
  "Approved",
  "Disbursed",
];

export const VALID_LOAN_PURPOSES = [
  "Medical Expenses",
  "Education",
  "Travel",
  "Shopping",
  "Emergency",
  "Business",
  "Other",
];

export const checkLoanEligibility = async (user, loanDetails = {}) => {
  const reasons = [];

  if (!user || !user._id) {
    return {
      eligible: false,
      reasons: ["User profile not found."],
    };
  }

  const { principalAmount, tenure, purpose } = loanDetails;

  // 1. Check profile completion (all required personal details)
  const requiredFields = [
    { key: "firstName", label: "first name" },
    { key: "lastName", label: "last name" },
    { key: "dateOfBirth", label: "date of birth" },
    { key: "gender", label: "gender" },
    { key: "maritalStatus", label: "marital status" },
    { key: "email", label: "email" },
  ];

  const missingFields = [];
  for (const field of requiredFields) {
    const val = user[field.key];
    if (val === undefined || val === null) {
      missingFields.push(field.label);
    } else if (typeof val === "string" && val.trim() === "") {
      missingFields.push(field.label);
    }
  }

  if (missingFields.length > 0) {
    reasons.push(
      `Complete your profile. Missing: ${missingFields.join(", ")}`
    );
  }

  // 2. Validate applicant age (Must be legal adult: 18 to 65 years old)
  if (user.dateOfBirth) {
    const dob = new Date(user.dateOfBirth);
    if (Number.isNaN(dob.getTime())) {
      reasons.push("Invalid date of birth.");
    } else {
      const today = new Date();
      let age = today.getFullYear() - dob.getFullYear();
      const monthDiff = today.getMonth() - dob.getMonth();
      if (
        monthDiff < 0 ||
        (monthDiff === 0 && today.getDate() < dob.getDate())
      ) {
        age--;
      }
      if (age < 18) {
        reasons.push("You must be at least 18 years old to be eligible for a loan.");
      } else if (age > 65) {
        reasons.push("Applicant age must be 65 years or younger.");
      }
    }
  }

  // 3. Check Email verification
  if (!user.emailVerified) {
    reasons.push("Email verification is required.");
  }

  // 4. Check PAN verification
  if (
    !user.panVerified ||
    !user.panNumber ||
    typeof user.panNumber !== "string" ||
    !/^[A-Z]{5}[0-9]{4}[A-Z]$/.test(user.panNumber.trim().toUpperCase())
  ) {
    reasons.push("Valid PAN verification is required.");
  }

  // 5. Check loan amount
  const numPrincipal = Number(principalAmount);
  if (
    !Number.isFinite(numPrincipal) ||
    numPrincipal < 5000 ||
    numPrincipal > 100000
  ) {
    reasons.push("Loan amount must be between ₹5,000 and ₹1,00,000.");
  }

  // 6. Check loan tenure
  const numTenure = Number(tenure);
  if (
    !Number.isInteger(numTenure) ||
    numTenure < 20 ||
    numTenure > 45
  ) {
    reasons.push("Loan tenure must be between 20 and 45 days.");
  }

  // 7. Check loan purpose (if supplied in loan details)
  if (purpose !== undefined && !VALID_LOAN_PURPOSES.includes(purpose)) {
    reasons.push("Invalid loan purpose.");
  }

  // 8. Check existing active loan application
  const existingLoan = await Loan.findOne({
    user: user._id,
    status: { $in: ACTIVE_LOAN_STATUSES },
  });

  if (existingLoan) {
    reasons.push("You already have an active loan application.");
  }

  return {
    eligible: reasons.length === 0,
    reasons,
  };
};
