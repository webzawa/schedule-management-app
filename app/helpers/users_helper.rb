module UsersHelper
  def search_work_store_name(id)
    if id.present?
      store = Store.find(id)
      name = store.storename
    end
  end
end
