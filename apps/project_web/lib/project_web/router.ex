defmodule ProjectWeb.Router do
  use ProjectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ProjectWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug ProjectWeb.Plugs.ApiAuth
  end

  if Mix.env == :dev do
   forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  scope "/", ProjectWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/users/new", UserController, :new
    post "/users", UserController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout

    get "/products", ProductController, :overview
    get "/products/filter", ProductController, :filter
    get "/products/:product_id", ProductController, :show

  end

  scope "/", ProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/user_scope", PageController, :user_index

    get "/users", UserController, :overview
    get "/users/:user_id", UserController, :show
    get "/verify", UserController, :update_verification

    get "/cart", CartController, :show
    get "/cartOrder", OrderController, :create
    resources "/cart", CartController, only: [:update, :delete, :show]

    resources "/delivery_address", DeliveryAddressController, only: [:new, :create]

    get "/order", OrderController, :overview
    get "/order/:order_id", OrderController, :show


  end

  scope "/admin", ProjectWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    get "/", PageController, :admin_index

    get "/users/:user_id/edit", UserController, :edit
    put "/users/:user_id", UserController, :update
    patch "/users/:user_id", UserController, :update
    get "/users/:user_id/", UserController, :delete
    delete "/users/:user_id", UserController, :delete

    #resources "/users", UserController, only: [:show] do
    resources "/api-keys", ApiKeyController, only: [:create]
    #end

    get "/products/new", ProductController, :new
    post "/products", ProductController, :create
    post "/productsBulk", ProductController, :createBulk

    get "/products/:product_id/edit", ProductController, :edit
    put "/products/:product_id", ProductController, :update
    patch "/products/:product_id", ProductController, :update
    get "/products/:product_id/", ProductController, :delete
    delete "/products/:product_id", ProductController, :delete

  end

  scope "/api", ProjectWeb.Api, as: :api do
    pipe_through :api
    resources "/products", ProductController, only: [:show, :index]

    pipe_through :api_auth
    resources "/users", UserController, only: [:show, :index]

  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ProjectWeb.Telemetry
    end
  end

  pipeline :auth do
    plug ProjectWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :allowed_for_users do
    plug ProjectWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug ProjectWeb.Plugs.AuthorizationPlug, ["Admin"]
  end
end
