import { Clerk } from "@clerk/clerk-js";

const clerk = new Clerk('pk_test_ZmFpdGhmdWwtZHJha2UtMjguY2xlcmsuYWNjb3VudHMuZGV2JA');
clerk.load();

// Log the clerk instance
console.log("Clerk instance initialized:", clerk);

// Function to fetch events
async function fetchEvents() {
  try {
   // const token = await clerk.session.getToken();
    const token = 'pk_test_ZmFpdGhmdWwtZHJha2UtMjguY2xlcmsuYWNjb3VudHMuZGV2JA'
    console.log("Clerk session object:",token);
    if (!token) {
      console.error("No Clerk token available.");
      return;
    }

    console.log("Clerk token:", token); // Log token to confirm

    const response = await fetch("/events", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`, // Attach token here
        "Content-Type": "application/json",
      },
    });

    if (!response.ok) {
      throw new Error(`Request failed with status ${response.status}`);
    }

    const events = await response.json();
    console.log("Fetched events:", events);
  } catch (error) {
    console.error("Error fetching events:", error);
  }
}

fetchEvents(); // Trigger the fetch
