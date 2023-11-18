import { selector } from "recoil";
import { userState } from "../atoms/userState";

export const userEmailSelector = selector({
  key: "userEmailSelector",
  get: ({ get }) => {
    const state = get(userState);
    return state.email;
  },
});
export const userIdSelector = selector({
  key: "userIdSelector",
  get: ({ get }) => {
    const state = get(userState);
    return state.id;
  },
});

export const usernameSelector = selector({
  key: "usernameSelector",
  get: ({ get }) => {
    const state = get(userState);
    return state.username;
  },
});
export const likesSelector = selector({
  key: "likesSelector",
  get: ({ get }) => {
    const state = get(userState);
    return state.likes;
  },
});
export const followersSelector = selector({
  key: "followersSelector",
  get: ({ get }) => {
    const state = get(userState);
    return state.followers;
  },
});
export const followeesSelector = selector({
  key: "followeesSelector",
  get: ({ get }) => {
    const state = get(userState);
    return state.followees;
  },
});
export const publicAddressSelector = selector({
  key: "publicAddressSelector",
  get: ({ get }) => {
    const state = get(userState);
    return state.publicAddress;
  },
});
export const balanceSelector = selector({
  key: "balanceSelector",
  get: ({ get }) => {
    const state = get(userState);
    return state.balance;
  },
});
