const handelChatUserList = require('../controller/UserController/chatUserList')
const handelUserlist = require('../controller/UserController/userlist')
const verifyToken = require('../middleware/verifyToken')

const router = require('express').Router()

router.get('/user-list', verifyToken,handelUserlist)
router.get('/chat-user-list', verifyToken,handelChatUserList)

module.exports = router