require 'aws-sdk-core'

module Cctv
  class Tracker
    def initialize(table_name, aws_config = {})
      @table_name = table_name.to_s

      access_key_id     = aws_config.fetch(:access_key_id) { env.fetch('AWS_ACCESS_KEY_ID') }
      secret_access_key = aws_config.fetch(:secret_access_key) { env.fetch('AWS_SECRET_ACCESS_KEY') }
      region            = aws_config.fetch(:region) { env.fetch('AWS_REGION') }

      @client = Aws::DynamoDB::Client.new(
        access_key_id:     access_key_id,
        secret_access_key: secret_access_key,
        region:            region
      )
    end

    def record_activity(target, actor, additional_data = {})
      client.put_item(
        table_name: table_name,
        item: {
          timestamp: Time.now.utc.to_i.to_s,
          actor:     actor.to_s,
          target:    target.to_s
        }.merge(additional_data),
        return_values: 'NONE',
        return_consumed_capacity: 'TOTAL',
        return_item_collection_metrics: 'NONE',
      )
    end

    def view_activity(target, time_period_range, params = {})
      limit              = params.fetch(:limit, 25)
      consistent_read    = params.fetch(:consistent_read, false)
      scan_index_forward = params.fetch(:scan_index_forward, true)
      attributes_to_get  = params.fetch(:attributes_to_get, nil)

      select = (attributes_to_get && attributes_to_get == :all) ? 'SPECIFIC_ATTRIBUTES' : 'ALL_ATTRIBUTES'

      client.query(
        table_name: table_name,
        select: select,
        attributes_to_get: attributes_to_get,
        limit: limit,
        consistent_read: consistent_read,
        key_conditions: {
          'target' => {
            attribute_value_list: [
              target.to_s,
            ],
            comparison_operator: 'EQ',
          },
          'timestamp' => {
            attribute_value_list: [
              (time_period_range.min.to_i).to_s,
              (time_period_range.max.to_i).to_s
            ],
            comparison_operator: 'BETWEEN'
          }
        },
        scan_index_forward: true,
        return_consumed_capacity: 'TOTAL',
      ).items
    end

    private

    attr_reader :client, :table_name
  end
end
