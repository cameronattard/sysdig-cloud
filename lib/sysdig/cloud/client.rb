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

      def get_notifications(from_ts, to_ts, state = nil, resolved = nil)
        params = {}
        params[:from] = from_ts * 100000 unless from_ts.nil?
        params[:to] = to_ts * 100000 unless to_ts.nil?
        params[:state] = state unless state.nil?
        params[:resolved] = resolved unless resolved.nil?

        conn.get('/api/notifications', params)
      end

      def update_notofication_resolution(notification, resolved)
        #TODO: Test this
        return false unless notification.key?(:id)
        notification[:resolved] = resolved
        data = { notification: notification }

        conn.put("/api/notifications/#{notification[:id]}", data)
      end

      def create_alert
        #TODO: Implement this
      end

      def delete_alert(alert)
        #TODO: Test this
        return false unless alert.key?(:id)
        conn.delete("/api/alerts/#{alert[:id]}")
      end

      def get_notification_settings(settings)
        conn.get('/api/settings/notifications')
      end

      def set_notification_settings(settings)
        #TODO: Test this
        conn.put('/api/settings/notifications', settings)
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
        #TODO: Test this
        views_list_response = JSON.parse(get_views_list.body)
        return false if views_list.empty?

        views_list = views_list_response['drillDownDashboardDescriptors']

        view_id = views_list.find { |view| view['name'] == name }.try(:id)
        return false if view_id.nil?

        conn.get("/data/drilldownDashboards/#{view_id}".json)
      end

      def get_dashboards
        conn.get('/ui/dashboards')
      end

      def find_dashboard_by(name = nil)
        #TODO: Implement this
      end

      def create_dashboard(name)
        #TODO: Test this
        dashboard_config = {
          name: name,
          schema: 1,
          items: []
        }

        data = {
          dashboard: dashboard_config
        }

        conn.post('/ui/dashboards', data)
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
        # TODO: Test this
        params = {}
        params[:name] = name unless name.nil?
        params[:from] = from_ts unless from_ts.nil?
        params[:to] = to_ts unless to_ts.nil?
        params[:tags] = tags unless tags.nil?

        conn.get('/api/events', params)
      end

      def delete_event(event)
        conn.delete("/api/events/#{event[:id]}")
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

      def poll_sysdig_capture(capture)
        #TODO: Test this
        return false unless capture.key?(:id)
        conn.get("/api/sysdig/#{capture[:id]}")
      end

      def create_sysdig_capture(hostname, capture_name, duration, capture_filter = '', folder = '/')
        #TODO: Test this
        connected_agents = get_connected_agents.body
        return false if connected_agents.empty?

        capture_agent = connected_agents['agents'].find do |agent|
          agent['hostName'] == hostname
        end

        data = {
          agent: capture_agent,
          name: capture_name,
          duration: duration,
          folder: folder,
          filters: capture_filter,
          bucketName: ''
        }

        conn.post('/api/sysdig', data)
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
