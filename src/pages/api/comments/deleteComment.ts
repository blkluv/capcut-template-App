import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";
import { z } from "zod";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "PUT") {
    try {
      const { authorUsername, commentId } = req.body;

      // Create a new comment using Prisma
      const newComment = await prisma.post.update({
        where: {
          id: commentId,
          authorUsername: authorUsername,
        },
        data: {
          published: false,
        },
      });

      res.status(200).json({
        message: "comment removed successfully",
        user: newComment,
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        const errorMessage = error.errors[0].message;
        res.status(400).json({ message: errorMessage });
      } else {
        console.log(error);
        res.status(400).json({ message: "Error deleting comment" });
      }
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}
