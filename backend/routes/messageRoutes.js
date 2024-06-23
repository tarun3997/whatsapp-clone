const SendMessage = require('../controller/ChatController/sendMessage')
const handelUserChatList = require('../controller/ChatController/userChatList')
const verifyToken = require('../middleware/verifyToken')

const messageRoutes = require('express').Router()

messageRoutes.post('/send-message', verifyToken,SendMessage)
messageRoutes.get('/user-messages', verifyToken,handelUserChatList)

module.exports = messageRoutes