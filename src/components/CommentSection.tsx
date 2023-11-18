import PostComment from "@/components/PostComment";
import Comments from "@/components/Comments";

export default function CommentSection() {
  return (
    <div>
      <div className="">
        <PostComment />
      </div>
      <div>
        <Comments />
      </div>
    </div>
  );
}
