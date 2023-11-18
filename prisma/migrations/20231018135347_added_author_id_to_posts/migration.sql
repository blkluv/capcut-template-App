-- AlterTable
ALTER TABLE "Post" ADD COLUMN     "authorUniqueId" TEXT;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_authorUniqueId_fkey" FOREIGN KEY ("authorUniqueId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
