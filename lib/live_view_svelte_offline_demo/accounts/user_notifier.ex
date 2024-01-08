defmodule LiveViewSvelteOfflineDemo.Accounts.UserNotifier do
  import Swoosh.Email

  alias LiveViewSvelteOfflineDemo.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"LiveViewSvelteOfflineDemo", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """
    You can confirm your account by visiting the URL below:<br><br>

    #{url}<br><br>

    If you didn't create an account, please ignore this.
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """
    You can reset your password by visiting the URL below:<br><br>

    #{url}<br><br>

    If you didn't request this change, please ignore this.
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """
    You can change your email by visiting the URL below:<br><br>

    #{url}<br><br>

    If you didn't request this change, please ignore this.
    """)
  end
end
