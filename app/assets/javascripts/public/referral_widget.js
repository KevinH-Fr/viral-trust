(() => {
  const loadWidget = () => {
    const container = document.getElementById('viraltrust-referral-widget');
    if (!container) return;

    const campaignId = container.dataset.campaignId;
    const userEmail = container.dataset.userEmail;

    if (!campaignId || !userEmail) {
      container.innerHTML = "Missing campaign ID or user email.";
      return;
    }

    const button = document.createElement('button');
    button.innerText = "Get your referral link";
    button.style = "padding: 10px 20px; background: #4CAF50; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 14px;";

    const result = document.createElement('div');
    result.style = "margin-top: 10px; font-family: monospace; font-size: 13px; color: #333;";

    button.onclick = async () => {
      button.disabled = true;
      button.innerText = "Generating...";

      try {
        const res = await fetch("https://viraltrust.com/api/referrals/generate", {
          method: "POST",
          headers: {
            "Content-Type": "application/json"
          },
          body: JSON.stringify({
            campaign_id: campaignId,
            email: userEmail
          })
        });

        const data = await res.json();
        if (res.ok) {
          result.innerText = data.referral_url;
        } else {
          result.innerText = "Error: " + data.error;
        }
      } catch (e) {
        result.innerText = "Unexpected error.";
      } finally {
        button.disabled = false;
        button.innerText = "Get your referral link";
      }
    };

    container.appendChild(button);
    container.appendChild(result);
  };

  if (document.readyState === "complete" || document.readyState === "interactive") {
    loadWidget();
  } else {
    document.addEventListener("DOMContentLoaded", loadWidget);
  }
})();
