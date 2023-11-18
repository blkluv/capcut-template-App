import { useEffect, useState } from "react";
import { useRouter } from "next/router";
import axios from "axios";
import { followeesSelector } from "@/store/selectors/userDetailsSelector";
import { userIdSelector } from "@/store/selectors/userDetailsSelector";
import { useRecoilValue, useSetRecoilState } from "recoil";
import Modal from "react-modal";
import { userState } from "@/store/atoms/userState";

export default function UserPage() {
  const router = useRouter();
  const { username } = router.query;
  const [user, setUser] = useState<any>(null);
  const [isFollowing, setIsFollowing] = useState(false);
  const following = useRecoilValue(followeesSelector);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [followingId, setFollowingId] = useState("");
  const loggedInUserId = useRecoilValue(userIdSelector);
  const setUserState = useSetRecoilState(userState);

  const openModal = () => {
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
  };

  useEffect(() => {
    const fetchUser = async () => {
      try {
        const response = await axios.get("/api/getUserByUsername", {
          params: { username },
        });
        setUser(response.data.user);
      } catch (error) {
        // Handle the error, e.g., user not found
        setUser(null);
      }
    };
    console.log("following from dashboard..", following);
    if (following) {
      for (let i = 0; i < following.length; i++) {
        if (following[i].followee.username === username) {
          setFollowingId(following[i].followee.id);
          setIsFollowing(true);
          break;
        }
      }
    }

    if (username) {
      fetchUser();
    }
  }, [username]);

  const handleFollow = async () => {
    try {
      let response = await axios({
        method: "POST",
        url: "/api/user/userFollow",
        data: {
          userId: loggedInUserId,
          followeeId: user.id,
        },
      });
      console.log(loggedInUserId, "...followed...", user.id);
      setIsFollowing(true);
      let newFollows = await axios({
        method: "GET",
        url: "/api/getFollows",
        params: {
          userId: loggedInUserId,
        },
      });
      setUserState((prevUserState) => ({
        ...prevUserState,
        followers: newFollows.data.followers,
        followees: newFollows.data.following,
      }));
      const userUpdatedFollows = await axios.get("/api/getUserByUsername", {
        params: { username },
      });
      setUser(userUpdatedFollows.data.user);
    } catch (e) {
      console.log(e);
      alert("Error following.");
    }
  };

  const handleUnfollow = async () => {
    try {
      let response = await axios({
        method: "DELETE",
        url: "/api/user/userUnfollow",
        data: {
          userId: loggedInUserId,
          followeeId: user.id,
        },
      });
      console.log(loggedInUserId, "...unfollowed...", user.id);
      setIsFollowing(false);
      let newFollows = await axios({
        method: "GET",
        url: "/api/getFollows",
        params: {
          userId: loggedInUserId,
        },
      });
      setUserState((prevUserState) => ({
        ...prevUserState,
        followers: newFollows.data.followers,
        followees: newFollows.data.following,
      }));
      const userUpdatedFollows = await axios.get("/api/getUserByUsername", {
        params: { username },
      });
      setUser(userUpdatedFollows.data.user);
      setIsModalOpen(false);
    } catch (e) {
      console.log(e);
      alert("Error following.");
    }
  };

  return user ? (
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
        <div className="text-bold">@{user.username}</div>

        <div>
          <span>
            Followers:{" "}
            <span>{user.followers ? user.followers.length : "N/A"}</span>
          </span>
        </div>
        <div>
          <span>
            Following:{" "}
            <span>{user.followees ? user.followees.length : "N/A"}</span>
          </span>
        </div>
        <div>
          {isFollowing ? (
            <button
              onClick={openModal}
              className="bg-[#35275e] rounded-xl p-3 mt-3"
            >
              Following
            </button>
          ) : (
            <button
              onClick={handleFollow}
              className="bg-[#1b1430] rounded-xl p-3 hover:bg-[#35275e] mt-3"
            >
              Follow
            </button>
          )}
        </div>
      </div>
      <div className="w-1/5 hidden md:block"></div>
      <Modal
        isOpen={isModalOpen}
        onRequestClose={closeModal}
        contentLabel="Login Modal"
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
        <h4 className="text-lg font-bold mb-4 text-black">
          Are you sure you want to unfollow?
        </h4>
        <div className="mb-4"></div>
        <button
          className="bg-amber-600 text-white rounded-lg p-3 w-full"
          onClick={handleUnfollow}
        >
          Unfollow{" "}
        </button>
      </Modal>
      <div className="min-h-[70vh]"></div>
    </div>
  ) : (
    <div className="flex">
      <div className="w-1/5 hidden md:block"></div>
      <div className="md:w-3/5 font-medium text-lg">User not found</div>
      <div className="w-1/5 hidden md:block"></div>
      <div className="min-h-[70vh]"></div>
    </div>
  );
}
