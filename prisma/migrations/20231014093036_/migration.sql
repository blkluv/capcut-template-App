/*
  Warnings:

  - A unique constraint covering the columns `[publicAddress]` on the table `User` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Post" ADD COLUMN     "authorPublicAddress" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "User_publicAddress_key" ON "User"("publicAddress");

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_authorPublicAddress_fkey" FOREIGN KEY ("authorPublicAddress") REFERENCES "User"("publicAddress") ON DELETE SET NULL ON UPDATE CASCADE;
