require 'redmine'

require 'dispatcher'

Dispatcher.to_prepare :redmine_issue_dependency do
  require_dependency 'issue'
  require_dependency 'project'

  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless ActiveRecord::Base.included_modules.include? RedmineBetterGanttChart::ActiveRecord::CallbackExtensions
    ActiveRecord::Base.send(:include, RedmineBetterGanttChart::ActiveRecord::CallbackExtensions)
  end

  unless Issue.included_modules.include? RedmineBetterGanttChart::IssueDependencyPatch
    Issue.send(:include, RedmineBetterGanttChart::IssueDependencyPatch)
  end

  unless Issue.included_modules.include? RedmineBetterGanttChart::IssuePatch
    Issue.send(:include, RedmineBetterGanttChart::IssuePatch)
  end

  unless Project.included_modules.include? RedmineBetterGanttChart::ProjectPatch
    Project.send(:include, RedmineBetterGanttChart::ProjectPatch)
  end

  unless GanttsController.included_modules.include? RedmineBetterGanttChart::GanttsControllerPatch
    GanttsController.send(:include, RedmineBetterGanttChart::GanttsControllerPatch)
  end
end

require 'redmine_better_gantt_chart/redmine_better_gantt_chart'
require 'redmine_better_gantt_chart/calendar'
require 'redmine_better_gantt_chart/hooks/view_issues_show_details_bottom_hook'

Redmine::Plugin.register :redmine_better_gantt_chart do
  name 'Redmine Better Gantt Chart plugin'
  author 'Alexey Kuleshov'
  description 'This plugin improves Redmine Gantt Chart'
  version '0.6.3'
  url 'https://github.com/kulesa/redmine_better_gantt_chart'
  author_url 'http://github.com/kulesa'

  requires_redmine :version_or_higher => '1.1.0'

  #git@github.com:kslazarev/redmine_closed_issue.git
  #requires_redmine_plugin :redmine_closed_issue, '0.0.2'

  settings(:default => {
    'work_on_weekends' => true
  }, :partial => "settings/better_gantt_chart_settings")

  permission :view_time_periods_statistics, {:time_balances => [:index, :vote]}
  menu :project_menu, :time_balances, {:controller => 'time_balances', :action => 'index'}, :caption => :time_balances, :after => :gantt, :param => :project_id
end
