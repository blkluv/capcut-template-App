import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "POST") {
    try {
      const { userId, take, skip }: any = req.body;

      const user = await prisma.user.findUnique({
        where: { id: userId },
        include: { followees: true },
      });

      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }
      const userFollowees = user.followees;

      let userFolloweesIdArr = [];
      if (userFollowees) {
        for (const userFollowee of userFollowees) {
          userFolloweesIdArr.push(userFollowee.followeeId);
        }
      } else {
        return res
          .status(201)
          .json({ message: "Follow users to populate feed" });
      }

      let followeePosts = [];
      //get posts by users being followed
      followeePosts = await prisma.post.findMany({
        where: {
          authorUniqueId: {
            in: userFolloweesIdArr,
          },
        },
        include: { likes: true },
        take: take,
        skip: skip,
        orderBy: { createdAt: "desc" },
      });

      //get posts liked by the users being followed
      const followeeLikes = await prisma.like.findMany({
        where: {
          authorId: {
            in: userFolloweesIdArr,
          },
        },
        take: take,
        skip: skip,
      });

      let likedPosts = [];

      for (const likedPost of followeeLikes) {
        const post = await prisma.post.findUnique({
          where: { id: likedPost.postId },
          include: { likes: true },
        });
        const user = await prisma.user.findUnique({
          where: { id: likedPost.authorId },
        });
        const likedBy = likedPost.authorId;
        const likeCreatedAt = likedPost.createdAt;
        const likedByUsername = user?.username;
        let postWithCustomField = {
          ...post,
          likedBy,
          likeCreatedAt,
          likedByUsername,
        };
        likedPosts.push(postWithCustomField);
      }

      let leftIndex = 0;
      let rightIndex = 0;
      let mergedFeed = [];

      while (
        leftIndex < followeePosts.length &&
        rightIndex < likedPosts.length
      ) {
        const postDate = new Date(followeePosts[leftIndex].createdAt);
        const likeDate = new Date(likedPosts[rightIndex].likeCreatedAt);
        if (postDate < likeDate) {
          mergedFeed.push(followeePosts[leftIndex]);
          leftIndex++;
        }
        if (postDate > likeDate) {
          mergedFeed.push(likedPosts[rightIndex]);
          rightIndex++;
        }
      }

      mergedFeed = mergedFeed.concat(
        followeePosts.slice(leftIndex),
        likedPosts.slice(rightIndex)
      );

      // 4. Return the resulting feed in response
      res.status(200).json({
        mergedFeed,
      });
    } catch (error) {
      console.log(error);
      res.status(400).json({ message: "Error fetching comments" });
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}
