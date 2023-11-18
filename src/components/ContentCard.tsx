import { contentState } from "@/store/atoms/contentState";
import { useRecoilValue } from "recoil";
import {
  InstagramEmbed,
  FacebookEmbed,
  TwitterEmbed,
} from "react-social-media-embed";
import { useEffect, useState } from "react";

export default function ContentCard() {
  const content = useRecoilValue(contentState);
  // console.log("contentID from ContentCard...", content.contentId);
  // console.log("baseURL from ContentCard...", content.rootUrl);

  useEffect(() => {}, [content]);

  return (
    <div className="p-2 m-2">
      {content.source === "YouTube" && (
        <div>
          <div className="hidden sm:block">
            <iframe
              id="ytplayer"
              width="640"
              height="360"
              src={`https://www.youtube.com/embed/${content.contentId}`}
            ></iframe>
          </div>
          <div className="sm:hidden">
            <iframe
              id="ytplayer"
              width="360"
              height="240"
              src={`https://www.youtube.com/embed/${content.contentId}`}
            ></iframe>
          </div>
        </div>
      )}
      {content.source === "Twitter" && (
        <div>
          <TwitterEmbed url={content.link || ""} />
        </div>
      )}
      {content.source === "Instagram" && (
        <div>
          <InstagramEmbed url={content.link || ""} width={328} />
        </div>
      )}
      {content.source === "Facebook" && (
        <div>
          <FacebookEmbed url={content.link || ""} width={325} />
        </div>
      )}
      <div className="flex">
        {content.source && <div>Source: </div>} {content.source}
      </div>
      {/* <div>{content.link}</div>
      <div>{content.contentId}</div> */}
    </div>
  );
}
