const { Server } = require("socket.io")
const jwt = require("jsonwebtoken");
require("dotenv").config();
function initializeSocket(server){
    const io = new Server(server)

    io.use((socket, next) => {
      const authToken = socket.handshake.query.authToken;
      try {
        const claims = jwt.verify(authToken, process.env.ACCESS_TOKEN_SECRET);
        if (!claims) {
          return next(new Error("Unauthorized"));
        }
        socket.authenticatedUserId = claims.id;
        next();
      } catch (err) {
          console.log(err)
        return next(new Error("Unauthorized"));
      }
    });
    
    io.on("connection", (socket) => {
      
      const senderId = socket.authenticatedUserId;
      console.log(senderId)
      socket.on('message',async (data) =>{
        // console.log(data);
        try {
          const message = await global.prisma.message.create({
            data:{
                text: data.message,
                senderId: senderId,
                receiverId: data.receiverId
            } 
        })
  
          // io.to(data.receiverId).emit('receive_message',message)
          socket.emit('receive_message',message)
          
        } catch (e) {
          console.error("Error saving message to database:", e);

        }
      })

      socket.on('disconnect',()=>{
        console.log('disconnected')
      })
    })
}

module.exports = initializeSocket