// export function getYouTubeBaseUrl(url: string) {
//   const match = url.match(
//     /^(https?:\/\/(?:www\.)?youtube\.com\/watch\?.*v=[\w-]+)/
//   );
//   return match ? match[1] : null;
// }

// export function getTwitterXBaseUrl(url: string) {
//   const match = url.match(
//     /(https?:\/\/(?:www\.)?(twitter\.com|x\.com)\/[\w/]+\/(\d+))/
//   );
//   return match ? match[1] : null;
// }

// export function getInstagramBaseUrl(url: string) {
//   const match = url.match(
//     /https?:\/\/(?:www\.)?instagram\.com\/[a-zA-Z0-9-_]+\/[a-zA-Z0-9-_]+/
//   );
//   return match ? match[0] : null;
// }

// export function getFacebookBaseUrl(url: string) {
//   const match = url.match(/(https?:\/\/(?:www\.)?facebook\.com\/[^?]+)/);
//   return match ? match[1] : null;
// }

// export function getYouTubeBaseUrl(url: string) {
//   return new Promise((resolve, reject) => {
//     try {
//       const match = url.match(
//         /^(https?:\/\/(?:www\.)?youtube\.com\/watch\?.*v=[\w-]+)/
//       );
//       resolve(match ? match[1] : null);
//     } catch (error) {
//       reject(error);
//     }
//   });
// }

export function getYouTubeBaseUrl(url: string) {
  return new Promise((resolve, reject) => {
    try {
      const match = url.match(
        /^(https?:\/\/(?:www\.)?(?:youtube\.com\/watch\?.*v=|youtu\.be\/)([\w-]+))/
      );
      resolve(match ? `https://www.youtube.com/watch?v=${match[2]}` : null);
    } catch (error) {
      reject(error);
    }
  });
}

// export function getYouTubeBaseUrl(url: string) {
//   return new Promise((resolve, reject) => {
//     try {
//       const shortsMatch = url.match(
//         /^(https?:\/\/(?:www\.)?youtube\.com\/shorts\/([\w-]+)).*$/
//       );
//       if (shortsMatch) {
//         resolve(`https://www.youtube.com/shorts/${shortsMatch[2]}`);
//       } else {
//         const queryMatch = url.match(
//           /^(https?:\/\/(?:www\.)?youtube\.com\/shorts\/([\w-]+)\?si=.+).*$/
//         );
//         if (queryMatch) {
//           resolve(`https://www.youtube.com/shorts/${queryMatch[2]}`);
//         } else {
//           const videoMatch = url.match(
//             /^(https?:\/\/(?:www\.)?(?:youtube\.com\/watch\?.*v=|youtu\.be\/)([\w-]+)).*$/
//           );
//           if (videoMatch) {
//             resolve(`https://www.youtube.com/watch?v=${videoMatch[2]}`);
//           } else {
//             resolve(null);
//           }
//         }
//       }
//     } catch (error) {
//       reject(error);
//     }
//   });
// }

export function getTwitterXBaseUrl(url: string) {
  return new Promise((resolve, reject) => {
    try {
      const match = url.match(
        /(https?:\/\/(?:www\.)?(twitter\.com|x\.com)\/[\w/]+\/(\d+))/
      );
      resolve(match ? match[1] : null);
    } catch (error) {
      reject(error);
    }
  });
}

// export function getYouTubeShortsBaseUrl(url: string) {
//   return new Promise<string | null>((resolve) => {
//     const match = url.match(/^(https:\/\/www\.youtube\.com\/shorts\/[\w-]+)/);
//     resolve(match ? match[1] : null);
//   });
// }

// export function getYouTubeShortsBaseUrl(url: string) {
//   return new Promise((resolve, reject) => {
//     try {
//       const shortsMatch = url.match(
//         /^(https?:\/\/(?:www\.)?youtube\.com\/shorts\/([\w-]+)).*$/
//       );
//       if (shortsMatch) {
//         resolve(`https://www.youtube.com/shorts/${shortsMatch[2]}`);
//       } else {
//         const queryMatch = url.match(
//           /^(https?:\/\/(?:www\.)?youtube\.com\/shorts\/([\w-]+)\?si=.+).*$/
//         );
//         if (queryMatch) {
//           resolve(`https://www.youtube.com/shorts/${queryMatch[2]}`);
//         } else {
//           const videoMatch = url.match(
//             /^(https?:\/\/(?:www\.)?(?:youtube\.com\/watch\?.*v=|youtu\.be\/)([\w-]+)).*$/
//           );
//           if (videoMatch) {
//             resolve(`https://www.youtube.com/watch?v=${videoMatch[2]}`);
//           } else {
//             resolve(null);
//           }
//         }
//       }
//     } catch (error) {
//       reject(error);
//     }
//   });
// }

export function getYouTubeShortsBaseUrl(url: string) {
  return new Promise<string | null>((resolve, reject) => {
    try {
      const match = url.match(
        /^(https:\/\/(?:www\.)?youtube\.com\/shorts\/[\w-]+)(?:\?.*)?$/
      );
      resolve(match ? match[1] : null);
    } catch (error) {
      reject(error);
    }
  });
}

export function getInstagramBaseUrl(url: string) {
  return new Promise((resolve, reject) => {
    try {
      const match = url.match(
        /https?:\/\/(?:www\.)?instagram\.com\/[a-zA-Z0-9-_]+\/[a-zA-Z0-9-_]+/
      );
      resolve(match ? match[0] : null);
    } catch (error) {
      reject(error);
    }
  });
}

export function getFacebookBaseUrl(url: string) {
  return new Promise((resolve, reject) => {
    try {
      const match = url.match(/(https?:\/\/(?:www\.)?facebook\.com\/[^?]+)/);
      resolve(match ? match[1] : null);
    } catch (error) {
      reject(error);
    }
  });
}
