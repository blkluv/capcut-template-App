import axios from "axios";
import { useState } from "react";
import { contentState } from "@/store/atoms/contentState";
import { useSetRecoilState, useRecoilValue } from "recoil";
import { userIdSelector } from "@/store/selectors/userDetailsSelector";
import { usernameSelector } from "@/store/selectors/userDetailsSelector";
import { publicAddressSelector } from "@/store/selectors/userDetailsSelector";
import { balanceSelector } from "@/store/selectors/userDetailsSelector";
import Modal from "react-modal";

export default function PostComment() {
  const content = useRecoilValue(contentState);
  const userID = useRecoilValue(userIdSelector);
  const username = useRecoilValue(usernameSelector);
  const authorPublicAddress = useRecoilValue(publicAddressSelector);
  const userBalance = useRecoilValue(balanceSelector);
  const [isFirstUserModal, setIsFirstUserModal] = useState(false);

  const closeFirstUserModal = () => {
    setIsFirstUserModal(false);
  };

  let comments: any;
  if (content.comments) {
    comments = content.comments.slice(); // Create a shallow copy of the comments array
  }
  //   let comments: any = [];
  const setContentState = useSetRecoilState(contentState);

  const [comment, setComment] = useState<string>();

  const handlePostComment = async () => {
    if (userBalance < 10000000) {
      setIsFirstUserModal(true);
      return;
    }
    try {
      const response = await axios({
        method: "POST",
        url: "/api/comments/postcomment",
        data: {
          comment: comment,
          contentLink: content.rootUrl,
          authorUsername: username,
          authorPublicAddress: authorPublicAddress,
          authorId: userID,
        },
      });
      //   console.log("comments right now from postcomment....", comments);
      // console.log("userID is ...", userID);
      // console.log("response after posting comment...", response);

      //   console.log("response.data.comment is ....", response.data.comment);
      //   comments.push(response.data.comment);
      //   console.log("new comments array...", comments);
      let updatedComments = [response.data.comment, ...comments];

      setContentState((prevVideoState) => ({
        ...prevVideoState,
        comments: updatedComments,
      }));
    } catch (e) {
      alert("Error occured ");
      console.log(e);
    }
  };
  // console.log("userId from post comment is ...", userID);

  return userID === null ? (
    <div className=" p-2 m-2 rounded-lg bg-[#2f2f2f] hover:bg-[#1f1f1f]">
      Log in to comment
    </div>
  ) : (
    <div>
      <input
        className="p-2 m-2 text-black w-2/3"
        placeholder="write your comment here"
        onChange={(e) => {
          setComment(e.target.value);
        }}
      />
      <button
        onClick={handlePostComment}
        className="bg-amber-600 rounded-xl p-2"
      >
        Post comment
      </button>
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
          <div>$SOLicit</div>
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
