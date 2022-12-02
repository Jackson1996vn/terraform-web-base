import * as express from "express";

export abstract class BaseController {

  public jsonResponse(
    res: express.Response, code: number, message: string
  ) {
    return res.status(code).json({ message })
  }
  public jsonSuccessResponse(
    res: express.Response, data: object, metadata: object = []
  ) {
    return res.status(200).json({
      message: "Success",
      data: data,
      metadata: metadata
    })
  }

  public ok<T>(res: express.Response, dto?: T) {
    if (!!dto) {
      res.type('application/json');
      return res.status(200).json(dto);
    } else {
      return res.sendStatus(200);
    }
  }

  public created(res: express.Response) {
    return res.sendStatus(201);
  }

  public badRequest(res: express.Response, message?: string) {
    return this.jsonResponse(res, 400, message ? message : 'Unauthorized');
  }

  public unauthorized(res: express.Response, message?: string) {
    return this.jsonResponse(res, 401, message ? message : 'Unauthorized');
  }

  public paymentRequired(res: express.Response, message?: string) {
    return this.jsonResponse(res, 402, message ? message : 'Payment required');
  }

  public forbidden(res: express.Response, message?: string) {
    return this.jsonResponse(res, 403, message ? message : 'Forbidden');
  }

  public notFound(res: express.Response, message?: string) {
    return this.jsonResponse(res, 404, message ? message : 'Not found');
  }

  public conflict(res: express.Response, message?: string) {
    return this.jsonResponse(res, 409, message ? message : 'Conflict');
  }

  public tooMany(res: express.Response, message?: string) {
    return this.jsonResponse(res, 429, message ? message : 'Too many requests');
  }

  public todo(res: express.Response) {
    return this.jsonResponse(res, 400, 'TODO');
  }

  public fail(res: express.Response, error: Error | string) {
    console.log(error);
    return res.status(500).json({
      message: error.toString()
    })
  }
}