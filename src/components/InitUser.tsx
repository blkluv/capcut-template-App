import { Magic } from "magic-sdk";
// import { SolanaExtension } from "@magic-ext/solana";
import { useState, useEffect, useRef } from "react";
// import Modal from "react-modal";
import axios from "axios";
import { userState } from "@/store/atoms/userState";
import { useSetRecoilState, useRecoilValue } from "recoil";
import { userIdSelector } from "@/store/selectors/userDetailsSelector";
import { MAGIC_LINK_API_KEY, RPC_URL } from "@/constants";
import { SolanaExtension } from "@magic-ext/solana";
import * as web3 from "@solana/web3.js";

let magic: any = null;

if (typeof window !== "undefined") {
  magic = new Magic(MAGIC_LINK_API_KEY || "", {
    extensions: [
      new SolanaExtension({
        rpcUrl: RPC_URL,
      }),
    ],
  });
}

export default function InitUser() {
  const userId = useRecoilValue(userIdSelector);
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const setUserState = useSetRecoilState(userState);
  let metadata: any = null;

  useEffect(() => {
    magic.user.isLoggedIn().then(async (magicIsLoggedIn: boolean) => {
      setIsLoggedIn(magicIsLoggedIn);
      if (magicIsLoggedIn) {
        metadata = await magic.user.getMetadata();
        // setPublicAddress(metadata.publicAddress || "");
        // setUserMetadata(metadata);

        const idToken = await magic.user.getIdToken();

        // Format the cookie string
        const cookieValue = `token=${idToken}; path=/`;
        // Set the cookie
        document.cookie = cookieValue;
        const createUserResponse = await axios({
          method: "POST",
          url: "/api/user/createUser",
          data: {
            id: metadata.issuer,
            email: metadata.email,
            publicAddress: metadata.publicAddress,
          },
        });
        if (createUserResponse) {
          const getFollows = await axios({
            method: "GET",
            url: "/api/getFollows",
            params: {
              userId: createUserResponse.data.user.id,
            },
          });
          if (getFollows) {
            setUserState({
              isLoading: false,
              email: createUserResponse.data.user.email,
              role: "user",
              id: createUserResponse.data.user.id,
              username: createUserResponse.data.user.username,
              isVerified: createUserResponse.data.user.isVerified,
              isActivated: createUserResponse.data.user.isActivated,
              likes: createUserResponse.data.user.likes,
              followers: getFollows.data.followers,
              followees: getFollows.data.following,
              publicAddress: createUserResponse.data.user.publicAddress,
              balance: null,
            });
          } else {
            setUserState({
              isLoading: false,
              email: createUserResponse.data.user.email,
              role: "user",
              id: createUserResponse.data.user.id,
              username: createUserResponse.data.user.username,
              isVerified: createUserResponse.data.user.isVerified,
              isActivated: createUserResponse.data.user.isActivated,
              likes: createUserResponse.data.user.likes,
              followers: null,
              followees: null,
              publicAddress: createUserResponse.data.user.publicAddress,
              balance: null,
            });
          }
          setIsLoggedIn(true);
        }

        try {
          const publicKey = new web3.PublicKey(metadata.publicAddress || "");
          const solana = new web3.Connection(RPC_URL);
          const balance = await solana.getBalance(publicKey);

          setUserState((prevUserState) => ({
            ...prevUserState,
            balance: balance,
          }));

          // console.log("Nav-Bar - Balance set to...", balance);
        } catch (error) {
          // Handle the error, e.g., user not found
          console.log(error);
        }

        // console.log("metadata from useEffect in navbar....", metadata); //remove later
      }
    });
  }, []);

  return <></>;
}
