import { Router } from 'express'
import HealthCheckController from "./src/controller/health-check-controller";
import UploadController from './src/controller/upload-controller';

const router: Router = Router();

router.get('/health-check',  HealthCheckController.index);
router.post('/upload', UploadController.index);

export { router }