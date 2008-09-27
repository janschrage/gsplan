class AuditSweeper < ActionController::Caching::Sweeper
  observe Project,Teamcommitment

  def after_destroy(record)
    log(record, "DESTROY" )
  end

  def after_update(record)
    log(record, "UPDATE" )
  end

  def after_create(record)
    log(record, "CREATE" )
  end

  def log(record, event, user = controller.session[:user_id])
    AuditTrail.create(:record_id => record.id, :record_type => record.type.name, :event => event, :user_id => user)
  end
end
