const jwt = require('jsonwebtoken')
require('dotenv').config()

function verifyToken(req, res, next){
    const token = req.get('authToken')
    if (!token) {
        return res.status(401).json({ message: "Unauthorized: No token provided" });
    }
    try{
        const claim = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
        req.claim = claim
        next();
    }catch(e){
        return res.status(401).json({ message: "Unauthorized: Invalid token" });

    }
}

module.exports = verifyToken