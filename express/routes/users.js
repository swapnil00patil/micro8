var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
  console.log('I ma here sss')
  res.send('respond with a resources locla dev s');
});

module.exports = router;
