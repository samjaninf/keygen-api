class AddEventTypeToWebhookEvents < ActiveRecord::Migration[5.2]
  def up
    add_column :webhook_events, :event_type_id, :uuid, null: true

    # Update all webhook events to have an event type association before
    # we add the foreign key constraint
    WebhookEvent.connection.update('
      UPDATE webhook_events AS we
        SET event_type_id = et.id
      FROM event_types AS et
        WHERE we.event = et.event
    ')

    change_column :webhook_events, :event_type_id, :uuid, null: false

    add_foreign_key :webhook_events, :event_types
  end

  def down
    remove_column :webhook_events, :event_type_id
  end
end
