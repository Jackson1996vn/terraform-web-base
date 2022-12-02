import dotenv from 'dotenv';
import express from 'express';
import { router } from './route';
import serverless from "serverless-http";
import bodyParser from "body-parser";
import multer from "multer";

const upload = multer({dest: "uploads/"});
dotenv.config();

const app = express();
app.use('/', router);
app.use(bodyParser.json());
app.use(upload.single("file"));

// @ts-ignore
let port: number = process.env.PORT | 5000

app.listen(port, () => {
    console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});

export const handler = serverless(app);