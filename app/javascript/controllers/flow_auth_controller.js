import { Controller } from "@hotwired/stimulus"
import * as fcl from '@onflow/fcl'
import { init } from '@onflow/fcl-wc'

export default class extends Controller {
  static targets = ["loginButton", "logoutButton"]

  connect() {
    fcl.config({
      "flow.network": "testnet",
      "accessNode.api": "https://rest-testnet.onflow.org",
      "discovery.wallet": "https://fcl-discovery.onflow.org/testnet/authn",
      "walletconnect.projectId": "11069f4303b90a2b1628ea2c1e4cf861",
      "app.detail.title": "ViralTrust",
      "app.detail.icon": "https://assets.reown.com/reown-profile-pic.png",
      "app.detail.description": "Join ViralTrust.",
      "app.detail.url": "https://viral-trust.com"
    })

    this.updateUserStatus(false)
  }

  async login() {
    try {
      const user = await fcl.authenticate()
      const walletAddress = user.addr

      const hasSignature = user.services.some(service => service.type === "user-signature")
      if (!hasSignature) {
        alert("User signature service not found.")
        return
      }

      const response = await fetch('/flow_auth/authenticate', {
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        },
        body: JSON.stringify({ authorization_payload: user }),
      })

      const data = await response.json()
      if (response.ok && data.message === "Authentication successful") {
        this.updateUserStatus(true, walletAddress)
      } else {
        alert(data.error || "Authentication failed")
      }
    } catch (error) {
      console.error("Flow login error:", error)
      alert("Une erreur est survenue pendant l’authentification.")
    }
  }

  async logout() {
    try {
      localStorage.clear()

      const response = await fetch('/flow_auth/logout', {
        method: 'DELETE',
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        },
      })

      if (response.ok) {
        this.updateUserStatus(false)
        window.location.href = '/pages/home'
      } else {
        const error = await response.json()
        alert(error.error || "Logout failed")
      }
    } catch (err) {
      console.error("Logout error:", err)
      alert("Une erreur est survenue pendant la déconnexion.")
    }
  }

  updateUserStatus(connected, address = null) {
    if (this.hasLoginButtonTarget)
      this.loginButtonTarget.style.display = connected ? "none" : "block"

    if (this.hasLogoutButtonTarget)
      this.logoutButtonTarget.style.display = connected ? "block" : "none"
  }
}
