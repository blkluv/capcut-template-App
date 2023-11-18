import prisma from "@/lib/prisma";
import { NextApiRequest, NextApiResponse } from "next";
import { z } from "zod";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "PUT") {
    try {
      const { id, name, username } = req.body;

      //zod validation for name
      let validName;
      if (name) {
        const nameSchema = z
          .string()
          .min(1, "Name must be longer than 1 character")
          .max(30, "Name cannot exceed thirty characters");
        validName = nameSchema.parse(name);
      }

      //zod validation for username
      let validUsername;
      if (username) {
        const usernameSchema = z
          .string()
          .min(1, "Username must be longer than 1 character")
          .max(30, "Username cannot exceed thirty characters")
          .regex(/^\S*$/g, {
            message: "Username cannot contain spaces",
          });
        validUsername = usernameSchema.parse(username);
      }

      const updatedUser = await prisma.user.update({
        where: {
          id: id,
        },
        data: {
          name: validName,
          username: validUsername,
        },
      });
      res.status(200).json({
        message: "user updated successfully",
        user: updatedUser,
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
