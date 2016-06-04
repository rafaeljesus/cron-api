defmodule Cron.SearchTest do
  use ExUnit.Case
  alias Cron.{Scheduler, Event}

  setup do
    on_exit fn ->
      Scheduler.delete(1)
    end
  end

  test "should add job" do
    with event <- %Event{id: 1, cron: '* * * * *'},
      {:ok, job_id} <- Scheduler.add(event),
      do: assert job_id != nil
  end

  test "should find job" do
    with event <- %Event{id: 1, cron: '* * * * *'},
      {:ok, _} <- Scheduler.add(event),
      {:ok, job} <- Scheduler.find(event.id),
      do: assert job.state == :active
  end

  test "should deactivate job" do
    with event <- %Event{id: 1, cron: '* * * * *'},
      {:ok, _} <- Scheduler.add(event),
      {:ok, _} <- Scheduler.deactivate(event.id),
      {:ok, job} <- Scheduler.find(event.id),
      do: assert job.state == :inactive
  end

  test "should activate job" do
    with event <- %Event{id: 1, cron: '* * * * *'},
      {:ok, _} <- Scheduler.add(event),
      {:ok, _} <- Scheduler.activate(event.id),
      {:ok, job} <- Scheduler.find(event.id),
      do: assert job.state == :active
  end

  test "should delete job" do
    with event <- %Event{id: 1, cron: '* * * * *'},
      {:ok, _} <- Scheduler.add(event),
      {:ok, _} <- Scheduler.delete(event.id),
      {:ok, job} <- Scheduler.find(event.id),
      do: assert job == nil
  end
end
