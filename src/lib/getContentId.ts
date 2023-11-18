export function getYouTubeShortsContentId(url: string) {
  console.log("getYouTubeShortsContentId called...");
  return new Promise<string | null>((resolve) => {
    const match = url.match(/^(https:\/\/www\.youtube\.com\/shorts\/[\w-]+)/);
    if (match) {
      console.log("Matched URL:", match[0]);

      const contentIdMatch = match[0].match(/\/([\w-]+)(\?|$)/);
      console.log("Content ID Match:", contentIdMatch);

      resolve(contentIdMatch ? contentIdMatch[1] : null);
    } else {
      resolve(null);
    }
  });
}

// export function getYouTubeShortsContentId(url: string): Promise<string | null> {
//   return new Promise((resolve) => {
//     const shortsMatch = url.match(
//       /^(https:\/\/www\.youtube\.com\/shorts\/([\w-]+))(?:\?.*)?$/
//     );
//     resolve(shortsMatch ? shortsMatch[2] : null);
//   });
// }

export function getYouTubeVideoId(url: string): Promise<string | null> {
  return new Promise((resolve, reject) => {
    const match = url.match(/(?:\/|%3D|v=|vi=)([0-9A-Za-z-_]{11})(?:[%#?&]|$)/);
    if (match) {
      resolve(match[1]);
    } else {
      reject(new Error("No match found for YouTube video ID."));
    }
  });
}

export function getTweetIdFromUrl(url: string): Promise<string | null> {
  return new Promise((resolve, reject) => {
    const match = url.match(
      /(https?:\/\/(?:www\.)?(twitter\.com|x\.com)\/[\w/]+\/(\d+)).*/
    );
    if (match) {
      resolve(match[3]);
    } else {
      reject(new Error("No match found for Tweet ID."));
    }
  });
}

export function getInstagramIdFromUrl(url: string): Promise<string | null> {
  return new Promise((resolve, reject) => {
    const match = url.match(/\/p\/([^/?]+)/) || url.match(/\/reel\/([^/?]+)/);
    if (match) {
      resolve(match[1]);
    } else {
      reject(new Error("No match found for Instagram content ID."));
    }
  });
}

export function getFacebookContentIdFromUrl(
  url: string
): Promise<string | null> {
  return new Promise((resolve, reject) => {
    const postMatch = url.match(
      /https?:\/\/(?:www\.)?facebook\.com\/[^/]+\/posts\/(\d+)/
    );
    const watchMatch = url.match(/https?:\/\/fb\.watch\/([a-zA-Z0-9_-]+)/);

    if (postMatch) {
      resolve(postMatch[1]);
    } else if (watchMatch) {
      resolve(watchMatch[1]);
    } else {
      reject(new Error("No match found for Facebook content ID."));
    }
  });
}
