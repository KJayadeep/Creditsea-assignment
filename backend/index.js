import 'dotenv/config';
import path from "path";
import { fileURLToPath } from "url";
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import dbConnect from "./config/db.js";
import authRoutes from "./routes/authRoutes.js";
import userRoutes from "./routes/userRoutes.js";
import loanRoutes from './routes/loanRoutes.js';
import paymentRoutes from "./routes/paymentRoutes.js";
import cookieParser from "cookie-parser";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
dotenv.config({ path: path.resolve(__dirname, ".env") });


const app = express();

app.use(
  cors({
    origin: (origin, callback) => {
      // allow any localhost port during development (Flutter web picks a random port)
      if (!origin || /^http:\/\/localhost:\d+$/.test(origin)) {
        callback(null, true);
      } else {
        callback(new Error("Not allowed by CORS"));
      }
    },
    credentials: true,
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use(express.json());
app.use(cookieParser());


app.get("/", (req, res) => {
  res.send("Hello, World!");
});

app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);
app.use('/api/loans', loanRoutes);
app.use("/api/payments", paymentRoutes);

const PORT = process.env.PORT;

app.listen(PORT, async () => {
    await dbConnect();
  console.log(`Creditsea is running on port ${PORT}`);
});