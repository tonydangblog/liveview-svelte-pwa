<script>
  import { onMount } from "svelte";
  import {
    isClientStateRestored,
    requestAssetCaching,
    requestServiceWorkerVersion,
  } from "../lib/offline-svelte";
  import OfflineSvelte from "../lib/offline-svelte/OfflineSvelte.svelte";

  import config from "../../priv/static/sw.config.js";
  import { serverState } from "../stores/liveViewSocket";

  import AppSkeleton from "./AppSkeleton.svelte";
  import ClientOnlyStateManagement from "./ClientOnlyStateManagement.svelte";
  import Header from "./Header.svelte";
  import StateManagement from "./StateManagement.svelte";
  import Toast from "./Toast.svelte";
  import TodoApp from "./TodoApp.svelte";
  import UpdateAlert from "./UpdateAlert.svelte";

  export let live;
  live;

  export let currentUserEmail;
  export let server_state;

  // Setting $serverState here is required so that an initial state is available
  // when offline. This allows the initial syncServerToClient call to set the
  // initial app state ($todoItems and $syncState stores) even when offline.
  $serverState = server_state;

  onMount(() => {
    requestAssetCaching([...config.privateAssets, ...config.publicAssets]);
    requestServiceWorkerVersion();

    // Change URL to "/app" if it's not already. This is for the case where the service worker
    // serves the cached "/app" route when the client requests the root "/" route.
    if (window.location.pathname !== "/app") {
      history.replaceState(null, "", "/app");
    }
  });
</script>

<StateManagement />
<ClientOnlyStateManagement />
<OfflineSvelte />

{#if $isClientStateRestored}
  <Toast />
  <UpdateAlert />
  <Header {currentUserEmail} />

  <div class="max-w-2xl mx-auto px-2 md:p-0">
    <TodoApp />
  </div>
{:else}
  <AppSkeleton />
{/if}
