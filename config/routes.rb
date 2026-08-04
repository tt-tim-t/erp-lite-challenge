Rails.application.routes.draw do
  namespace :api do
    resources :style_purchase_orders, only: %i[index show update] do
      member do
        patch :submit_for_review
        patch :send_to_production
        patch :cancel
      end
    end

    resources :colorway_items, only: :update do
      member do
        patch :cancel
      end

      resource :cost_sheet, only: :show do
        patch :approve
        patch :lock
      end
    end

    resources :fabrics, only: :index do
      member do
        get :availability
      end
    end

    resources :vendors, only: :index
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
