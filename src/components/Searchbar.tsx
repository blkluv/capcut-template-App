import { contentState } from "@/store/atoms/contentState";
import { useSetRecoilState, useRecoilValue } from "recoil";
import getSourceFromLink from "@/lib/getSourceFromLink";
import {
  getYouTubeVideoId,
  getTweetIdFromUrl,
  getInstagramIdFromUrl,
  getFacebookContentIdFromUrl,
  getYouTubeShortsContentId,
} from "@/lib/getContentId";

import {
  getFacebookBaseUrl,
  getInstagramBaseUrl,
  getTwitterXBaseUrl,
  getYouTubeBaseUrl,
  getYouTubeShortsBaseUrl,
} from "@/lib/getBaseUrl";
import axios from "axios";
import { useState } from "react";
import { useRouter } from "next/router";

export default function Searchbar() {
  const router = useRouter();
  const setContentState = useSetRecoilState(contentState);
  const content = useRecoilValue(contentState);
  const [currentLink, setCurrentLink] = useState<string>();

  const handleSearch = async (inputString: string | null) => {
    if (inputString && inputString[0] === "@") {
      router.push(`/user/${inputString.slice(1)}`);
    } else {
      handleLinkSearch(inputString);
    }
  };

  const handleLinkSearch = async (link: string | null) => {
    try {
      const linkSource = getSourceFromLink(content.link || "");
      let contentId: any = null;
      let baseURL: any = null;
      if (linkSource === "YouTube") {
        if (content.link?.includes("youtube.com/shorts/")) {
          // contentId = await getYouTubeShortsContentId(content.link); // this function is not working - fix later
          baseURL = await getYouTubeShortsBaseUrl(content.link);

          //makeshift contentId fetcher
          const parts = baseURL.split("/shorts/");
          if (parts.length === 2) {
            contentId = parts[1];
          }
        } else {
          contentId = await getYouTubeVideoId(content.link || "");
          baseURL = await getYouTubeBaseUrl(content.link || "");
        }
        console.log("here's the content id...", contentId);
        console.log("here's the baseURL...", baseURL);
      }
      if (linkSource === "Twitter") {
        contentId = await getTweetIdFromUrl(content.link || "");
        baseURL = await getTwitterXBaseUrl(content.link || "");
        console.log("here's the content id...", contentId);
        console.log("here's the baseURL...", baseURL);
      }
      if (linkSource === "Instagram") {
        contentId = await getInstagramIdFromUrl(content.link || "");
        baseURL = await getInstagramBaseUrl(content.link || "");
        console.log("here's the content id...", contentId);
        console.log("here's the baseURL...", baseURL);
      }
      if (linkSource === "Facebook") {
        contentId = await getFacebookContentIdFromUrl(content.link || "");
        baseURL = await getFacebookBaseUrl(content.link || "");
        console.log("here's the content id...", contentId);
        console.log("here's the baseURL...", baseURL);
      }

      //get comments
      let response: any = await axios({
        method: "GET",
        url: "/api/getComments",
        params: {
          baseURL,
        },
      });
      console.log("comments fetched.....", response);
      setContentState((prevVideoState) => ({
        ...prevVideoState,
        source: linkSource,
        contentId: contentId,
        rootUrl: baseURL,
        comments: response.data.comments,
      }));
    } catch (e) {
      alert("Could not fetch the link. Please re-check the link and try again");
      console.log(e);
    }
  };

  return (
    <div>
      {content.rootUrl && (
        <button
          className="bg-[#1b1430] rounded-xl p-2 m-1 hover:bg-[#35275e]"
          onClick={() => {
            setContentState({
              isLoading: true,
              link: currentLink || "",
              source: null,
              rootUrl: null,
              contentId: null,
              comments: null,
            });
          }}
        >
          Back
        </button>
      )}
      <input
        placeholder="Paste Youtube, Instagram, X links here"
        className="text-black w-80 p-2 m-2"
        onChange={(e) => {
          setCurrentLink(e.target.value);

          setContentState({
            isLoading: true,
            link: e.target.value,
            source: null,
            rootUrl: null,
            contentId: null,
            comments: null,
          });
        }}
      />
      <button
        className="bg-amber-600 rounded-xl p-2 m-1"
        onClick={() => {
          handleSearch(currentLink || null);
        }}
      >
        Search
      </button>
    </div>
  );
}
