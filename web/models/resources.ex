defmodule Survey.Resource do
  use Survey.Web, :model
  alias Survey.Repo
  import Ecto.Query
  require Ecto.Query
  alias Ecto.Adapters.SQL

  schema "resources" do
    field :name, :string
    field :url, :string
    field :tags, {:array, :string}
    field :description, :string
    field :generic, :boolean
    field :comments, {:array, Survey.JSON}
    field :old_desc, {:array, Survey.JSON}
    field :old_tags, {:array, Survey.JSON}
    field :score, :float
    field :old_score, {:array, Survey.JSON}
    belongs_to :sig, Survey.SIG
    belongs_to :user, Survey.User
    timestamps
  end

  # returns ID of an entry with a given URL, or nil if it doesn't exist
  def find_url(url, sig \\ nil) do
    req = from t in Survey.Resource,
    where: t.url == ^url,
    select: t.id,
    limit: 1
    if sig do
      req = from t in req, where: t.sig_id == ^sig
    end
    req |> Repo.one
  end

  def get_resource(id) do
    (from t in Survey.Resource,
    where: t.id == ^id,
    join: u in assoc(t, :user),
    preload: [user: u])
    |> Repo.one
  end

  # how many resources submitted by user
  def user_submitted_no(userid) do
    req = from t in Survey.Resource,
    where: t.user_id == ^userid,
    select: count(t.id)
    req |> Repo.one
  end

  # how many resources reviewed by user
  def user_reviewed_no(userid) do
    req = from t in Survey.User,
    where: t.id == ^userid,
    select: fragment("cardinality(?)", [t.resources_seen])
    req |> Repo.one
  end

  def get_all_by_sigs do
    (from t in Survey.Resource,
    join: s in assoc(t, :sig),
    join: u in assoc(t, :user),
    preload: [sig: s, user: u])
    |> Repo.all
    |> Enum.group_by(fn x -> x.sig.name end)
  end

  def update_seen(user, id) do
    seen = user.resources_seen
    if !seen, do: seen = []
    if not id in seen do
      %{ user | resources_seen: [ id | seen ]} |> Repo.update!
    end
  end

  def tag_freq(sig) do
    sigsearch = if sig do
      "where sig_id = #{sig}"
    else
      ""
    end
    runq("
      WITH tags AS (SELECT unnest(tags) AS tag FROM resources
      #{sigsearch}) SELECT tag, 
      count(tag) AS COUNT FROM tags GROUP BY tag;")
    |> Enum.map(fn {tag, count} -> 
      %{text: tag, weight: count, link: "#"} end)
    |> Poison.encode!
  end

  def resource_list(sig, tag \\ nil) do 
    query = from t in Survey.Resource,
    order_by: [fragment("coalesce(?, -999)", t.score), asc: t.score, asc: t.name]

    if sig do
      query = from t in query, where: (t.sig_id == ^sig) or (t.generic == true)
    end

    if tag do
      query = query |> and_and(:tags, [tag])
    end

    query 
    |> Repo.all
    |> Enum.group_by(fn x -> x.sig_id == sig end)
  end

  def user_seen?(user, resourceid) do
    user.resources_seen && Enum.member?(user.resources_seen, resourceid)
  end

  defp and_and(query, col, val) when is_list(val) and is_atom(col) do
    from p in query, where: fragment("? && ?", ^val, field(p, ^col))
  end

  # returns the id of a random resource fit for a given user, and adds it
  # to that users "has seen" list
  def get_random(user) do
    :random.seed(:os.timestamp)

    seen = user.resources_seen || []

    available_ids = 
    (from f in Survey.Resource,
    where: not (f.id in ^seen),
    where: not (f.user_id == ^user.id),
    where: (f.sig_id == ^user.sig_id) or 
    (f.generic == true),
    select: f.id)
    |> Repo.all

    if length(available_ids) == 0 do
      nil
    else
      selected = :random.uniform(length(available_ids)) - 1
      s_id = Enum.at(available_ids, selected)
      update_seen(user, s_id)

      s_id
    end
  end

  def runq(query, opts \\ []) do
    result = SQL.query(Survey.Repo, query, [])
    result.rows
  end

end
