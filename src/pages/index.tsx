import Image from "next/image";
import { Inter } from "next/font/google";

import LandingPage from "@/components/LandingPage";
import InitUser from "@/components/InitUser";

const inter = Inter({ subsets: ["latin"] });

export default function Home() {
  return (
    <div>
      <InitUser />
      <LandingPage />
      <div className="min-h-[50vh]"></div>
    </div>
  );
}
