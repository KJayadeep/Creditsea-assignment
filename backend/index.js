import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import dbConnect from "./config/db.js";
import authRoutes from "./routes/authRoutes.js";
import cookieParser from "cookie-parser";

dotenv.config();


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


const PORT = process.env.PORT;

app.listen(PORT, async () => {
    await dbConnect();
  console.log(`Creditsea is running on port ${PORT}`);
});