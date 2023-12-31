<script>
  import { clickOutside } from "lib/actions/clickOutside.js";
  import {
    isConnected,
    isClientStateRestored,
    requestAssetDeletion,
    serviceWorkerVersion,
  } from "lib/offline-svelte";
  import UserSvgIcon from "lib/svg-icons/UserSvgIcon.svelte";
  import { showTopBar, hideTopBar } from "lib/topbar";

  import config from "../../priv/static/sw.config.js";
  import { isAccountMenuOpened } from "../stores/clientOnlyState";
  import { toast } from "../stores/toast";

  export let currentUserEmail;

  let isLogOutLoading = false;
  let isSettingsLoading = false;
  let disabled = false;

  function showAbout() {
    $isAccountMenuOpened = false;
    showTopBar();
    window.location.href = "/app/about";
  }

  async function showSettings() {
    disabled = true;
    isSettingsLoading = true;
    showTopBar();

    if (!(await isConnected())) {
      $toast = {
        show: true,
        kind: "error",
        title: "Whoops, can't connect to server...",
        msg: "You must be connected to view settings. Please check your connection or try refreshing.",
      };
      hideTopBar();
      isSettingsLoading = false;
      disabled = false;
      return;
    }

    $isAccountMenuOpened = false;
    window.location.href = "/users/settings";
  }

  async function logOutUser() {
    disabled = true;
    isLogOutLoading = true;
    showTopBar();

    if (!(await isConnected())) {
      $toast = {
        show: true,
        kind: "error",
        title: "Whoops, can't connect to server...",
        msg: "You must be connected to logout. Please check your connection or try refreshing.",
      };
      hideTopBar();
      isLogOutLoading = false;
      disabled = false;
      return;
    }

    requestAssetDeletion(config.privateAssets); // Clear cached assets.
    $isClientStateRestored = false; // This stops client state from being saved to localStorage.
    localStorage.clear(); // Clear client state.

    const logOutLink = document.getElementById("log-out-link");
    try {
      logOutLink.click();
    } catch (error) {
      console.error(error);
      alert("Error logging out. Please try again.");
    }
  }
</script>

<details
  class="dropdown dropdown-end"
  bind:open={$isAccountMenuOpened}
  use:clickOutside={() => ($isAccountMenuOpened = false)}
>
  <summary class="my-1 btn btn-circle btn-neutral" aria-label="Account Menu">
    <UserSvgIcon className="h-6 w-6" />
  </summary>

  <div class="dropdown-content menu bg-base-200 border border-neutral rounded-box">
    <div class="px-4 py-2 font-bold border-b border-neutral rounded-none mb-1.5">
      {currentUserEmail}
      <div class="text-xs font-normal h-4" class:skeleton={!$serviceWorkerVersion}>
        {$serviceWorkerVersion}
      </div>
    </div>

    <ul>
      <li>
        <a href="/app/about" on:click|preventDefault={showAbout}>About</a>
      </li>
      <li>
        <a href="/users/settings" on:click|preventDefault={showSettings} {disabled}>
          Settings
          <span class="loading loading-dots loading-xs" class:hidden={!isSettingsLoading}></span>
        </a>
      </li>
      <li>
        <button on:click={logOutUser} {disabled}>
          Log out
          <span class="loading loading-dots loading-xs" class:hidden={!isLogOutLoading}></span>
        </button>
      </li>
    </ul>
  </div>
</details>
