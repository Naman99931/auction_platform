import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const item_id = document.getElementById("item_id").value;

consumer.subscriptions.create({channel: "CommentsChannel", item_id: item_id}, {

  connected() {
    console.log("Channel Connected!!  ");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    document.getElementById("@comment").innerHTML += data.HTML
    // Called when there's incoming data on the websocket for this channel
  }

});
});
