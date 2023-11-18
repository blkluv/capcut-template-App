import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "DELETE") {
    try {
      const { userId, unfolloweeId } = req.body;

      //check if follow exists first
      const existingFollow = await prisma.follow.findFirst({
        where: {
          followerId: userId,
          followeeId: unfolloweeId,
        },
      });

      if (!existingFollow) {
        res.status(400).json({ message: "Already not following" });
      } else {
        const newFollow = await prisma.follow.delete({
          where: {
            id: existingFollow.id,
          },
        });

        res.status(200).json({ message: "Unfollowed successfully." });
      }
    } catch (error) {
      console.log(error);
      res.status(400).json({ message: "Error following" });
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}
