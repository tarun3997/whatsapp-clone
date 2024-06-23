const jwt = require('jsonwebtoken')
require('dotenv').config()

async function handelUserlist(req, res){
    try{
        const claim = req.claim;
        const users = await global.prisma.user.findMany()
        const otherUser = users.filter(user => user.id !== claim.id);
        // console.log(users)
        res.status(200).json(otherUser)
    }catch(e){
        console.error(e);
        return res.status(500).json({ error: "Failed fetch user" });
    }
}

module.exports = handelUserlist