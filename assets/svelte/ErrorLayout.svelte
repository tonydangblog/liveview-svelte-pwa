<script>
  import FrownSvgIcon from "lib/svg-icons/FrownSvgIcon.svelte";

  export let live;
  live;

  export let title;
  export let subtitle = undefined;
  export let href;
  export let linkText;
</script>

<div class="hero min-h-screen">
  <div class="hero-content text-center">
    <div class="max-w-md">
      <FrownSvgIcon className="mx-auto h-40 w-40" />
      <h1 class="text-xl font-bold my-3">{title}</h1>

      {#if subtitle}
        <p class="my-2">{subtitle}</p>
      {/if}

      <a
        class="btn btn-accent my-2"
        {href}
        on:click|preventDefault={() => {
          window.location.replace(href);
        }}
      >
        {linkText}
      </a>
    </div>
  </div>
</div>
