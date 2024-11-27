class CreateApiRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :api_requests do |t|
      t.integer :target_market, null: false
      t.string :target_url, null: false
      t.boolean :success, default: false, null: false
      t.json :response_body
      t.integer :response_code
      t.json :request_body, default: {}, null: false
      t.datetime :request_time, null: false

      t.timestamps
    end
  end
end
