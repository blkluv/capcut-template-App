import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";
import { z } from "zod";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "PUT") {
    try {
      const { authorUsername, commentId, comment, contentLink } = req.body;

      //zod validation for name
      let validComment;
      if (comment) {
        const commentSchema = z
          .string()
          .min(1, "Name must be longer than 1 character")
          .max(300, "Name cannot exceed 300 characters");
        validComment = commentSchema.parse(comment);
      }

      let newComment;
      if (validComment) {
        // Create a new comment using Prisma
        newComment = await prisma.post.update({
          where: {
            id: commentId,
            authorUsername: authorUsername,
            contentLink: contentLink,
            published: true,
          },
          data: {
            comment: validComment,
            contentLink: contentLink,
            authorUsername: authorUsername,
          },
        });
      } else {
        res.status(400).json({ message: "Invalid comment" });
      }

      res.status(200).json({
        message: "comment updated successfully",
        user: newComment,
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        const errorMessage = error.errors[0].message;
        res.status(400).json({ message: errorMessage });
      } else {
        console.log(error);
        res.status(400).json({ message: "Error updating comment" });
      }
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}
