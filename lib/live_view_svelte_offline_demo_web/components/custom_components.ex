defmodule LiveViewSvelteOfflineDemoWeb.CustomComponents do
  use Phoenix.Component

  # Allow use of sigil_p/2
  use Phoenix.VerifiedRoutes,
    endpoint: LiveViewSvelteOfflineDemoWeb.Endpoint,
    router: LiveViewSvelteOfflineDemoWeb.Router,
    statics: LiveViewSvelteOfflineDemoWeb.static_paths()

  slot :inner_block, required: true

  def root_html(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en" class="[scrollbar-gutter:stable]">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <!-- Favicons -->
        <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
        <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
        <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />
        <link rel="manifest" href="/site.webmanifest" />
        <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#00ccb7" />
        <meta name="apple-mobile-web-app-title" content="ToDo" />
        <meta name="application-name" content="ToDo" />
        <meta name="msapplication-TileColor" content="#00aba9" />
        <meta name="theme-color" content="#1d232a" />
        <!-- End Favicons -->
        <meta name="csrf-token" content={Phoenix.Controller.get_csrf_token()} />
        <.live_title suffix=" · Offline-Enabled LiveView Svelte Demo">
          ToDo
        </.live_title>
        <meta name="description" content="Offline-Enabled LiveView Svelte Demo App" />
        <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
        <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}>
        </script>
        <script>
          // Set theme in head to avoid FOUC.
          if (
            localStorage.theme === 'dark' ||
            (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)
          ) {
            document.documentElement.classList.add('dark')
            document.documentElement.dataset.theme = 'dark'
          } else {
            document.documentElement.dataset.theme = 'light'
          }
        </script>
      </head>
      <body class="antialiased min-h-screen">
        <%= render_slot(@inner_block) %>
      </body>
    </html>
    """
  end
end
