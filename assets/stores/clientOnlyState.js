import { writable } from "svelte/store";

export const isAccountMenuOpened = writable(false);
export const isTodoOpened = writable(true);
export const newTodo = writable("");
export const openedOptionsMenuId = writable("");
