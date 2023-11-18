import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "GET") {
    try {
      const { email }: any = req.query;

      if (!email) {
        res.status(400).json({ message: "invalid email" });
      }

      const existingUser = await prisma.user.findFirst({
        where: {
          email: email,
        },
      });
      console.log("existinguser is ...", existingUser);
      if (existingUser) {
        res.status(200).json({
          exists: true,
        });
      } else {
        res.status(200).json({
          exists: false,
        });
      }
    } catch (error) {
      console.log(error);
      res.status(400).json({ message: "Error finding user details" });
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}
