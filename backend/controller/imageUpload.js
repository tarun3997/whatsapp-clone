const multer = require('multer');
const User = require('../model/userModel');



const imageUpload = (app) => {
    const Storage = multer.diskStorage({
        destination: "./uploads",
        filename: (req, file, cb) => {
            cb(null, Date.now() + file.originalname);
        }
    });

    const profileUpload = multer({
        storage: Storage
    })

    app.post('/upload', profileUpload.single("profileImage"),async (req, res) =>{
        console.log(req.body);
        console.log(req.file);
        try{
            const { uid, name, number } = req.body;
            const profileImageUrl = `E:/Tarun Document/WhatsApp Clone/backend/uploads/${req.file.filename}`;
            await User.updateOne({ uid }, { $set: { profileImageUrl, name, number } });
            res.status(200).json({ message: 'Image uploaded successfully' });

        }catch(e){
            console.error(e);
            res.status(500).json({ message: 'Internal Server Error' });
        }
    })
}

module.exports = imageUpload;