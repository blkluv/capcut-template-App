import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";
import { z } from "zod";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "GET") {
    try {
      const { baseURL }: any = req.query;
      // console.log("baseURL received in getComment endpoint is...", baseURL);

      // Get comments using Prisma
      const comments = await prisma.post.findMany({
        where: {
          published: true,
          contentLink: baseURL,
        },
        include: { likes: true },
        orderBy: {
          createdAt: "desc",
        },
      });

      res.status(200).json({
        comments,
      });
    } catch (error) {
      console.log(error);
      res.status(400).json({ message: "Error fetching comments" });
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}
