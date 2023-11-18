import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "DELETE") {
    try {
      const { password } = req.body;
      if (password !== process.env.ADMIN_PASSWORD) {
        return res.status(401).json({ message: "Invalid password" });
      }
      //delete everything
      const users = await prisma.user.findMany();

      for (const user of users) {
        // 2. Delete related records
        await prisma.post.deleteMany({
          where: { authorUsername: user.username },
        });

        await prisma.like.deleteMany({
          where: { authorId: user.id },
        });

        await prisma.follow.deleteMany({
          where: { followerId: user.id },
        });
        await prisma.follow.deleteMany({
          where: { followeeId: user.id },
        });

        // 3. Delete the user record
        await prisma.user.delete({
          where: { id: user.id },
        });
      }

      res.status(200).json({ message: "Deleted everything successfully." });
    } catch (error) {
      console.log(error);
      res.status(400).json({ message: "Error deleting follows" });
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}
