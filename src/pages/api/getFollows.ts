import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "GET") {
    try {
      const { userId }: any = req.query;

      const followingUsers = await prisma.follow.findMany({
        where: {
          followerId: userId, // Replace userId with the ID of the user whose followers you want to retrieve
        },
        select: {
          followee: true, // Include the user being followed in the result
        },
      });
      const followerUsers = await prisma.follow.findMany({
        where: {
          followeeId: userId, // Replace userId with the ID of the user whose followers you want to retrieve
        },
        select: {
          follower: true, // Include the user being followed in the result
        },
      });
      res.status(200).json({
        followers: followerUsers,
        following: followingUsers,
      });
    } catch (error) {
      console.log(error);
      res.status(400).json({ message: "Error finding follow details" });
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}
