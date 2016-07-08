require 'faraday'
require 'faraday_middleware'
require 'json'

module Sysdig
  module Cloud
    class Client

      def initialize(opts)
        @api_token = opts[:api_token]
      end

      def get_user_info
        conn.get('/api/user/me')
      end

      def get_connected_agents
        conn.get('/api/agents/connected')
      end

      def get_alerts
        conn.get('/api/agents/alerts')
      end

      def get_notifications(from_ts, to_ts, state, resolved)
        params = {
          from: from_ts * 100000,
          to: to_ts * 100000,
          state: state,
          resolved: resolved
        }

        # TODO: add params (request body?)
        conn.get('/api/notifications')
      end

      def update_notofication_resolution
        #TODO: Implement this
      end

      def create_alert
        #TODO: Implement this
      end

      def delete_alert(alert)
        #TODO: Implement this
      end

      def get_notification_settings(settings)
        conn.get('/api/settings/notifications')
      end

      def set_notification_settings(settings)
        #TODO: Implement this
      end

      def add_email_notification_recipient(email)
        #TODO: Implement this
      end

      def get_explore_grouping_hierarchy
        conn.get('/api/groupConfigurations')
      end

      def get_data_retention_info
        conn.get('/api/history/timelines')
      end

      def get_topology_map
        #TODO: Implement this
      end

      def get_views_list
        conn.get('/data/drilldownDashboardDescriptors.json')
      end

      def get_view(name)
        #TODO: Implement this
      end

      def get_dashboards
        conn.get('/ui/dashboards')
      end

      def find_dashboard_by(name)
        #TODO: Implement this
      end

      def create_dashboard(name)
        #TODO: Implement this
      end

      def add_dashboard_panel
        #TODO: Implement this
      end

      def remove_dashboard_panel(dashboard, panel_name)
        #TODO: Implement this
      end

      def create_dashboard_from_template(newdashname, template, scope)
        #TODO: Implement this
      end

      def create_dashboard_from_view(newdashname, viewname, filter)
        #TODO: Implement this
      end

      def create_dashboard_from_dashboard(newdashname, templatename, filter)
        #TODO: Implement this
      end

      def create_dashboard_from_file(newdashname, filename, scope)
        #TODO: Implement this
      end

      def delete_dashboard(dashboard)
        #TODO: Implement this
      end

      def post_event
        #TODO: Implement this
      end

      def get_events(name, from_ts, to_ts, tags)
        params = {
          name: name,
          from: from_ts,
          to: to_ts,
          tags: tags
        }

        # TODO: pass params
        conn.get('/api/events')
      end

      def delete_event(event)
        conn.delete("/api/events/#{event['id']}")
      end

      def get_data(metrics, start_ts, end_ts=0, sampling_s=0, filter='', datasource_type='host')
        req_body = {
          metrics: metrics,
          dataSourceType: datasource_type
        }

        if start_ts < 0
          req_body[:last] = -start_ts
        elsif start_ts == 0
          return false
        else
          req_body[:start] = start_ts
          req_body[:end] = end_ts
        end

        req_body[:filter] = filter if filter != ''
        req_body[:sampling] = sampling_s if sampling_s != 0

        conn.post('/api/data/', req_body)
      end

      def get_metrics
        conn.get('/api/data/metrics')
      end

      def get_sysdig_captures
        conn.get('/api/sysdig')
      end

      def poll_sysdig_capture
        #TODO: Implement this
      end

      def create_sysdig_capture
        #TODO: Implement this
      end

      private

      def conn
        @conn ||= Faraday.new('https://app.sysdigcloud.com') do |conn|
          conn.headers = {
            'Authorization' => "Bearer #{@api_token}",
            'Content-Type' => 'application/json',
          }
          conn.request :json
          conn.response :json, :content_type => /\bjson$/
          conn.response :mashify
          conn.adapter Faraday.default_adapter
          conn.use Faraday::Response::RaiseError
        end
      end
    end
  end
end
