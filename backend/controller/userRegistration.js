const multer = require('multer');

const userRegistration =(app) =>{
    const Storage = multer.diskStorage({
        destination: "./uploads",
        filename: (req, file, cb) => {
            cb(null, Date.now() + file.originalname);
        }
    });

    const profileUpload = multer({
        storage: Storage
    })

    app.post('/register', profileUpload.single("profileImage"),async (req, res) =>{
        try{
            const { name, number, uid } = req.body;
            const existingUser = await global.prisma.User.findOne({ number });
            const profileImageUrl = `/uploads/${req.file.filename}`;

            if(existingUser){
                await global.prisma.User.updateOne({ uid }, { $set: {name, profileImageUrl}});
                return res.status(400).json({message: 'User already exists'});
            }
            const newUser = new global.prisma.User({
                name,
                number,
                uid,
                profileImageUrl,
            });
            await newUser.save();
            res.status(201).json({message: 'User registration successfully'})
        }catch(error){
            console.error(error);
            res.status(500).json({message: 'Internal Server Error'})
        }
    }) 

   

} 

module.exports = userRegistration;