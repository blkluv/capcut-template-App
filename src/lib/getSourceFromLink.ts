export default function getSourceFromLink(link: string) {
  if (link === "") {
    return null;
  } else if (link.includes("twitter.com") || link.includes("x.com")) {
    return "Twitter";
  } else if (link.includes("instagram.com")) {
    return "Instagram";
  } else if (link.includes("facebook.com")) {
    return "Facebook";
  } else if (link.includes("youtu.be") || link.includes("youtube.com")) {
    return "YouTube";
  } else {
    return "Unknown";
  }
}

export function getSourceFromLinkPromisified(link: string) {
  return new Promise<string>((resolve, reject) => {
    if (link === "") {
      reject("Empty");
    } else if (link.includes("twitter.com") || link.includes("x.com")) {
      resolve("Twitter");
    } else if (link.includes("instagram.com")) {
      resolve("Instagram");
    } else if (link.includes("facebook.com")) {
      resolve("Facebook");
    } else if (link.includes("youtu.be") || link.includes("youtube.com")) {
      resolve("YouTube");
    } else {
      reject("Unknown");
    }
  });
}
