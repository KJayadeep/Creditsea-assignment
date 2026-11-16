import crypto from "crypto";
import razorpay from "../config/razorpay.js";
import Loan from "../models/loanModel.js";
import Payment from "../models/paymentModel.js";

export const createPaymentOrder = async (req, res) => {
  try {
    const { loanId } = req.body;

    if (!loanId) {
      return res.status(400).json({
        success: false,
        message: "Loan ID is required",
      });
    }

    const loan = await Loan.findOne({
      _id: loanId,
      user: req.user._id,
    });

    if (!loan) {
      return res.status(404).json({
        success: false,
        message: "Loan not found",
      });
    }

    if (loan.status === "Repaid") {
      return res.status(400).json({
        success: false,
        message: "This loan has already been repaid",
      });
    }

    if (loan.status === "Rejected") {
      return res.status(400).json({
        success: false,
        message: "Cannot repay a rejected loan application",
      });
    }

    const paidPayment = await Payment.findOne({
      loan: loan._id,
      user: req.user._id,
      status: "Paid",
    });

    if (paidPayment) {
      if (loan.status !== "Repaid") {
        loan.status = "Repaid";
        await loan.save();
      }

      return res.status(400).json({
        success: false,
        message: "This loan has already been repaid",
      });
    }

    const amount = Math.round((loan.totalPayable || 0) * 100);

    if (!Number.isSafeInteger(amount) || amount <= 0) {
      return res.status(400).json({
        success: false,
        message: "Invalid repayment amount",
      });
    }

    const keyId = process.env.RAZORPAY_KEY_ID?.trim();
    if (!keyId) {
      return res.status(500).json({
        success: false,
        message: "Razorpay payment gateway is not configured",
      });
    }

    const order = await razorpay.orders.create({
      amount,
      currency: "INR",
      receipt: `loan_${loan._id}_${Date.now()}`,
      notes: {
        loanId: loan._id.toString(),
        userId: req.user._id.toString(),
      },
    });

    const payment = await Payment.create({
      user: req.user._id,
      loan: loan._id,
      razorpayOrderId: order.id,
      amount: order.amount,
      currency: order.currency,
      status: "Created",
    });

    return res.status(201).json({
      success: true,
      message: "Payment order created successfully",
      paymentId: payment._id,
      keyId,
      order: {
        id: order.id,
        amount: order.amount,
        currency: order.currency,
      },
    });

  } catch (error) {
    console.error("Create payment order error:", error);

    return res.status(500).json({
      success: false,
      message: error?.error?.description || error.message || "Failed to create payment order",
    });
  }
};


// 2. Verify Razorpay payment
export const verifyPayment = async (req, res) => {
  try {
    const {
      razorpay_order_id,
      razorpay_payment_id,
      razorpay_signature,
    } = req.body;

    if (
      !razorpay_order_id ||
      !razorpay_payment_id ||
      !razorpay_signature
    ) {
      return res.status(400).json({
        success: false,
        message: "Payment verification details are required",
      });
    }

    // Find payment belonging to authenticated user
    const payment = await Payment.findOne({
      razorpayOrderId: razorpay_order_id,
      user: req.user._id,
    });

    if (!payment) {
      return res.status(404).json({
        success: false,
        message: "Payment order not found",
      });
    }

    // Prevent duplicate verification
    if (payment.status === "Paid") {
      const loan = await Loan.findById(payment.loan);
      return res.status(200).json({
        success: true,
        message: "Payment already verified",
        payment,
        loan,
      });
    }

    const keySecret = process.env.RAZORPAY_KEY_SECRET?.trim();
    if (!keySecret) {
      return res.status(500).json({
        success: false,
        message: "Payment gateway secret not configured",
      });
    }

    // Verify Razorpay signature using HMAC SHA256
    const expectedSignature = crypto
      .createHmac("sha256", keySecret)
      .update(`${razorpay_order_id}|${razorpay_payment_id}`)
      .digest("hex");

    const received = Buffer.from(razorpay_signature.trim(), "utf8");
    const expected = Buffer.from(expectedSignature, "utf8");

    if (
      received.length !== expected.length ||
      !crypto.timingSafeEqual(received, expected)
    ) {
      payment.status = "Failed";
      await payment.save();

      return res.status(400).json({
        success: false,
        message: "Invalid payment signature",
      });
    }

    // Attempt to verify and capture directly with Razorpay
    try {
      const razorpayPayment = await razorpay.payments.fetch(razorpay_payment_id);

      if (razorpayPayment.order_id && razorpayPayment.order_id !== razorpay_order_id) {
        return res.status(400).json({
          success: false,
          message: "Payment order mismatch",
        });
      }

      // If payment is authorized but not yet captured, capture it
      if (razorpayPayment.status === "authorized") {
        await razorpay.payments.capture(
          razorpay_payment_id,
          payment.amount,
          payment.currency
        );
      }
    } catch (fetchErr) {
      console.warn("Razorpay payment fetch/capture warning:", fetchErr.message);
      // Cryptographic HMAC signature was already validated above
    }

    // Mark payment as successful
    payment.razorpayPaymentId = razorpay_payment_id;
    payment.status = "Paid";
    payment.paidAt = new Date();
    await payment.save();

    // Mark loan as fully repaid
    const loan = await Loan.findOneAndUpdate(
      {
        _id: payment.loan,
        user: req.user._id,
      },
      {
        $set: {
          status: "Repaid",
        },
      },
      {
        new: true,
      }
    );

    if (!loan) {
      console.error(
        "Payment captured but loan status was not updated:",
        payment.loan
      );

      return res.status(500).json({
        success: false,
        message: "Payment captured, but loan status update failed. Contact support.",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Loan repayment successful",
      payment,
      loan,
    });

  } catch (error) {
    console.error("Payment verification error:", error);

    return res.status(500).json({
      success: false,
      message: error?.message || "Payment verification failed",
    });
  }
};
