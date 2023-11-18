import React from "react";
import { useRouter } from "next/router";

export default function Footer() {
  const router = useRouter();

  return (
    <footer className="py-4 text-center">
      <hr className="border-t border-gray-700 my-3" />
      <div
        className="flex justify-center font-extrabold text-xl hover:cursor-pointer"
        onClick={() => {
          router.push("/");
        }}
      >
        <div>$SOLicit</div>
        <div className="text-amber-600">.</div>
      </div>
      <p className="text-gray-500 text-sm">
        &copy; {new Date().getFullYear()} All rights reserved
      </p>
    </footer>
  );
}
