async function SendMessage(req,res){
    try {
        const claim = req.claim;

        const {text , receiverId} = req.body;
        const message = await global.prisma.message.create({
            data:{
                text: text,
                senderId: claim.id,
                receiverId: receiverId
            }
        })
        console.log(message)
    } catch (e) {
        console.error("Error saving message to database:", e);
    }
}

module.exports = SendMessage