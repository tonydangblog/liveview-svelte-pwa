<script>
  import { fly } from "svelte/transition";

  import { isConnected, isSWUpdateAvailable, isSWUpdateConfirmed } from "lib/offline-svelte";
  import InfoSvgIcon from "lib/svg-icons/InfoSvgIcon.svelte";

  let showAlert = false;
  let width;

  $: if ($isSWUpdateAvailable) {
    isConnected({ timeout: 10000 }).then((connected) => {
      if (connected) {
        showAlert = true;
      }
    });
  }
</script>

{#if showAlert}
  <div
    transition:fly={{ y: -100, duration: 750 }}
    bind:clientWidth={width}
    role="alert"
    style:margin-left={`-${width / 2}px`}
    class="fixed left-1/2 w-full sm:max-w-sm z-40"
  >
    <div class="alert shadow-lg border border-neutral m-2" style:width={`${width - 16}px`}>
      <InfoSvgIcon className="h-6 w-6" />

      <div>
        <h3 class="font-bold">Update Available</h3>
        <div class="text-sm">Reload to update?</div>
      </div>

      <div>
        <button
          class="btn btn-sm border border-neutral transition-none"
          on:click={() => (showAlert = false)}
        >
          Later
        </button>

        <button
          class="btn btn-sm btn-accent border border-neutral"
          on:click={() => {
            $isSWUpdateConfirmed = true;
            showAlert = false;
          }}
        >
          Update
        </button>
      </div>
    </div>
  </div>
{/if}
