class TimeBalancesController < ApplicationController
  unloadable
  menu_item :time_balances
  before_filter :find_project

  def index
    users = User.all

    @from = params[:from] || Date.today.beginning_of_month
    @to = params[:to] || Date.today.end_of_month

    @results = []
    users.each_with_index do |user, index|
      issues = Issue.find(:all,
        :conditions => [
          "assigned_to_id = ? AND complete_date <> 'NULL' AND (? < due_date AND due_date < ?)",
          user.id,
          @from,
          @to
        ]
      )

      general_issues_count = issues.count
      success_issues_count = issues.select(&:complete_in_time?).count
      failure_issues_count = issues.count - success_issues_count
      sum_time_difference = issues.map(&:miss_time).sum

      @results << {
        :num => index,
        :user_name => user.name(:firstname_lastname),
        :general_issues_count => general_issues_count || 0,
        :success_issues_count => success_issues_count || 0,
        :failure_issues_count => failure_issues_count || 0,
        :sum_time_difference => sum_time_difference || 0
      }
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end
end