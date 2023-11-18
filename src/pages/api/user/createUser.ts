import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";
import { z } from "zod";
import { generateRandomString } from "@/lib/generateRandomString";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "POST") {
    try {
      const { email, id, publicAddress } = req.body;

      const existingUser = await prisma.user.findFirst({
        where: {
          id: id,
          email: email,
        },
        include: { likes: true, followers: true, followees: true },
      });

      if (existingUser) {
        if (existingUser.username === null) {
          let name = email.split("@")[0];
          let username = name.concat(generateRandomString(6));
          await prisma.user.update({
            where: {
              id: existingUser.id,
            },
            data: {
              username: username,
            },
          });
        }
        return res
          .status(201)
          .json({ message: "user already exists", user: existingUser });
      }

      let name = email.split("@")[0];
      let username = name.concat(generateRandomString(6));

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

      // Create a new user using Prisma
      const newUser = await prisma.user.create({
        data: {
          id: id,
          email: email,
          name: validName,
          username: username,
          publicAddress: publicAddress,
        },
        include: { likes: true, followers: true, followees: true },
      });

      res.status(200).json({
        message: "User created successfully",
        user: newUser,
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
