/*
  Warnings:

  - Made the column `authorId` on table `Like` required. This step will fail if there are existing NULL values in that column.
  - Made the column `postId` on table `Like` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "Like" DROP CONSTRAINT "Like_authorId_fkey";

-- DropForeignKey
ALTER TABLE "Like" DROP CONSTRAINT "Like_postId_fkey";

-- AlterTable
ALTER TABLE "Like" ALTER COLUMN "authorId" SET NOT NULL,
ALTER COLUMN "postId" SET NOT NULL;

-- AddForeignKey
ALTER TABLE "Like" ADD CONSTRAINT "Like_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Like" ADD CONSTRAINT "Like_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
