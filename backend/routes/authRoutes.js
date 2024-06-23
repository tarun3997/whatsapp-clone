const router = require('express').Router()
const multer = require('multer');
const handelUserRegister = require('../controller/AuthController/newUserRegister')

const Storage = multer.diskStorage({
    destination: "./uploads",
    filename: (req,file,cb) =>{
        cb(null, Date.now() + file.originalname);
    }
});

const upload = multer({ storage: Storage });

router.post('/register', upload.single('profileImage'), handelUserRegister)

module.exports = router