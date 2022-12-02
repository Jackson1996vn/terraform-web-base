import * as express from 'express'
import { s3 } from '../common/aws-service';
import { MulterRequest } from "../common/type";

export const processUploadFile = async (
  request: express.Request
): Promise<string> => {
  console.log(request.file);
  const bucketName: string = process.env.BUCKET_NAME!;
  const uploadFile = await s3.upload({
    Bucket: bucketName,
    Key: (request as MulterRequest).body.filename,
    Body: (request as MulterRequest).body
  }).promise();
  return uploadFile.Location;
}