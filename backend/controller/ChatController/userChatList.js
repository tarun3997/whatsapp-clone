async function handelUserChatList(req, res){
    try{
        const claim = req.claim;
        const { receivedId } = req.params;
         const chatList = await global.prisma.message.findMany({
            where:{
                OR:[
                    {senderId: claim.id, receivedId: receivedId},
                    {senderId: receivedId, receiverId: claim.id }
                ]
            },
            orderBy:{
                timestamp: 'asc'
            },
         })
         const formattedMessages = chatList.map(message =>({
            id: message.id,
            text: message.text,
            senderId: message.senderId,
            receiverId: message.receiverId,
            createdAt: message.timestamp,
            
            sendBy: message.senderId === claim.id ? true : false
         }));
        //  console.log(formattedMessages)
        res.status(200).send(formattedMessages);
    }catch(e){
        console.error("Error fetching user chat:", e);
        res.status(500).send({ message: 'Internal server error' });
    }
}

module.exports = handelUserChatList