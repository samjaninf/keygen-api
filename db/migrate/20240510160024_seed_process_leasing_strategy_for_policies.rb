class SeedProcessLeasingStrategyForPolicies < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  verbose!

  BATCH_SIZE = 10_000

  def up
    update_count = nil
    batch_count  = 0

    until update_count == 0
      batch_count  += 1
      update_count  = exec_update(<<~SQL.squish, batch_count:, batch_size: BATCH_SIZE)
        WITH batch AS (
          SELECT
            policies.id AS policy_id,
            policies.leasing_strategy
          FROM
            policies
          WHERE
            policies.process_leasing_strategy IS NULL
          LIMIT
            :batch_size
        )
        UPDATE
          policies
        SET
          process_leasing_strategy = batch.leasing_strategy
        FROM
          batch
        WHERE
          policies.id = batch.policy_id
        /* batch=:batch_count */
      SQL
    end
  end

  def down
    update_count = nil
    batch_count  = 0

    until update_count == 0
      batch_count  += 1
      update_count  = exec_update(<<~SQL.squish, batch_count:, batch_size: BATCH_SIZE)
        UPDATE
          policies
        SET
          process_leasing_strategy = NULL
        WHERE
          policies.id IN (
            SELECT
              policies.id
            FROM
              policies
            WHERE
              policies.process_leasing_strategy IS NOT NULL
            LIMIT
              :batch_size
          )
        /* batch=:batch_count */
      SQL
    end
  end

  private

  def exec_update(sql, **binds)
    ActiveRecord::Base.connection.exec_update(
      ActiveRecord::Base.sanitize_sql([sql, **binds]),
    )
  end
end
