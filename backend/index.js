const express = require('express');
var http = require('http');
const cors = require('cors');
const app = express();

const port = 5000;
var server = http.createServer(app);


app.use(express.json());
app.use(cors());



io.on("connection",(socket) =>{
    console.log("Connected", socket.id);

    socket.on('joinChat', (userId) => {
        socket.join(userId);
    });
    socket.on('sendMessage', async ({ sender, receiver, text}) => {
        const newMessage = new Message({sender, receiver, text});
        await newMessage.save();
        consol.log(newMessage)

        io.to(receiver).emit('receiveMessage', newMessage);
    })
    socket.on("disconnect",() =>{
        console.log('User disconnected: ', socket.id);
    })
});

server.listen(port,'0.0.0.0',()=>{
    console.log("Server started");
})