import {BaseController} from "./base-controller";
import { processUploadFile } from "../services/upload-service";
import * as express from "express";

class UploadController extends BaseController {
  public async index(req: express.Request, res: express.Response) {
    const location: string = await processUploadFile(req);
    return super.jsonSuccessResponse(res, {location: location});
  }
}

export = new UploadController();