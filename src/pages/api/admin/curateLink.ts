import {
  getYouTubeBaseUrl,
  getYouTubeShortsBaseUrl,
  getFacebookBaseUrl,
  getInstagramBaseUrl,
  getTwitterXBaseUrl,
} from "@/lib/getBaseUrl";

import { getYouTubeShortsContentId } from "@/lib/getContentId";

import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";
import { getSourceFromLinkPromisified } from "@/lib/getSourceFromLink";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "POST") {
    try {
      const { link, password } = req.body;
      if (password !== process.env.ADMIN_PASSWORD) {
        return res.status(401).json({ message: "Invalid password" });
      }
      console.log("link received is...", link);
      const baseURL = await getBaseURL(link);
      console.log(baseURL);
      const contentId = await getYouTubeShortsContentId(baseURL);

      const curatedLink = await prisma.curatedLinks.create({
        data: {
          rootUrl: baseURL,
          contentId: contentId,
        },
      });

      res.status(200).json({ message: "added link successfully", curatedLink });
    } catch (error) {
      console.log(error);
      res.status(500).json({ message: "Internal server error" });
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}

function getBaseURL(link: string): Promise<any> {
  return new Promise(async (resolve, reject) => {
    try {
      const linkSource = await getSourceFromLinkPromisified(link);
      console.log("link source is...", linkSource);
      let baseURL;

      if (linkSource === "YouTube") {
        console.log("getting base URL from YOUtube...");
        if (link.includes("youtube.com/shorts/")) {
          baseURL = await getYouTubeShortsBaseUrl(link);
        } else {
          baseURL = await getYouTubeBaseUrl(link);
        }
        console.log("baseURL extracted is...", baseURL);
      } else if (linkSource === "Twitter") {
        baseURL = await getTwitterXBaseUrl(link);
      } else if (linkSource === "Instagram") {
        baseURL = await getInstagramBaseUrl(link);
      } else if (linkSource === "Facebook") {
        baseURL = await getFacebookBaseUrl(link);
      }

      resolve(baseURL);
    } catch (error) {
      reject(null);
    }
  });
}
