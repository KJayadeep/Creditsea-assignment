import Razorpay from "razorpay";

let cachedInstance = null;

export const getRazorpayInstance = () => {
  const key_id = process.env.RAZORPAY_KEY_ID?.trim();
  const key_secret = process.env.RAZORPAY_KEY_SECRET?.trim();

  if (!key_id || !key_secret) {
    console.warn(
      "[Razorpay Warning] Missing RAZORPAY_KEY_ID or RAZORPAY_KEY_SECRET in environment variables"
    );
  }

  if (!cachedInstance) {
    cachedInstance = new Razorpay({
      key_id: key_id || "placeholder_key",
      key_secret: key_secret || "placeholder_secret",
    });
  }

  return cachedInstance;
};

const instance = new Proxy(
  {},
  {
    get: (target, prop) => {
      const razorpay = getRazorpayInstance();
      const val = razorpay[prop];
      return typeof val === "function" ? val.bind(razorpay) : val;
    },
  }
);

export default instance;
