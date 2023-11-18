// Define a selector to update contentState
import { selector } from "recoil";
import { contentState } from "../atoms/contentState";

export const contentCommentSelector = selector({
  key: "updateContentStateOnLike",
  get: ({ get }) => {
    const content = get(contentState);
    return content.comments;
  },
});
