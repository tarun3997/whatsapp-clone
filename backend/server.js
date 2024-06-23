const express = require('express');
const bodyParser = require('body-parser');
const http = require('http');
const authRouter = require('./routes/authRoutes');
const db = require('./db');
const userRouter = require('./routes/userRoutes');
const verifyToken = require('./middleware/verifyToken');
const messageRoutes = require('./routes/messageRoutes');
const { Server } = require('socket.io');
const initializeSocket = require('./controller/ChatController/liveMessaging');

const app = express();
const server = http.createServer(app)
app.use('/uploads', express.static('uploads'));

initializeSocket(server)
app.use(bodyParser.json());
app.use(express.urlencoded({extended: false}));                                                             
app.use(express.json())
app.use('/auth', authRouter)
app.use('/user/api', userRouter)
app.use('/message', messageRoutes)
const port = process.env.PORT || 3000;

server.listen(port, () =>{
    console.log(`Server is running on port ${port}`)
})