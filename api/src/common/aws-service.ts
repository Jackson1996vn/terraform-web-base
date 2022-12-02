import * as AWS from 'aws-sdk';

AWS.config.region = process.env.REGION;

var s3 = new AWS.S3();


export { s3 };