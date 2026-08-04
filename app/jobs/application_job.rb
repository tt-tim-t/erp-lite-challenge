class ApplicationJob < ActiveJob::Base
  # A job enqueued inside a transaction waits until that transaction commits,
  # so it never sees (or races) uncommitted rows.
  self.enqueue_after_transaction_commit = true
end
