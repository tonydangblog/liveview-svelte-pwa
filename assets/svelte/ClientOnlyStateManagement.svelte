<script>
  import { onMount } from "svelte";

  import { isClientStateRestored } from "lib/offline-svelte";
  import { isThemeMenuOpened } from "lib/theme-selector";

  import {
    isAccountMenuOpened,
    isTodoOpened,
    newTodo,
    openedOptionsMenuId,
  } from "../stores/clientOnlyState";
  import { todoItems } from "../stores/crdtState";
  import { syncState } from "../stores/syncState";

  /**
   * Get parsed value from localStorage.
   *
   * @param {string} key - Key to get from localStorage.
   * @param {string} type - Type of value.
   * @param {boolean | string} defaultValue - Default value to return if value is not found in localStorage.
   */
  function getParseValue(key, type, defaultValue) {
    const value = localStorage.getItem(key);

    if (!value) return defaultValue;

    try {
      const parsedValue = JSON.parse(value);
      return typeof parsedValue === type ? parsedValue : defaultValue;
    } catch {
      return defaultValue;
    }
  }

  onMount(() => {
    // Sync client state stores with localStorage on startup.
    $isAccountMenuOpened = getParseValue("isAccountMenuOpened", "boolean", $isAccountMenuOpened);
    $isThemeMenuOpened = getParseValue("isThemeMenuOpened", "boolean", $isThemeMenuOpened);
    $isTodoOpened = getParseValue("isTodoOpened", "boolean", $isTodoOpened);
    $newTodo = getParseValue("newTodo", "string", $newTodo);
    $openedOptionsMenuId = getParseValue("openedOptionsMenuId", "string", $openedOptionsMenuId);
    // $syncState is not set here because it is set in StateManagement

    // Let offline-svelte know that the client state has been restored in order
    // to restore scroll position.
    $isClientStateRestored = true;
  });

  // Keep localStorage in sync with client state stores.
  $: if ($isClientStateRestored) {
    localStorage.setItem("isAccountMenuOpened", JSON.stringify($isAccountMenuOpened));
    localStorage.setItem("isThemeMenuOpened", JSON.stringify($isThemeMenuOpened));
    localStorage.setItem("isTodoOpened", JSON.stringify($isTodoOpened));
    localStorage.setItem("newTodo", JSON.stringify($newTodo));
    localStorage.setItem("openedOptionsMenuId", JSON.stringify($openedOptionsMenuId));
    localStorage.setItem("syncState", JSON.stringify($syncState));
  }
</script>

<!-- Keep client state synced across different windows and tabs of the same browser. -->
<svelte:window
  on:storage={({ key, newValue }) => {
    switch (key) {
      case "isAccountMenuOpened":
        $isAccountMenuOpened = JSON.parse(newValue);
        break;

      case "isThemeMenuOpened":
        $isThemeMenuOpened = JSON.parse(newValue);
        break;

      case "isTodoOpened":
        $isTodoOpened = JSON.parse(newValue);
        break;

      case "openedOptionsMenuId":
        $openedOptionsMenuId = JSON.parse(newValue);
        break;

      case "newTodo":
        $newTodo = JSON.parse(newValue);
        break;

      case "syncState":
        $syncState = JSON.parse(newValue);
        break;

      case "clientState":
        const clientState = JSON.parse(newValue);
        $todoItems = clientState.value.todo;
        break;
    }
  }}
/>
