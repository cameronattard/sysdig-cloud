require 'faraday'
require 'faraday_middleware'

module Sysdig
  module Cloud
    class Client

      def initialize(opts)
        @api_token = opts[:api_token]
      end

      def get_user_info
        conn.get('api/user/me')
      end

      def get_connected_agents
        conn.get('api/agents/connected')
      end

      def get_alerts
        conn.get('api/agents/alerts')
      end

      def get_notifications(from_ts, to_ts, state, resolved)
        params = {
          from: from_ts * 100000,
          to: to_ts * 100000,
          state: state,
          resolved: resolved
        }

        # TODO: add params (request body?)
        conn.get('api/notifications')
      end

      def update_notofication_resolution

      end

      def create_alert

      end

      def delete_alert(alert)

      end

      def get_notification_settings(settings)
        conn.get('api/settings/notifications')
      end

      def set_notification_settings(settings)

      end

      def add_email_notification_recipient(email)

      end

      def get_explore_grouping_hierarchy
        conn.get('api/groupConfigurations')
      end

      def get_data_retention_info
        conn.get('api/history/timelines')
      end

      def get_topology_map

      end

      def get_views_list
        conn.get('/data/drilldownDashboardDescriptors.json')
      end

      def get_view(name)

      end

      def get_dashboards
        conn.get('/ui/dashboards')
      end

      def find_dashboard_by(name)

      end

      def create_dashboard(name)

      end

      def add_dashboard_panel

      end

      def remove_dashboard_panel(dashboard, panel_name)

      end

      def create_dashboard_from_template(newdashname, template, scope)

      end

      def create_dashboard_from_view(newdashname, viewname, filter)

      end

      def create_dashboard_from_dashboard(newdashname, templatename, filter)

      end

      def create_dashboard_from_file(newdashname, filename, scope)

      end

      def delete_dashboard(dashboard)

      end

      def post_event

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

      def get_data

      end

      def get_metrics
        conn.get('api/data/metrics')
      end

      def get_sysdig_captures
        conn.get('api/sysdig')
      end

      def poll_sysdig_capture

      end

      def create_sysdig_capture

      end

      private

      def conn
        @conn ||= Faraday.new('https://app.sysdigcloud.com') do |conn|
          conn.headers['Authorization'] = "Bearer #{@api_token}"
          conn.headers['Content-Type'] = 'application/json'
          conn.headers['User-Agent'] = nil
          conn.response :json, :content_type => /\bjson$/
          conn.response :mashify
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end
