import Searchbar from "@/components/Searchbar";
import ContentCard from "@/components/ContentCard";
import CommentSection from "@/components/CommentSection";
import { contentState } from "@/store/atoms/contentState";
import { useRecoilValue } from "recoil";
import CuratedLinks from "./CuratedLinks";

export default function LandingPage() {
  const content = useRecoilValue(contentState);

  return (
    <div className="flex">
      <div className="w-1/5 hidden md:block"></div>
      <div className="md:w-3/5 max-w-full">
        <div className="flex justify-center">
          <Searchbar />
        </div>
        {content.rootUrl && (
          <div className="flex justify-center bg-[#0e0e0e]">
            <ContentCard />
          </div>
        )}
        <div
          className={`${
            content.rootUrl ? "hidden" : "" // Hide CuratedLinks if content.rootUrl is truthy
          }`}
        >
          <CuratedLinks />
        </div>
        {content.rootUrl && (
          <div>
            <CommentSection />
          </div>
        )}
      </div>
      <div className="w-1/5 hidden md:block"></div>
    </div>
  );
}
