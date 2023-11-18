-- DropForeignKey
ALTER TABLE "Post" DROP CONSTRAINT "Post_authorUsername_fkey";

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_authorUsername_fkey" FOREIGN KEY ("authorUsername") REFERENCES "User"("username") ON DELETE SET NULL ON UPDATE CASCADE;
