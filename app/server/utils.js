
const redis = require('redis');
const util = require('util');

exports.ROLE_ADMIN = 'admin';
exports.ROLE_DOCTOR = 'doctor';
exports.ROLE_PATIENT = 'patient';

exports.CHANGE_TMP_PASSWORD = 'CHANGE_TMP_PASSWORD';

exports.getMessage = function(isError, message, id = '', password = '') {
  if (isError) {
    return {error: message};
  } else {
    return {success: message, id: id, password: password};
  }
};


exports.validateRole = async function(roles, reqRole, res) {
  if (!reqRole || !roles || reqRole.length === 0 || roles.length === 0 || !roles.includes(reqRole)) {
    // user's role is not authorized
    return res.sendStatus(401).json({message: 'Unauthorized Role'});
  }
};

exports.capitalize = function(s) {
  if (typeof s !== 'string') return '';
  return s.charAt(0).toUpperCase() + s.slice(1);
};


exports.createRedisClient = async function(hospitalId) {
  // TODO: Handle using config file
  let redisPassword;
  if (hospitalId === 1) {
    redisUrl = 'redis://127.0.0.1:6379';
    redisPassword = 'hosp1coep';
  } else if (hospitalId === 2) {
    redisUrl = 'redis://127.0.0.1:6380';
    redisPassword = 'hosp2coep';
  } else if (hospitalId === 3) {
    redisUrl = 'redis://127.0.0.1:6381';
    redisPassword = 'hosp3coep';
  }
  const redisClient = redis.createClient(redisUrl);
  redisClient.AUTH(redisPassword);
  // NOTE: Node Redis currently doesn't natively support promises
  // Util node package to promisify the get function of the client redis
  redisClient.get = util.promisify(redisClient.get);
  return redisClient;
};
