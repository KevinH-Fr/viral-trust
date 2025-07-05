(function () {
  function getParam(name) {
    const url = new URL(window.location.href);
    return url.searchParams.get(name);
  }

  const refCode = getParam("via");
  const campaignId = document.currentScript.getAttribute("data-campaign-id");

  if (!refCode || !campaignId) return;

  fetch("http://localhost:3000/api/referrals/track", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      ref_code: refCode,
      campaign_id: parseInt(campaignId),
      visitor_ip: null, 
      timestamp: new Date().toISOString(),
    }),
  }).then((res) => {
    if (!res.ok) {
      console.error("Referral tracking failed");
    }
  }).catch((err) => {
    console.error("Error tracking referral", err);
  });
})();
