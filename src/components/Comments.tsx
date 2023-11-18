import { contentState } from "@/store/atoms/contentState";
import { useSetRecoilState, useRecoilValue } from "recoil";
import axios from "axios";
import { useState } from "react";
import {
  userIdSelector,
  userEmailSelector,
} from "@/store/selectors/userDetailsSelector";
import { Magic } from "magic-sdk";
import { SolanaExtension } from "@magic-ext/solana"; // need fixes for typing here
import * as web3 from "@solana/web3.js";
import { publicAddressSelector } from "@/store/selectors/userDetailsSelector";
import { balanceSelector } from "@/store/selectors/userDetailsSelector";
import Modal from "react-modal";
import { useRouter } from "next/router";
import { MAGIC_LINK_API_KEY, RPC_URL } from "@/constants";

let magic: any = null;
const likeAmount = 10000; // in lamports

if (typeof window !== "undefined") {
  magic = new Magic(MAGIC_LINK_API_KEY || "", {
    extensions: [
      new SolanaExtension({
        rpcUrl: RPC_URL,
      }),
    ],
  });
}

export default function Comments() {
  const router = useRouter();
  const content = useRecoilValue(contentState);
  const userId = useRecoilValue(userIdSelector);
  const userPublicAddress = useRecoilValue(publicAddressSelector);
  const userBalance = useRecoilValue(balanceSelector);
  const [isFirstUserModal, setIsFirstUserModal] = useState(false);

  // console.log("RPC_URL is ...", RPC_URL);

  let comments = content.comments;
  const setContentState = useSetRecoilState(contentState);
  const [likedComments, setLikedComments] = useState<string[]>([]);

  const closeFirstUserModal = () => {
    setIsFirstUserModal(false);
  };

  const handleLikeClick = async (id: any, authorPublicAddress: any) => {
    try {
      if (userId === null) {
        alert("Please log in");
        return;
      }
      if (userPublicAddress === authorPublicAddress) {
        alert("Cannot like your own comments");
        return;
      }
      if (userBalance < 10000000) {
        setIsFirstUserModal(true);
        return;
      }

      setLikedComments((prevIds) => [...prevIds, id]);

      //transaction may fail but the like is still added in the db - fix later
      let response: any = await axios({
        method: "POST",
        url: "/api/user/likeComment",
        data: {
          userId: userId, //change later
          commentId: id,
          //   publicAddress: userPublicAddress,
          //   authorPublicAddress: authorPublicAddress,
        },
      });
      // Check if the response indicates an error
      if (response.data.error) {
        // Handle the error by displaying an alert or a user-friendly message
        alert("Error: " + response.data.error);
      }
      // console.log("updated comment...", response);
      const updatedComment = response.data.updatedComment;
      // Find the index of the comment you want to update
      const commentIndex = comments.findIndex(
        (comment: any) => comment.id === updatedComment.id
      );

      if (commentIndex !== -1) {
        // Create a new array with the updated comment
        const updatedComments = [...comments];
        updatedComments[commentIndex] = updatedComment;

        // Set the updated comments using setComments
        setContentState((prevVideoState) => ({
          ...prevVideoState,
          comments: updatedComments,
        }));
      }
      if (response.status === 200) {
        // Update the liked comment IDs with the new ID
        // setLikedComments((prevIds) => [...prevIds, id]);
        handleTransaction(authorPublicAddress);
      }
    } catch (error) {
      // Handle any network errors or other unexpected issues
      console.error("An error occurred:", error);
      alert("An error occurred. Please try again later.");
    }
  };

  const handleTransaction = async (authorPublicAddress: any) => {
    try {
      //   setSendingTransaction(true);
      if (userPublicAddress === authorPublicAddress) {
        alert("Cannot like your own comments.");
        return;
      }
      let payer_base58publicKey = new web3.PublicKey(userPublicAddress || "");
      let receiver_base58publicKey = new web3.PublicKey(authorPublicAddress);

      const connection = new web3.Connection(RPC_URL);

      const hash = await connection.getLatestBlockhash();
      const blockHeight = await connection.getBlockHeight();
      const lastValidBlockHeight = blockHeight + 5; //about 2 seconds

      let transactionMagic = new web3.Transaction({
        blockhash: hash.blockhash,
        feePayer: payer_base58publicKey,
        lastValidBlockHeight: lastValidBlockHeight,
      });

      const transaction = web3.SystemProgram.transfer({
        fromPubkey: payer_base58publicKey,
        toPubkey: receiver_base58publicKey,
        lamports: likeAmount,
      });

      transactionMagic.add(...[transaction]);

      const serializeConfig = {
        requireAllSignatures: false,
        verifySignatures: true,
      };

      const signedTransaction = await magic.solana.signTransaction(
        transactionMagic,
        serializeConfig
      );

      // console.log("Check your Signed Transaction in console!");
      // console.log("Signed transaction", signedTransaction);

      //Now to send transaction
      const tx = web3.Transaction.from(signedTransaction.rawTransaction);
      const signature = await connection.sendRawTransaction(tx.serialize());
      // console.log("here is the sent transaction signature", signature);

      //   setSendingTransaction(false);
    } catch (e) {
      alert("Error sending transaction");
      console.log("Error sending like transaction - ", e);
    }
  };
  if (comments) {
    return (
      <div>
        {comments.map((comment: any) => {
          return (
            <div
              key={comment.id}
              className="flex justify-between p-2 m-2 rounded-lg bg-[#0e0e0e] hover:bg-[#1f1f1f]"
            >
              <div className="flex">
                <div>
                  <div
                    onClick={() => {
                      router.push(`/user/${comment.authorUsername}`);
                    }}
                    className="flex justify-center p-2 m-2 h-10 w-10 bg-green-600 text-white rounded-full hover:cursor-pointer"
                  >
                    <div>{comment.authorUsername?.slice(0, 1)}</div>
                  </div>
                </div>
                <div>
                  <div
                    onClick={() => {
                      router.push(`/user/${comment.authorUsername}`);
                    }}
                    className="text-sm text-gray-700 p-1 m-1 hover:cursor-pointer"
                  >
                    @{comment.authorUsername}
                  </div>
                  <div className="p-2">{comment.comment}</div>
                </div>
              </div>
              <div className="flex items-center">
                <div
                  className="p-2 rounded-full hover:cursor-pointer"
                  onClick={() => {
                    handleLikeClick(comment.id, comment.authorPublicAddress);
                  }}
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill={likedComments.includes(comment.id) ? "red" : "none"}
                    viewBox="0 0 24 24"
                    strokeWidth={1.5}
                    stroke="currentColor"
                    className="w-6 h-6"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z"
                    />
                  </svg>
                </div>
                <div className="flex items-center text-sm text-gray-500">
                  <div>{comment.likes.length} likes</div>
                </div>
              </div>
            </div>
          );
        })}
        <Modal
          isOpen={isFirstUserModal}
          onRequestClose={closeFirstUserModal}
          contentLabel="First User Modal"
          style={{
            overlay: {
              backgroundColor: "rgba(0, 0, 0, 0.5)",
            },
            content: {
              top: "50%",
              left: "50%",
              right: "auto",
              bottom: "auto",
              marginRight: "-50%",
              transform: "translate(-50%, -50%)",
              maxWidth: "400px",
              padding: "20px",
              background: "white",
            },
          }}
          ariaHideApp={false}
        >
          <div className="flex font-extrabold text-xl mb-3 hover:cursor-pointer text-black">
            <div>solicit</div>
            <div className="text-amber-600">.</div>
          </div>
          <div className="mb-1 text-black font-semibold">
            The only app where your comments can earn money.
          </div>
          <div className="text-black">
            Your balance may be low. Follow these steps to get started.
          </div>
          <div className="text-black">
            1. Copy your address from navigation menu.
          </div>
          <div className="text-black">
            2. Go to{" "}
            <a
              className="text-blue-700"
              href="https://solfaucet.com"
              target="_blank"
              rel="noopener noreferrer"
            >
              solfaucet.com
            </a>
          </div>
          <div className="text-black">3. Paste your address</div>
          <div className="text-black">4. Click on Devnet</div>
          <div className="text-black">
            5. Make sure you refresh the page once you have followed all the
            steps.
          </div>
          <div className="text-black mb-2 mt-2">You are all set. Let's go!</div>
          <button
            className="bg-amber-600 text-white rounded-lg p-3 w-full"
            onClick={closeFirstUserModal}
          >
            Close
          </button>
        </Modal>
      </div>
    );
  }
  return <div>No comments yet! Be the first one to comment</div>;
}
