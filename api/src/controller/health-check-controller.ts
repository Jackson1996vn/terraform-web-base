import {BaseController} from "./base-controller";
import * as express from 'express'

class HealthCheckController extends BaseController {
    public index(req: express.Request, res: express.Response) {
        return super.jsonResponse(res, 200, 'It\'s work');
    }
}

export = new HealthCheckController();