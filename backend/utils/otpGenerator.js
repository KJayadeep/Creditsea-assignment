import crypto from 'crypto';


export const generateOTP = (len) => {

    const min = 10 ** (len - 1);
    const max = 10 ** len;
    const otp = crypto.randomInt(min, max).toString();
    return otp;
}
