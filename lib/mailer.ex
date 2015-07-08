defmodule Survey.Mailer do
  def deliver(email) do
    Mailman.deliver(email, config)
  end

  def config do
    %Mailman.Context{
      config: %Mailman.SmtpConfig{
        username: Application.get_env(:mailer, :username),
        password: Application.get_env(:mailer, :password),
        relay: Application.get_env(:mailer, :relay),
        port: 587,
        tls: :always,
        auth: :always}
    }
  end
end
