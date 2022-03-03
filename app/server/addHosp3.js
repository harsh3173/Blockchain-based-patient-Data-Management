
/* eslint-disable new-cap */
const {enrollAdminHosp3} = require('./enrollAdmin-Hospital3');
const redis = require('redis');

/**
 * @description enrol admin of hospital 3 in redis
 */
async function initRedis3() {
  redisUrl = 'redis://127.0.0.1:6381';
  redisPassword = 'hosp3coep';
  redisClient = redis.createClient(redisUrl);
  redisClient.AUTH(redisPassword);
  redisClient.SET('hosp3admin', redisPassword);
  console.log('Done');
  redisClient.QUIT();
  return;
}

/**
 * @description enrol admin of hospital 3
 */
async function main() {
  await enrollAdminHosp3();
  await initRedis3();
}

main();
