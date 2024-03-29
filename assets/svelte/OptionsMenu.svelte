<script lang="ts">
  import { scale } from "svelte/transition";

  import { focusTrap } from "$lib/actions/focusTrap";
  import ArrowRightStartOnRectangleSvgIcon from "$lib/svg-icons/ArrowRightStartOnRectangleSvgIcon.svelte";
  import EllipsisHorizontalCircleSvgIcon from "$lib/svg-icons/EllipsisHorizontalCircleSvgIcon.svelte";
  import PencilSvgIcon from "$lib/svg-icons/PencilSvgIcon.svelte";
  import TrashSvgIcon from "$lib/svg-icons/TrashSvgIcon.svelte";
  import XCircleSvgIcon from "$lib/svg-icons/XCircleSvgIcon.svelte";

  import { itemToProcessId, openedMenuId } from "$stores/clientOnlyState";

  import type { TodoList, TodoItem } from "$stores/crdtState";
  import type { UpdateItem, DeleteItem } from "./TodoApp.svelte";

  export let item: TodoList | TodoItem;
  export let updateItem: UpdateItem;
  export let deleteItem: DeleteItem;
  export let menuClass: string;
  export let moveTodoMenuId = undefined;
  export let confirmDeletionModalId = undefined;

  let focusFirstElement = false;

  $: if ($openedMenuId !== item.id) {
    focusFirstElement = false;
  }
</script>

<div class="{menuClass} relative pointer-events-auto">
  <button
    class="
      flex items-center rounded-full
      focus:outline-none focus-visible:ring ring-accent ring-offset-1 ring-offset-base-100
    "
    aria-label="Options menu."
    title="Click to toggle options menu."
    on:click={() => ($openedMenuId = $openedMenuId === item.id ? "" : item.id)}
    on:keydown={(event) => {
      if (event.key === "Enter" || event.key === " ") {
        focusFirstElement = true;
      }
    }}
  >
    <div class="swap swap-rotate">
      <input type="checkbox" class="hidden" checked={$openedMenuId === item.id} />
      <EllipsisHorizontalCircleSvgIcon className="swap-off w-6 h-6" />
      <XCircleSvgIcon className="swap-on w-6 h-6" />
    </div>
  </button>

  {#if $openedMenuId === item.id}
    <ul
      class="absolute right-8 -bottom-1 menu bg-base-200 border border-neutral rounded-box"
      in:scale={{ duration: 100 }}
      use:focusTrap={{
        focusFirstElement,
        onEscape: () => ($openedMenuId = ""),
      }}
    >
      <li>
        <button
          data-focusindex="2"
          class="
            flex items-center gap-1 p-2 rounded-lg
            focus:outline-none focus-visible:ring ring-accent ring-offset-1 ring-offset-base-100
          "
          on:click={(e) => {
            if (confirmDeletionModalId) {
              e.stopPropagation(); // Prevent event from bubbling up to ClickOutsideClassHandler.
              $itemToProcessId = item.id;
              $openedMenuId = confirmDeletionModalId;
            } else {
              deleteItem(item);
            }
          }}
        >
          <TrashSvgIcon className="w-4 h-4" />
          Delete
        </button>
      </li>

      {#if moveTodoMenuId}
        <li>
          <button
            data-focusindex="1"
            class="
              flex items-center gap-1 p-2 rounded-lg
              focus:outline-none focus-visible:ring ring-accent ring-offset-1 ring-offset-base-100
            "
            on:click={(e) => {
              e.stopPropagation(); // Prevent event from bubbling up to ClickOutsideClassHandler.
              $itemToProcessId = item.id;
              $openedMenuId = moveTodoMenuId;
            }}
          >
            <ArrowRightStartOnRectangleSvgIcon className="w-4 h-4" />
            Move
          </button>
        </li>
      {/if}

      <li>
        <button
          data-focusindex="0"
          class="
            flex items-center gap-1 p-2 rounded-lg
            focus:outline-none focus-visible:ring ring-accent ring-offset-1 ring-offset-base-100
          "
          on:click={(e) => {
            e.stopPropagation(); // Prevent event from bubbling up to ClickOutsideClassHandler.
            $openedMenuId = "edit-form-id";

            updateItem({
              ...item,
              newName: item.name,
              isEditing: true,
            });
          }}
        >
          <PencilSvgIcon className="w-4 h-4" />
          Edit
        </button>
      </li>
    </ul>
  {/if}
</div>
