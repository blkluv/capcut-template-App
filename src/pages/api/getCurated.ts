import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "GET") {
    try {
      const { take, skip }: any = req.query;

      const takeInt = parseInt(take, 10);
      const skipInt = parseInt(skip, 10);

      // Get comments using Prisma
      const curatedLinks = await prisma.curatedLinks.findMany({
        take: takeInt,
        skip: skipInt,
      });

      res.status(200).json({
        curatedLinks,
      });
    } catch (error) {
      console.log(error);
      res.status(400).json({ message: "Error fetching links" });
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}
