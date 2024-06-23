async function handelChatUserList(req, res) {
  try {
    const claim = req.claim;
    const message = await global.prisma.message.findMany({
      where: {
        OR: [{ senderId: claim.id }, { receiverId: claim.id }],
      },
      select: {
        senderId: true,
        receiverId: true,
      },
    });
    const userIds = message.flatMap((message) => [
      message.senderId,
      message.receiverId,
    ]);
    const uniqueUserIds = [
        ...new Set(userIds.filter((id) => id !== claim.id)),
      ];
      const userList = await global.prisma.user.findMany({
        where:{
            id:{
                in: uniqueUserIds
            }
        }
      })
    //   console.log(userList)
      res.status(200).send(userList);
  } catch (e) {
    console.error("Error fetching user count:", e);
    res.status(500).send({ message: "Internal server error" });
  }
}

module.exports = handelChatUserList
