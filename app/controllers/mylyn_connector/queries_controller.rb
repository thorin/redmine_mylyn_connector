require File.dirname(__FILE__) + '/../../../lib/mylyn_connector'

class MylynConnector::QueriesController < MylynConnector::ApplicationController
  unloadable

  accept_api_auth :all
  skip_before_filter :verify_authenticity_token
  helper MylynConnector::MylynHelper

  def all

    @queries = Query.joins("left join #{Project.table_name} on project_id=#{Project.table_name}.id").
      where("(#{Query.table_name}.visibility = ? OR #{Query.table_name}.user_id = ?) AND (project_id IS NULL OR #{Project.visible_condition(User.current)})", Query::VISIBILITY_PUBLIC, User.current.id).
      order(:name => :asc)

    respond_to do |format|
      format.xml {render :layout => nil}
    end
  end
end
