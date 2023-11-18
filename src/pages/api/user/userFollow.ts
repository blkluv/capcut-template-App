import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "POST") {
    try {
      const { userId, followeeId } = req.body;

      //check if follow exists first
      const existingFollow = await prisma.follow.findFirst({
        where: {
          followerId: userId,
          followeeId: followeeId,
        },
      });

      console.log("existing follow found...", existingFollow);
      if (existingFollow) {
        res.status(400).json({ message: "Already following" });
      } else {
        const newFollow = await prisma.follow.create({
          data: {
            followerId: userId,
            followeeId: followeeId,
          },
        });

        // Associate the new like with the user
        await prisma.user.update({
          where: { id: userId },
          data: {
            followees: {
              connect: {
                id: newFollow.id,
              },
            },
          },
        });

        // Associate the new like with the post
        await prisma.user.update({
          where: { id: followeeId },
          data: {
            followers: {
              connect: {
                id: newFollow.id,
              },
            },
          },
        });
        res.status(200).json({ message: "Followed successfully." });
      }
    } catch (error) {
      console.log(error);
      res.status(400).json({ message: "Error following" });
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}
