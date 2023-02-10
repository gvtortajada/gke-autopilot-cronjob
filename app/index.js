import { createLogger, format as _format, transports as _transports } from 'winston';
import { setTimeout } from 'timers/promises';

const logger = createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: _format.json(),
  transports: [
    new _transports.Console({format: _format.simple()})
  ],
});

logger.info('GKE cronjob - Starting');
logger.debug('GKE cronjob - Starting');
logger.info(`GKE cronjob - waiting for ${process.env.WAIT_TIME || 5000} millisec`);
logger.debug(`GKE cronjob - waiting for ${process.env.WAIT_TIME || 5000} millisec`);
await setTimeout(process.env.WAIT_TIME || 5000);
logger.info('GKE cronjob - Ending');
logger.debug('GKE cronjob - Ending');