import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";
import { z } from "zod";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "POST") {
    try {
      const {
        comment,
        contentLink,
        authorUsername,
        authorPublicAddress,
        authorId,
      } = req.body;

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
        newComment = await prisma.post.create({
          data: {
            comment: validComment,
            contentLink: contentLink,
            authorUsername: authorUsername,
            authorPublicAddress: authorPublicAddress,
            authorUniqueId: authorId,
          },
          include: { likes: true },
        });
      } else {
        res.status(400).json({ message: "Invalid comment" });
      }

      res.status(201).json({
        message: "Comment created successfully",
        comment: newComment,
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        const errorMessage = error.errors[0].message;
        res.status(400).json({ message: errorMessage });
      } else {
        console.log(error);
        res.status(500).json({ message: "Internal server error" });
      }
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}
