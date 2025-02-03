import consumer from "./consumer"

const commentsChannel = consumer.subscriptions.create("CommentsChannel", {
  connected() {
    console.log("Connected to CommentsChannel");
  },

  received(data) {
    const commentsDiv = document.getElementById("comments");
    commentsDiv.innerHTML += `<p><strong>${data.user}:</strong> ${data.content}</p>`;
  }
});

document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("comment-form");
  
  if (form) {
    form.addEventListener("submit", (event) => {
      event.preventDefault();
      
      const commentInput = document.getElementById("comment-input");
      
      fetch(`/items/${form.dataset.itemId}/comments`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        },
        body: JSON.stringify({ comment: { content: commentInput.value } })
      });

      commentInput.value = "";
    });
  }
});
