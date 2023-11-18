import { useState, useEffect } from "react";

export default function signup() {
  const [name, setName] = useState<string>();
  const [email, setEmail] = useState<string>();
  const [username, setUsername] = useState<string>();

  const handleSignup = () => {};

  return (
    <div className="flex justify-center">
      <div>
        <div className="text-lg">Welcome to $SOLicit. Sign up below</div>
        <div>
          <input
            type="name"
            className="m-2 p-2 rounded-lg border border-gray-300 focus:outline-none focus:border-amber-600 text-black"
            id="name"
            placeholder="name"
            onChange={(e) => {
              setName(e.target.value);
            }}
          />
        </div>
        <div>
          <input
            type="username"
            placeholder="username"
            className="m-2 p-2 rounded-lg border border-gray-300 focus:outline-none focus:border-amber-600 text-black"
            id="username"
            onChange={(e) => {
              setUsername(e.target.value);
            }}
          />
        </div>
        <div>
          <input
            type="email"
            placeholder="email"
            className="m-2 p-2 rounded-lg border border-gray-300 focus:outline-none focus:border-amber-600 text-black"
            id="email"
            onChange={(e) => {
              setEmail(e.target.value);
            }}
          />
        </div>

        <button
          onClick={handleSignup}
          className="m-2 bg-amber-600 rounded-xl p-2"
        >
          Sign up
        </button>
      </div>
    </div>
  );
}
