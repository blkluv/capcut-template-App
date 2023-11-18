import {
  usernameSelector,
  followersSelector,
  followeesSelector,
  likesSelector,
} from "@/store/selectors/userDetailsSelector";
import { useRecoilValue, useSetRecoilState } from "recoil";
import { Magic } from "magic-sdk";
import { SolanaExtension } from "@magic-ext/solana";
import axios from "axios";
import * as web3 from "@solana/web3.js";
import { publicAddressSelector } from "@/store/selectors/userDetailsSelector";
import { useEffect, useState } from "react";
import { balanceSelector } from "@/store/selectors/userDetailsSelector";
import { userState } from "@/store/atoms/userState";
import { MAGIC_LINK_API_KEY, RPC_URL } from "@/constants";

// const rpcUrl = "https://api.devnet.solana.com";
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

export default function Dashboard() {
  const username = useRecoilValue(usernameSelector);
  const followers = useRecoilValue(followersSelector);
  const following = useRecoilValue(followeesSelector);
  const publicAddress = useRecoilValue(publicAddressSelector);
  const balance = useRecoilValue(balanceSelector);
  const setUserState = useSetRecoilState(userState);
  const likes = useRecoilValue(likesSelector);
  console.log("following from dashboard....", following);
  console.log("followers from dashboard....", followers);
  if (likes) {
    console.log("likes from dashboard....", likes.length);
  }

  //   const publicKey = new web3.PublicKey(publicAddress || "");
  //   const solana = new web3.Connection(RPC_URL);
  //   const balance = await solana.getBalance(publicKey);
  //   console.log("balance in dashboard is ....", balance);

  useEffect(() => {
    const fetchBalance = async () => {
      try {
        const publicKey = new web3.PublicKey(publicAddress || "");
        const solana = new web3.Connection(RPC_URL);
        const balance = await solana.getBalance(publicKey);

        setUserState((prevUserState) => ({
          ...prevUserState,
          balance: balance,
        }));
      } catch (error) {
        // Handle the error, e.g., user not found
        console.log(error);
      }
    };

    if (publicAddress) {
      fetchBalance();
    }
  }, [publicAddress]);
  return (
    <div className="flex">
      <div className="w-1/5 hidden md:block"></div>
      <div className="md:w-3/5">
        <div className="flex">
          <div className="flex items-center justify-center p-2 m-2 h-20 w-20 bg-[#193f1a] text-white rounded-full">
            <div className="text-6xl flex items-center justify-center">
              {username?.slice(0, 1)}
            </div>
          </div>
        </div>
        <div className="text-bold">@{username}</div>
        <div>
          <span>
            Balance: <span>{balance} Lamports</span>
          </span>
        </div>
        <div>
          <span>
            Followers: <span>{followers ? followers.length : "N/A"}</span>
          </span>
        </div>
        <div>
          <span>
            Following: <span>{following ? following.length : "N/A"}</span>
          </span>
        </div>
      </div>
      <div className="w-1/5 hidden md:block"></div>
      <div className="min-h-[70vh]"></div>
    </div>
  );
}
