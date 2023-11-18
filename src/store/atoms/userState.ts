import { atom } from "recoil";

export const userState = atom<{
  isLoading: boolean;
  email: string | null;
  role: string | null;
  id: string | null;
  username: string | null;
  isVerified: boolean | null;
  isActivated: boolean | null;
  likes: any;
  followers: any;
  followees: any;
  publicAddress: string | null;
  balance: any;
}>({
  key: "userState",
  default: {
    isLoading: true,
    email: null,
    role: "user",
    id: null,
    username: null,
    isVerified: null,
    isActivated: null,
    likes: null,
    followers: null,
    followees: null,
    publicAddress: null,
    balance: null,
  },
});
