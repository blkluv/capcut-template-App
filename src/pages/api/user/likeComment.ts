import { NextApiRequest, NextApiResponse } from "next";
import prisma from "@/lib/prisma";
import { Magic } from "magic-sdk";
// import { SolanaExtension } from "@magic-ext/solana";
import * as web3 from "@solana/web3.js";

// let magic: any;
// if (typeof window !== "undefined") {
//   magic = new Magic(process.env.MAGIC_LINK_API_KEY || "", {
//     extensions: [
//       new SolanaExtension({
//         rpcUrl: process.env.SOLANA_RPC_URL,
//       }),
//     ],
//   });
// }

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === "POST") {
    try {
      const { userId, commentId } = req.body;
      // const magic = new Magic(process.env.MAGIC_LINK_API_KEY || "", {
      //   extensions: [
      //     new SolanaExtension({
      //       rpcUrl: process.env.SOLANA_RPC_URL,
      //     }),
      //   ],
      // });

      //check if like exists first
      const existingLike = await prisma.like.findFirst({
        where: {
          authorId: userId,
          postId: commentId,
        },
      });

      if (existingLike) {
        res.status(400).json({ message: "The like already exists." });
      } else {
        const newLike = await prisma.like.create({
          data: {
            authorId: userId,
            postId: commentId,
          },
        });

        // await handleTransaction(publicAddress, authorPublicAddress, magic);

        // Associate the new like with the user
        const updatedUser = await prisma.user.update({
          where: { id: userId },
          data: {
            likes: {
              connect: {
                id: newLike.id,
              },
            },
          },
        });

        // Associate the new like with the post
        const updatedPost = await prisma.post.update({
          where: { id: commentId },
          data: {
            likes: {
              connect: {
                id: newLike.id,
              },
            },
          },
          include: { likes: true },
        });
        res.status(200).json({
          message: "Like created successfully.",
          updatedComment: updatedPost,
        });
      }
    } catch (error) {
      console.log(error);
      res.status(400).json({ message: "Error liking comment" });
    }
  } else {
    res.status(400).json({ message: "Invalid method" });
  }
}

// function handleTransaction(
//   publicAddress: any,
//   authorPublicAddress: any,
//   magic: any
// ) {
//   return new Promise(async (resolve, reject) => {
//     try {
//       if (publicAddress === authorPublicAddress) {
//         reject("Transaction not needed");
//         return;
//       }
//       let payer_base58publicKey = new web3.PublicKey(publicAddress || "");
//       let receiver_base58publicKey = new web3.PublicKey(authorPublicAddress);

//       const connection = new web3.Connection(process.env.SOLANA_RPC_URL || "");
//       console.log("connection established");

//       const hash = await connection.getLatestBlockhash();
//       const blockHeight = await connection.getBlockHeight();
//       const lastValidBlockHeight = blockHeight + 5; // about 2 seconds

//       let transactionMagic = new web3.Transaction({
//         blockhash: hash.blockhash,
//         feePayer: payer_base58publicKey,
//         lastValidBlockHeight: lastValidBlockHeight,
//       });
//       console.log("tx magix created");
//       const transaction = web3.SystemProgram.transfer({
//         fromPubkey: payer_base58publicKey,
//         toPubkey: receiver_base58publicKey,
//         lamports: 10000,
//       });
//       console.log("tx created");

//       transactionMagic.add(...[transaction]);

//       const serializeConfig = {
//         requireAllSignatures: false,
//         verifySignatures: true,
//       };

//       const signedTransaction = await magic.solana.signTransaction(
//         transactionMagic,
//         serializeConfig
//       );

//       console.log("Check your Signed Transaction in console!");
//       console.log("Signed transaction", signedTransaction);

//       // Now to send the transaction
//       const tx = web3.Transaction.from(signedTransaction.rawTransaction);
//       const signature = await connection.sendRawTransaction(tx.serialize());
//       console.log("Here is the sent transaction signature", signature);

//       resolve("Transaction sent successfully");
//     } catch (e) {
//       console.log("Error sending like transaction - ", e);
//       reject(e);
//     }
//   });
// }
