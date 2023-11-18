import { atom } from "recoil";

export const curatedLinkState = atom<{
  isLoading: boolean;
  links: any;
}>({
  key: "curatedLinkState",
  default: {
    isLoading: true,
    links: null,
  },
});
