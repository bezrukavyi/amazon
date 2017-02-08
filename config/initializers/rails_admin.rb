RailsAdmin.config do |config|
  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.parent_controller = 'ApplicationController'

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    bulk_delete
    show
    edit
    delete do
      except ['Order, OrderItem']
    end
    show_in_app
    state

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Order' do
    list do
      scopes [:with_users]
      fields :id, :created_at
      field :state, :state
    end
    edit do
      field :state, :enum do
        enum_method do
          :assm_states
        end
      end
      include_all_fields
    end

    state({ states: {
      processing: 'btn-info',
      in_progress: 'btn-primary',
      in_transit: 'btn-warning',
      delivered: 'btn-success',
      canceled: 'btn-danger' } })
  end


  config.model 'Book' do
    list do
      scopes [:with_authors]
      fields :avatar, :category, :title, :authors, :desc, :price
    end
    exclude_fields :orders, :order_items
  end

  config.model 'Author' do
    fields :first_name, :last_name, :desc
  end

  config.model 'Category' do
    list do
      fields :title, :books_count
    end
    edit do
      fields :title
    end
  end

  config.model 'Review' do
    fields :book, :created_at, :user, :approved, :verified
    edit do
      exclude_fields :verified
    end
  end

  config.model 'Country' do
    fields :name, :code, :deliveries
  end

  config.model 'Delivery' do
    exclude_fields :id, :created_at, :updated_at
  end

  config.model 'Material' do
    exclude_fields :id, :created_at, :updated_at, :books
  end

end
