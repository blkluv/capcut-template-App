import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

import { Magic } from "@magic-sdk/admin";

const SECRET_API_KEY = process.env.MAGIC_LINK_SECRET_KEY;

// This function can be marked `async` if using `await` inside
export async function middleware(request: NextRequest, response: NextResponse) {
  // console.log("secret api key is ...", SECRET_API_KEY);
  try {
    let token = request.cookies.get("token");
    // console.log("token value in middleware is....", token?.value);

    if (!token) {
      return NextResponse.redirect(new URL("/unauthorized", request.url));
    }

    let magic;

    // Construct with an API key:
    magic = await Magic.init(SECRET_API_KEY);

    // console.log("validating token....");
    // Validate the DID token
    magic.token.validate(token.value);
    // console.log("token validated....");

    return NextResponse.next();
  } catch (error) {
    console.error("Authentication middleware error:", error);
    return NextResponse.redirect(new URL("/unauthorized", request.url));
  }
}

// See "Matching Paths" below to learn more
export const config = {
  matcher: ["/user/:path*", "/api/comments/:path*", "/api/user/:path*"],
};
