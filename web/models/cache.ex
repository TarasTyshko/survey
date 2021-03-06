defmodule Survey.Cache do
  use Survey.Web, :model
  alias Survey.Repo
  import Ecto.Query
  require Ecto.Query
  alias Survey.Cache

  schema "cache" do
    field :blob, Survey.Term
  end

  def store(blob) do
    {:ok, id} = Repo.transaction(fn ->

      blobterm = :erlang.term_to_binary(blob)
      case from(f in Cache, where: f.blob == ^blobterm, limit: 1) |> Repo.all do
        %{id: id} -> id
        nil -> insert(blob)
        [] -> insert(blob)
      end
    end)
    id
  end

  defp insert(blob) do
    %{id: id} = %Survey.Cache{blob: blob}  |> Repo.insert!
    id
  end

  def delete(id) do
    Survey.Repo.delete_all(from f in Survey.Cache, where: f.id == ^id)
  end

  def get(id) do
    case Repo.get(Survey.Cache, id) do
      %{blob: blob} -> blob
      nil           -> nil
    end
  end
end
