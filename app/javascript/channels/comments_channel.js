// import consumer from "./consumer";

// document.addEventListener("turbo:load", () => {
//   const commentsContainer = document.getElementById("comments-list");
//   const itemId = document.getElementById("comments")?.dataset.itemId;

//   if (itemId) {
//     consumer.subscriptions.create(
//       { channel: "CommentsChannel", item_id: itemId },
//       {
//         received(data) {
//           commentsContainer.insertAdjacentHTML("beforeend", data);
//         }
//       }
//     );
//   }
// });


import consumer from "channels/consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Channel connected")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  }
});
