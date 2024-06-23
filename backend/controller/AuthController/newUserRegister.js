require("dotenv").config();
const jwt = require("jsonwebtoken");
async function handelUserRegister(req, res) {
  try {
    const { name, number } = req.body;
    const profileImageUrl = req.file?.filename;
    let user = await global.prisma.user.findUnique({
      where: {
        phoneNumber: number,
      },
    });
    // console.log(req)
    if (user) {
      user = await global.prisma.user.update({
        where: {
          phoneNumber: number,
        },
        data: {
          name,
          profileImageUrl,
        },
      });
    } else {
      user = await global.prisma.user.create({
        data: {
          phoneNumber: number,
          name: name,
          profileImageUrl: profileImageUrl,
        },
      });
    }
    const token = jwt.sign({ id: user.id }, process.env.ACCESS_TOKEN_SECRET);
    // console.log(token)
    res.status(200).json({ user, token });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: "Failed to insert user" });
  }
}

module.exports = handelUserRegister;
